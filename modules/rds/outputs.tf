output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_instance_address" {
  description = "Address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_name" {
  description = "Name of the RDS instance"
  value       = aws_db_instance.this.name
}

output "db_instance_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.this.port
}

output "db_instance_username" {
  description = "Master username of the RDS instance"
  value       = aws_db_instance.this.username
  sensitive   = true
}

output "db_instance_status" {
  description = "Status of the RDS instance"
  value       = aws_db_instance.this.status
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.this.id
}

output "db_parameter_group_id" {
  description = "ID of the DB parameter group"
  value       = aws_db_parameter_group.this.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
} 