terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  # Enable state locking with DynamoDB
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "rds-proxy/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
} 