# AWS Terraform Modules

This repository contains reusable Terraform modules for AWS infrastructure components. These modules are designed to be used with Terraform Enterprise (TFE) and follow infrastructure-as-code best practices.

## Available Modules

- **EC2**: AWS EC2 instance module with configurable instance types, security groups, and IAM roles
- **S3**: S3 bucket module with encryption, versioning, and lifecycle policies
- **RDS**: RDS instance module with support for various database engines
- **RDS Proxy**: RDS Proxy module for connection pooling and management

## Module Structure

```
.
├── modules/
│   ├── ec2/
│   ├── s3/
│   ├── rds/
│   └── rds-proxy/
├── examples/
│   ├── ec2/
│   ├── s3/
│   ├── rds/
│   └── rds-proxy/
└── environments/
    ├── dev/
    ├── staging/
    └── prod/
```

## Usage

Each module can be used independently or combined to create complex infrastructure. See the examples directory for usage patterns.

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 5.0.0
- AWS Account with appropriate permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License 