# S3 Module Example

This example demonstrates how to use the S3 module to create a secure and well-configured S3 bucket in AWS with versioning, lifecycle rules, and CORS configuration.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- AWS KMS key (optional, for custom encryption)

## Features

- Versioning enabled
- Lifecycle rules for cost optimization
- CORS configuration for web access
- Server-side encryption
- Public access blocking
- Intelligent tiering
- Resource tagging

## Usage

1. Copy the example configuration:

```bash
cp main.tf.example main.tf
```

2. Update the required variables in `terraform.tfvars`:

```hcl
bucket_name = "your-unique-bucket-name"
environment = "prod"
project     = "my-project"
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
| bucket_name | Globally unique name for your S3 bucket | `string` | n/a | yes |
| enable_versioning | Enable versioning for the bucket | `bool` | `true` | no |
| lifecycle_rules | List of lifecycle rules for the bucket | `list(object)` | `[]` | no |
| cors_rules | List of CORS rules for the bucket | `list(object)` | `[]` | no |
| block_public_acls | Block public ACLs | `bool` | `true` | no |
| block_public_policy | Block public bucket policies | `bool` | `true` | no |
| ignore_public_acls | Ignore public ACLs | `bool` | `true` | no |
| restrict_public_buckets | Restrict public bucket access | `bool` | `true` | no |
| environment | Environment name for tagging | `string` | `"example"` | no |
| project | Project name for tagging | `string` | `"terraform-modules"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | Name of the S3 bucket |
| bucket_arn | ARN of the S3 bucket |
| bucket_domain_name | Domain name of the S3 bucket |
| bucket_regional_domain_name | Regional domain name of the S3 bucket |

## Security Considerations

1. **Access Control**:
   - Use bucket policies for fine-grained access control
   - Enable public access blocking
   - Use IAM roles and policies
   - Implement least privilege principle

2. **Encryption**:
   - Enable server-side encryption
   - Use AWS KMS for key management
   - Enable SSL/TLS for transfers

3. **Versioning**:
   - Enable versioning for data protection
   - Configure lifecycle rules for cost management
   - Implement MFA Delete for critical data

4. **Monitoring**:
   - Enable access logging
   - Set up CloudWatch metrics
   - Configure event notifications

## Lifecycle Rules

The example includes a lifecycle rule that:
1. Transitions objects to STANDARD_IA after 90 days
2. Archives objects to GLACIER after 180 days
3. Deletes objects after 365 days

Customize these rules based on your data retention requirements.

## CORS Configuration

The example includes a CORS rule that:
1. Allows GET, PUT, and POST methods
2. Allows all headers
3. Allows access from example.com
4. Exposes the ETag header
5. Caches the CORS configuration for 3000 seconds

Update the CORS rules based on your application's requirements.

## Maintenance

1. **Monitoring**:
   - Monitor bucket size and object count
   - Track API requests and errors
   - Set up cost alerts

2. **Lifecycle Management**:
   - Review and update lifecycle rules
   - Monitor storage class transitions
   - Clean up incomplete multipart uploads

3. **Security**:
   - Regularly audit bucket policies
   - Review access logs
   - Rotate encryption keys

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

Note: This will delete all objects in the bucket. Make sure to backup any important data first.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This example is released under the MIT License. 