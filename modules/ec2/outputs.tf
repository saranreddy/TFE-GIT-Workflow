output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.this.arn
} 