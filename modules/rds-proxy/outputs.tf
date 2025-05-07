output "db_proxy_id" {
  description = "ID of the RDS Proxy"
  value       = aws_db_proxy.this.id
}

output "db_proxy_arn" {
  description = "ARN of the RDS Proxy"
  value       = aws_db_proxy.this.arn
}

output "db_proxy_endpoint" {
  description = "Endpoint of the RDS Proxy"
  value       = aws_db_proxy.this.endpoint
}

output "db_proxy_target_group_id" {
  description = "ID of the RDS Proxy target group"
  value       = aws_db_proxy_default_target_group.this.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
} 