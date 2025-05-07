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
    error_message = "Name prefix must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the instance will be launched"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "The vpc_id value must be a valid VPC ID format (e.g., vpc-12345678)."
  }
}

variable "subnet_id" {
  description = "ID of the subnet where the instance will be placed"
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-z0-9]+$", var.subnet_id))
    error_message = "The subnet_id value must be a valid subnet ID format (e.g., subnet-12345678)."
  }
}

variable "ami_id" {
  description = "ID of the AMI to use for the instance"
  type        = string

  validation {
    condition     = can(regex("^ami-[a-z0-9]+$", var.ami_id))
    error_message = "The ami_id value must be a valid AMI ID format (e.g., ami-12345678)."
  }
}

variable "instance_type" {
  description = "Type of instance to launch"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.instance_type))
    error_message = "The instance_type value must be a valid AWS instance type (e.g., t3.micro)."
  }
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.key_name))
    error_message = "Key name must contain only letters, numbers, and hyphens."
  }
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  validation {
    condition     = alltrue([for rule in var.ingress_rules : rule.from_port >= 0 && rule.from_port <= 65535])
    error_message = "From port must be between 0 and 65535."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : rule.to_port >= 0 && rule.to_port <= 65535])
    error_message = "To port must be between 0 and 65535."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : contains(["tcp", "udp", "icmp", "-1"], rule.protocol)])
    error_message = "Protocol must be one of: tcp, udp, icmp, or -1."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : alltrue([for cidr in rule.cidr_blocks : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", cidr))])])
    error_message = "CIDR blocks must be in valid format (e.g., 10.0.0.0/16)."
  }
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 and 16384 GB."
  }
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Root volume type must be one of: standard, gp2, gp3, io1, io2."
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