provider "aws" {
  region = "us-west-2"  # AWS region where the S3 bucket will be created
}

# Data sources for existing resources
data "aws_vpc" "default" {
  default = true
}

data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"  # Use AWS managed KMS key for S3
}

module "s3" {
  source = "../../modules/s3"  # Path to the S3 module

  # Basic bucket configuration
  bucket_name = "example-bucket-123456789"  # Globally unique name for your S3 bucket
  enable_versioning = true  # Keeps multiple versions of objects for backup and rollback

  # Lifecycle rules to manage object storage and deletion
  lifecycle_rules = [
    {
      id     = "transition-to-ia"
      status = "Enabled"
      transitions = [
        {
          days          = 90
          storage_class = "STANDARD_IA"  # Move to Infrequent Access after 90 days
        },
        {
          days          = 180
          storage_class = "GLACIER"      # Archive to Glacier after 180 days
        }
      ]
      expiration = {
        days = 365  # Delete objects after 1 year
      }
    }
  ]

  # CORS configuration to allow web applications to access the bucket
  cors_rules = [
    {
      allowed_headers = ["*"]  # Allow all headers
      allowed_methods = ["GET", "PUT", "POST"]  # Allowed HTTP methods
      allowed_origins = ["https://example.com"]  # Allowed website domains
      expose_headers  = ["ETag"]  # Headers that browsers are allowed to access
      max_age_seconds = 3000  # How long browsers should cache the CORS configuration
    }
  ]

  # Security settings to prevent public access
  block_public_acls       = true  # Block public ACLs
  block_public_policy     = true  # Block public bucket policies
  ignore_public_acls      = true  # Ignore public ACLs
  restrict_public_buckets = true  # Restrict public bucket access

  # Encryption configuration
  kms_key_id = data.aws_kms_key.s3.arn  # Use AWS managed KMS key for S3

  # Resource tags for better organization and cost tracking
  tags = {
    Environment = "example"
    Project     = "terraform-modules"
  }
}

# Output values that can be used by other modules or displayed after apply
output "bucket_id" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = module.s3.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = module.s3.bucket_regional_domain_name
} 