# EC2 Module Example

This example demonstrates how to use the EC2 module to create a secure and well-configured EC2 instance in AWS with proper networking, security, and storage settings.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- An existing VPC with at least one subnet
- An existing SSH key pair in AWS

## Features

- EC2 instance with configurable instance type
- Security group with customizable ingress rules
- EBS root volume with configurable size and type
- IAM role and instance profile
- User data script support
- Resource tagging
- CloudWatch monitoring

## Usage

1. Copy the example configuration:

```bash
cp main.tf.example main.tf
```

2. Update the required variables in `terraform.tfvars`:

```hcl
name_prefix = "example-instance"
vpc_id      = "vpc-12345678"
subnet_id   = "subnet-12345678"
ami_id      = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI in us-west-2
key_name    = "your-key-pair-name"
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
| vpc_id | ID of the VPC where the instance will be launched | `string` | n/a | yes |
| subnet_id | ID of the subnet where the instance will be placed | `string` | n/a | yes |
| ami_id | ID of the AMI to use for the instance | `string` | n/a | yes |
| instance_type | Type of instance to launch | `string` | `"t3.micro"` | no |
| key_name | Name of the SSH key pair to use | `string` | n/a | yes |
| ingress_rules | List of ingress rules for the security group | `list(object)` | `[]` | no |
| root_volume_size | Size of the root volume in GB | `number` | `20` | no |
| root_volume_type | Type of the root volume | `string` | `"gp3"` | no |
| environment | Environment name for tagging | `string` | `"example"` | no |
| project | Project name for tagging | `string` | `"terraform-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| instance_public_ip | Public IP address of the EC2 instance |
| instance_private_ip | Private IP address of the EC2 instance |
| security_group_id | ID of the security group |
| instance_arn | ARN of the EC2 instance |

## Security Considerations

1. **Network Security**:
   - Use security groups to restrict access
   - Place instances in private subnets when possible
   - Use the principle of least privilege for ingress rules
   - Consider using a bastion host for SSH access

2. **Instance Security**:
   - Use IAM roles instead of access keys
   - Enable detailed monitoring
   - Use encrypted EBS volumes
   - Keep the AMI updated

3. **Access Management**:
   - Use SSH key pairs for authentication
   - Rotate SSH keys regularly
   - Use AWS Systems Manager for instance management
   - Implement proper IAM policies

4. **Monitoring and Logging**:
   - Enable CloudWatch monitoring
   - Set up CloudWatch alarms
   - Configure detailed monitoring
   - Use CloudTrail for API logging

## Maintenance

1. **Updates**:
   - Keep the AMI updated
   - Apply security patches regularly
   - Update instance type if needed
   - Monitor instance performance

2. **Monitoring**:
   - Set up CloudWatch alarms
   - Monitor CPU and memory usage
   - Track network traffic
   - Monitor disk usage

3. **Backup**:
   - Create AMI backups regularly
   - Use EBS snapshots for data
   - Test backup restoration
   - Implement backup retention policies

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

Note: This will terminate the EC2 instance and delete associated resources. Make sure to backup any important data first.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This example is released under the MIT License. 