provider "aws" {
  region = "us-west-2"  # AWS region where the RDS instance will be created
}

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

  # Storage configuration
  allocated_storage     = 20  # Initial storage size in GB
  max_allocated_storage = 100  # Maximum storage size for autoscaling
  storage_type         = "gp2"  # Storage type (general purpose SSD)
  storage_encrypted    = true  # Enable encryption at rest

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