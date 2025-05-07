terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Security group for RDS
resource "aws_security_group" "this" {
  name_prefix = "${var.name_prefix}-sg"
  vpc_id      = var.vpc_id
  description = "Security group for ${var.name_prefix} RDS instance"

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

# RDS subnet group
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-subnet-group"
    }
  )
}

# RDS parameter group
resource "aws_db_parameter_group" "this" {
  name   = "${var.name_prefix}-parameter-group"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.parameter_group_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-parameter-group"
    }
  )
}

# RDS instance
resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = var.storage_encrypted

  db_name  = var.db_name
  username = var.username
  password = var.password

  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name

  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  tags = merge(
    var.tags,
    {
      Name = var.identifier
    }
  )
} 