variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
}

variable "name" {
  description = "Name of the RDS Proxy"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the RDS Proxy will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS Proxy"
  type        = list(string)
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for encryption"
  type        = string
}

variable "engine_family" {
  description = "Engine family of the RDS Proxy"
  type        = string
  default     = "POSTGRESQL"
}

variable "debug_logging" {
  description = "Whether to enable debug logging"
  type        = bool
  default     = false
}

variable "idle_client_timeout" {
  description = "Number of seconds when a connection can remain idle"
  type        = number
  default     = 1800
}

variable "require_tls" {
  description = "Whether to require TLS for connections"
  type        = bool
  default     = true
}

variable "connection_borrow_timeout" {
  description = "Number of seconds for a connection to remain borrowed"
  type        = number
  default     = 120
}

variable "init_query" {
  description = "Initial query to run when a connection is established"
  type        = string
  default     = null
}

variable "max_connections_percent" {
  description = "Maximum percentage of connections that can be used"
  type        = number
  default     = 100
}

variable "max_idle_connections_percent" {
  description = "Maximum percentage of idle connections that can be used"
  type        = number
  default     = 50
}

variable "session_pinning_filters" {
  description = "List of session pinning filters"
  type        = list(string)
  default     = []
}

variable "db_instance" {
  description = "ID of the RDS instance to proxy"
  type        = string
}

variable "db_proxy_endpoints" {
  description = "List of DB proxy endpoints"
  type = list(object({
    name                  = string
    vpc_security_group_ids = list(string)
    vpc_subnet_ids        = list(string)
  }))
  default = []
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
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 