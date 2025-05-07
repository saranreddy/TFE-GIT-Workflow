provider "aws" {
  region = "us-west-2"  # AWS region where resources will be created
}

# First, create an RDS instance that will be proxied
module "rds" {
  source = "../../modules/rds"  # Path to the RDS module

  # Basic instance configuration
  name_prefix = "example-db"  # Prefix for all resource names
  vpc_id      = "vpc-12345678"  # ID of the VPC where the database will be created
  subnet_ids  = ["subnet-12345678", "subnet-87654321"]  # IDs of subnets for the database (minimum 2 for high availability)

  # Database engine configuration
  identifier = "example-postgres"  # Unique identifier for the RDS instance
  engine     = "postgres"  # Database engine type
  engine_version = "14.7"  # PostgreSQL version
  instance_class = "db.t3.micro"  # Instance size (1 vCPU, 1GB RAM)

  # Database credentials
  db_name  = "exampledb"  # Name of the database to create
  username = "dbadmin"    # Master username
  password = "changeme123"  # Master password (use AWS Secrets Manager in production)

  # Database parameter group configuration
  parameter_group_family = "postgres14"  # Parameter group family for PostgreSQL 14
  parameter_group_parameters = [
    {
      name  = "log_connections"  # Enable connection logging
      value = "1"
    },
    {
      name  = "log_disconnections"  # Enable disconnection logging
      value = "1"
    }
  ]

  # Storage configuration
  allocated_storage     = 20  # Initial storage size in GB
  max_allocated_storage = 100  # Maximum storage size for autoscaling
  storage_type         = "gp2"  # Storage type (general purpose SSD)
  storage_encrypted    = true  # Enable encryption at rest

  # Backup and maintenance configuration
  backup_retention_period = 7  # Number of days to retain automated backups
  backup_window          = "03:00-06:00"  # Daily backup window (UTC)
  maintenance_window     = "Mon:00:00-Mon:03:00"  # Weekly maintenance window (UTC)

  # High availability and security settings
  multi_az               = false  # Enable Multi-AZ deployment for high availability
  publicly_accessible    = false  # Prevent public access to the database
  skip_final_snapshot    = false  # Create a final snapshot when deleting
  final_snapshot_identifier = "example-postgres-final-snapshot"  # Name of the final snapshot

  # Performance monitoring
  performance_insights_enabled          = true  # Enable Performance Insights
  performance_insights_retention_period = 7  # Days to retain performance data

  # Security group rules to control network access
  ingress_rules = [
    {
      from_port   = 5432  # PostgreSQL default port
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]  # Allow access only from within the VPC
      description = "Allow PostgreSQL access from VPC"
    }
  ]

  # Resource tags for better organization and cost tracking
  tags = {
    Environment = "example"
    Project     = "terraform-modules"
  }
}

# Then, create the RDS Proxy to manage database connections
module "rds_proxy" {
  source = "../../modules/rds-proxy"  # Path to the RDS Proxy module

  # Basic proxy configuration
  name_prefix = "example-proxy"  # Prefix for all resource names
  name        = "example-postgres-proxy"  # Name of the RDS Proxy
  vpc_id      = "vpc-12345678"  # ID of the VPC where the proxy will be created
  subnet_ids  = ["subnet-12345678", "subnet-87654321"]  # IDs of subnets for the proxy

  # Security and encryption configuration
  secret_arn  = "arn:aws:secretsmanager:us-west-2:123456789012:secret:example-db-credentials"  # ARN of the secret containing database credentials
  kms_key_arn = "arn:aws:kms:us-west-2:123456789012:key/example-key"  # ARN of the KMS key for encryption

  # Proxy engine configuration
  engine_family = "POSTGRESQL"  # Database engine family
  debug_logging = true  # Enable detailed logging for troubleshooting

  # Connection management settings
  connection_borrow_timeout    = 120  # Maximum time to wait for a connection (seconds)
  max_connections_percent      = 100  # Maximum percentage of connections to use
  max_idle_connections_percent = 50   # Maximum percentage of idle connections to maintain

  # Target database configuration
  db_instance = module.rds.db_instance_id  # ID of the RDS instance to proxy

  # Proxy endpoint configuration
  db_proxy_endpoints = [
    {
      name                  = "example-endpoint"  # Name of the proxy endpoint
      vpc_security_group_ids = ["sg-12345678"]  # Security group for the endpoint
      vpc_subnet_ids        = ["subnet-12345678"]  # Subnet for the endpoint
    }
  ]

  # Security group rules to control network access
  ingress_rules = [
    {
      from_port   = 5432  # PostgreSQL default port
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]  # Allow access only from within the VPC
      description = "Allow PostgreSQL access from VPC"
    }
  ]

  # Resource tags for better organization and cost tracking
  tags = {
    Environment = "example"
    Project     = "terraform-modules"
  }
} 