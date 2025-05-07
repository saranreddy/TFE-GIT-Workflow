variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-west-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[1-9][0-9]*$", var.aws_region))
    error_message = "The aws_region value must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the database will be created"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "The vpc_id value must be a valid VPC ID format (e.g., vpc-12345678)."
  }
}

variable "subnet_ids" {
  description = "IDs of subnets for the database (minimum 2 for high availability)"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least 2 subnet IDs are required for high availability."
  }

  validation {
    condition     = alltrue([for subnet in var.subnet_ids : can(regex("^subnet-[a-z0-9]+$", subnet))])
    error_message = "All subnet IDs must be in valid format (e.g., subnet-12345678)."
  }
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "exampledb"

  validation {
    condition     = can(regex("^[a-z][a-z0-9_]*$", var.db_name))
    error_message = "Database name must start with a letter and contain only lowercase letters, numbers, and underscores."
  }
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.db_username))
    error_message = "Username must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "db_password" {
  description = "Master password for the database (use AWS Secrets Manager in production)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Password must be at least 8 characters long."
  }
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = can(regex("^db\\.[a-z0-9]+\\.[a-z0-9]+$", var.instance_class))
    error_message = "Instance class must be a valid RDS instance class (e.g., db.t3.micro)."
  }
}

variable "allocated_storage" {
  description = "Initial storage size in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 65536
    error_message = "Allocated storage must be between 20 and 65536 GB."
  }
}

variable "max_allocated_storage" {
  description = "Maximum storage size for autoscaling"
  type        = number
  default     = 100

  validation {
    condition     = var.max_allocated_storage >= var.allocated_storage
    error_message = "Maximum allocated storage must be greater than or equal to initial allocated storage."
  }
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Allow public access to the database"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC for security group rules"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", var.vpc_cidr))
    error_message = "VPC CIDR must be a valid CIDR block (e.g., 10.0.0.0/16)."
  }
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "example"

  validation {
    condition     = contains(["dev", "staging", "prod", "example"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, example."
  }
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "terraform-modules"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
} 