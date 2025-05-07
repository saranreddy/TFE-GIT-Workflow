provider "aws" {
  region = "us-west-2"  # AWS region where resources will be created
}

module "ec2" {
  source = "../../modules/ec2"  # Path to the EC2 module

  # Basic instance configuration
  name_prefix    = "example-instance"  # Prefix for all resource names
  vpc_id         = "vpc-12345678"      # ID of the VPC where the instance will be launched
  subnet_id      = "subnet-12345678"   # ID of the subnet where the instance will be placed
  ami_id         = "ami-0c55b159cbfafe1f0"  # Amazon Machine Image ID (Amazon Linux 2 in us-west-2)
  instance_type  = "t3.micro"          # Instance size (1 vCPU, 1GB RAM)
  key_name       = "example-key"       # Name of the SSH key pair for instance access

  # Security group rules to control network access
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]  # Allow SSH access only from within the VPC
      description = "Allow SSH from VPC"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]    # Allow HTTP access from anywhere (consider restricting in production)
      description = "Allow HTTP from anywhere"
    }
  ]

  # Storage configuration
  root_volume_size = 20  # Size of the root volume in GB
  root_volume_type = "gp3"  # Volume type (gp3 is the latest generation of general-purpose SSD)

  # Resource tags for better organization and cost tracking
  tags = {
    Environment = "example"
    Project     = "terraform-modules"
  }
}

# Output values that can be used by other modules or displayed after apply
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = module.ec2.instance_private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.ec2.security_group_id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = module.ec2.instance_arn
} 