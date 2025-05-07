# RDS Proxy Module Example

This example demonstrates how to use the RDS Proxy module to create a secure and scalable database proxy for your RDS instances. The RDS Proxy helps manage database connections and provides connection pooling, which can improve application performance and reduce database load.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- An existing VPC with at least two subnets in different Availability Zones
- An existing RDS instance
- AWS Secrets Manager secret containing database credentials
- AWS KMS key for encryption

## Features

- RDS Proxy with connection pooling
- IAM role and policy for proxy access
- Security group with customizable ingress rules
- Support for multiple database engines (PostgreSQL, MySQL, MariaDB)
- TLS encryption for connections
- Debug logging capability
- Configurable connection timeouts and limits
- Resource tagging

## Usage

1. Copy the example configuration:

```bash
cp main.tf.example main.tf
```

2. Update the required variables in `terraform.tfvars`:

```hcl
name_prefix = "example-proxy"
name        = "my-db-proxy"
vpc_id      = "vpc-12345678"
subnet_ids  = ["subnet-12345678", "subnet-87654321"]
secret_arn  = "arn:aws:secretsmanager:region:account:secret:db-credentials"
kms_key_arn = "arn:aws:kms:region:account:key/key-id"
db_instance = "my-db-instance"
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
| name_prefix | Prefix for all resource names | `string` | n/a | yes |
| name | Name of the RDS Proxy | `string` | n/a | yes |
| vpc_id | ID of the VPC where the proxy will be created | `string` | n/a | yes |
| subnet_ids | List of subnet IDs for the proxy | `list(string)` | n/a | yes |
| secret_arn | ARN of the Secrets Manager secret | `string` | n/a | yes |
| kms_key_arn | ARN of the KMS key for encryption | `string` | n/a | yes |
| engine_family | Engine family of the RDS Proxy | `string` | `"POSTGRESQL"` | no |
| debug_logging | Whether to enable debug logging | `bool` | `false` | no |
| idle_client_timeout | Idle client timeout in seconds | `number` | `1800` | no |
| require_tls | Whether to require TLS for connections | `bool` | `true` | no |
| connection_borrow_timeout | Connection borrow timeout in seconds | `number` | `120` | no |
| max_connections_percent | Maximum percentage of connections | `number` | `100` | no |
| max_idle_connections_percent | Maximum percentage of idle connections | `number` | `50` | no |
| db_instance | ID of the RDS instance to proxy | `string` | n/a | yes |
| db_proxy_endpoints | List of DB proxy endpoints | `list(object)` | `[]` | no |
| ingress_rules | List of ingress rules for the security group | `list(object)` | `[]` | no |
| tags | Map of tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_proxy_id | ID of the RDS Proxy |
| db_proxy_arn | ARN of the RDS Proxy |
| db_proxy_endpoint | Endpoint of the RDS Proxy |
| db_proxy_target_group_id | ID of the RDS Proxy target group |
| security_group_id | ID of the security group |
| iam_role_arn | ARN of the IAM role |

## Security Considerations

1. **Network Security**:
   - Use security groups to restrict access
   - Place proxy in private subnets
   - Use the principle of least privilege for ingress rules
   - Enable TLS for all connections

2. **Authentication and Authorization**:
   - Use IAM authentication when possible
   - Store credentials in Secrets Manager
   - Rotate credentials regularly
   - Use least privilege IAM roles

3. **Encryption**:
   - Enable TLS for all connections
   - Use KMS for encryption
   - Encrypt data in transit
   - Encrypt data at rest

4. **Monitoring and Logging**:
   - Enable CloudWatch monitoring
   - Set up CloudWatch alarms
   - Enable debug logging when needed
   - Monitor connection metrics

## Maintenance

1. **Updates**:
   - Keep the proxy configuration updated
   - Monitor connection limits
   - Adjust timeouts as needed
   - Update security groups

2. **Monitoring**:
   - Monitor connection counts
   - Track connection errors
   - Monitor proxy latency
   - Set up appropriate alarms

3. **Scaling**:
   - Monitor connection utilization
   - Adjust max connections as needed
   - Consider adding read replicas
   - Monitor proxy endpoints

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

Note: This will delete the RDS Proxy and associated resources. Make sure to update your application configurations to point to the RDS instance directly before destroying the proxy.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This example is released under the MIT License. 