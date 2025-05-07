variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[1-9][0-9]*$", var.aws_region))
    error_message = "The aws_region value must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "The name_prefix value must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "name" {
  description = "Name of the RDS Proxy"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "The name value must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the RDS Proxy will be created"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "The vpc_id value must be a valid VPC ID format (e.g., vpc-12345678)."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs where the RDS Proxy will be created"
  type        = list(string)

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-[a-z0-9]+$", id))])
    error_message = "All subnet_ids must be valid subnet ID formats (e.g., subnet-12345678)."
  }
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]+:secret:[a-zA-Z0-9/_+=.@-]+$", var.secret_arn))
    error_message = "The secret_arn value must be a valid Secrets Manager ARN format."
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]+:key/[a-z0-9-]+$", var.kms_key_arn))
    error_message = "The kms_key_arn value must be a valid KMS key ARN format."
  }
}

variable "engine_family" {
  description = "Engine family of the RDS Proxy"
  type        = string
  default     = "POSTGRESQL"

  validation {
    condition     = contains(["POSTGRESQL", "MYSQL", "MARIADB"], upper(var.engine_family))
    error_message = "The engine_family value must be one of: POSTGRESQL, MYSQL, or MARIADB."
  }
}

variable "debug_logging" {
  description = "Whether to enable debug logging"
  type        = bool
  default     = false
}

variable "idle_client_timeout" {
  description = "Number of seconds a client connection can be idle"
  type        = number
  default     = 1800

  validation {
    condition     = var.idle_client_timeout >= 0 && var.idle_client_timeout <= 3600
    error_message = "The idle_client_timeout value must be between 0 and 3600 seconds."
  }
}

variable "require_tls" {
  description = "Whether to require TLS for connections"
  type        = bool
  default     = true
}

variable "connection_borrow_timeout" {
  description = "Number of seconds for a connection to be borrowed from the pool"
  type        = number
  default     = 120

  validation {
    condition     = var.connection_borrow_timeout >= 0 && var.connection_borrow_timeout <= 120
    error_message = "The connection_borrow_timeout value must be between 0 and 120 seconds."
  }
}

variable "max_connections_percent" {
  description = "Maximum percentage of connections that can be used"
  type        = number
  default     = 100

  validation {
    condition     = var.max_connections_percent >= 1 && var.max_connections_percent <= 100
    error_message = "The max_connections_percent value must be between 1 and 100."
  }
}

variable "max_idle_connections_percent" {
  description = "Maximum percentage of idle connections that can be used"
  type        = number
  default     = 50

  validation {
    condition     = var.max_idle_connections_percent >= 0 && var.max_idle_connections_percent <= 100
    error_message = "The max_idle_connections_percent value must be between 0 and 100."
  }
}

variable "db_instance" {
  description = "ID of the RDS instance to proxy"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.db_instance))
    error_message = "The db_instance value must be a valid RDS instance identifier."
  }
}

variable "db_proxy_endpoints" {
  description = "List of DB proxy endpoints"
  type = list(object({
    name                   = string
    vpc_security_group_ids = list(string)
    vpc_subnet_ids        = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([
      for endpoint in var.db_proxy_endpoints : 
      can(regex("^[a-z0-9-]+$", endpoint.name)) &&
      alltrue([for sg in endpoint.vpc_security_group_ids : can(regex("^sg-[a-z0-9]+$", sg))]) &&
      alltrue([for subnet in endpoint.vpc_subnet_ids : can(regex("^subnet-[a-z0-9]+$", subnet))])
    ])
    error_message = "Each endpoint must have a valid name, security group IDs, and subnet IDs."
  }
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([
      for rule in var.ingress_rules :
      rule.from_port >= 0 && rule.from_port <= 65535 &&
      rule.to_port >= 0 && rule.to_port <= 65535 &&
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol) &&
      alltrue([for cidr in rule.cidr_blocks : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", cidr))])
    ])
    error_message = "Each ingress rule must have valid port ranges, protocol, and CIDR blocks."
  }
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9_.:/=+-@]+$", k)) && can(regex("^[a-zA-Z0-9_.:/=+-@]+$", v))])
    error_message = "Tag keys and values must contain only alphanumeric characters, underscores, periods, colons, slashes, equals signs, plus signs, hyphens, and at signs."
  }
} 