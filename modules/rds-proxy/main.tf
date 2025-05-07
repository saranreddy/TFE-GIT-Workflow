terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# IAM role for RDS Proxy
resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for RDS Proxy
resource "aws_iam_role_policy" "this" {
  name = "${var.name_prefix}-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ]
        Resource = [
          var.secret_arn,
          var.kms_key_arn
        ]
      }
    ]
  })
}

# Security group for RDS Proxy
resource "aws_security_group" "this" {
  name_prefix = "${var.name_prefix}-sg"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.name_prefix} RDS Proxy"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-sg"
    }
  )
}

# RDS Proxy
resource "aws_db_proxy" "this" {
  name                   = var.name
  debug_logging         = var.debug_logging
  engine_family         = var.engine_family
  idle_client_timeout   = var.idle_client_timeout
  require_tls           = var.require_tls
  role_arn              = aws_iam_role.this.arn
  vpc_security_group_ids = [aws_security_group.this.id]
  vpc_subnet_ids        = var.subnet_ids

  auth {
    auth_scheme = "SECRETS"
    description = "RDS Proxy authentication"
    iam_auth    = "DISABLED"
    secret_arn  = var.secret_arn
  }

  dynamic "db_proxy_endpoints" {
    for_each = var.db_proxy_endpoints
    content {
      db_proxy_endpoint_name = db_proxy_endpoints.value.name
      vpc_security_group_ids = db_proxy_endpoints.value.vpc_security_group_ids
      vpc_subnet_ids        = db_proxy_endpoints.value.vpc_subnet_ids
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# RDS Proxy target
resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name

  connection_pool_config {
    connection_borrow_timeout    = var.connection_borrow_timeout
    init_query                   = var.init_query
    max_connections_percent      = var.max_connections_percent
    max_idle_connections_percent = var.max_idle_connections_percent
    session_pinning_filters      = var.session_pinning_filters
  }
}

# RDS Proxy target group
resource "aws_db_proxy_target" "this" {
  db_proxy_name     = aws_db_proxy.this.name
  target_group_name = aws_db_proxy_default_target_group.this.name
  rds_instance_id   = var.db_instance
} 