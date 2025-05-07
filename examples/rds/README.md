# RDS Module Example

This example demonstrates how to use the RDS module to create a PostgreSQL database instance in AWS with high availability and security best practices.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- An existing VPC with at least 2 subnets in different Availability Zones
- AWS Secrets Manager (recommended for production)

## Features

- PostgreSQL 14.7 database instance
- Multi-AZ deployment option
- Automated backups with configurable retention
- Performance Insights enabled
- Security group with restricted access
- Parameter group with logging enabled
- Storage autoscaling
- Encryption at rest
- Resource tagging

## Usage

1. Copy the example configuration:

```bash
cp main.tf.example main.tf
```

2. Update the required variables in `terraform.tfvars`:

```hcl
vpc_id      = "vpc-12345678"
subnet_ids  = ["subnet-12345678", "subnet-87654321"]
vpc_cidr    = "10.0.0.0/16"
db_password = "your-secure-password"  # Use AWS Secrets Manager in production
```

3. Initialize Terraform:

```bash
terraform init
```

4. Review the execution plan:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region where resources will be created | `string` | `"us-west-2"` | no |
| vpc_id | ID of the VPC where the database will be created | `string` | n/a | yes |
| subnet_ids | IDs of subnets for the database (minimum 2 for high availability) | `list(string)` | n/a | yes |
| db_name | Name of the database to create | `string` | `"exampledb"` | no |
| db_username | Master username for the database | `string` | `"dbadmin"` | no |
| db_password | Master password for the database | `string` | n/a | yes |
| instance_class | RDS instance class | `string` | `"db.t3.micro"` | no |
| allocated_storage | Initial storage size in GB | `number` | `20` | no |
| max_allocated_storage | Maximum storage size for autoscaling | `number` | `100` | no |
| backup_retention_period | Number of days to retain automated backups | `number` | `7` | no |
| multi_az | Enable Multi-AZ deployment for high availability | `bool` | `false` | no |
| publicly_accessible | Allow public access to the database | `bool` | `false` | no |
| vpc_cidr | CIDR block of the VPC for security group rules | `string` | n/a | yes |
| environment | Environment name for tagging | `string` | `"example"` | no |
| project | Project name for tagging | `string` | `"terraform-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | ID of the RDS instance |
| db_instance_address | Address of the RDS instance |
| db_instance_endpoint | Endpoint of the RDS instance |
| db_instance_name | Name of the RDS instance |
| db_instance_port | Port of the RDS instance |
| db_instance_username | Username of the RDS instance |
| db_instance_status | Status of the RDS instance |
| db_subnet_group_id | ID of the DB subnet group |
| db_parameter_group_id | ID of the DB parameter group |
| security_group_id | ID of the security group |

## Security Considerations

1. **Password Management**:
   - Use AWS Secrets Manager to store database credentials
   - Rotate passwords regularly
   - Use strong password policies

2. **Network Security**:
   - Restrict access to the database using security groups
   - Use private subnets for the database
   - Enable SSL/TLS for connections

3. **Encryption**:
   - Enable encryption at rest
   - Use AWS KMS for key management
   - Enable SSL/TLS for connections

4. **Backup and Recovery**:
   - Enable automated backups
   - Configure appropriate retention periods
   - Test backup restoration regularly

## Maintenance

1. **Updates**:
   - Monitor for available engine updates
   - Plan maintenance windows during low-traffic periods
   - Test updates in non-production environments first

2. **Monitoring**:
   - Enable Performance Insights
   - Set up CloudWatch alarms
   - Monitor storage usage and growth

3. **Scaling**:
   - Monitor performance metrics
   - Adjust instance class as needed
   - Configure storage autoscaling

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This example is released under the MIT License. 