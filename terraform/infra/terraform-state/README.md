# Terraform State Management

This module is used to create and manage remote Terraform state storage. It creates:
- S3 bucket for storing Terraform state files
- DynamoDB table for state locking

## Prerequisites

- AWS CLI installed and configured
- AWS SSO login completed
- Using a profile with sufficient permissions

## Usage

1. Initialize Terraform:
```bash
terraform init
```

2. Run plan:
```bash
terraform plan -var-file="common.tfvars"
```

3. Apply changes:
```bash
terraform apply -var-file="common.tfvars"
```

4. Destroy resources (if needed):
```bash
terraform destroy -var-file="common.tfvars"
```

## Variables

| Variable Name | Description | Example |
|--------------|-------------|---------|
| env | Environment name | dev |
| module_name | Module name | infra |
| aws_region | AWS region | ap-northeast-1 |

## Outputs

| Output Name | Description |
|------------|-------------|
| s3_bucket_name | S3 bucket name |
| s3_bucket_arn | S3 bucket ARN |
| dynamodb_table_name | DynamoDB table name |
| dynamodb_table_arn | DynamoDB table ARN |

## Notes

1. Resources created by this module are for Terraform state storage only
2. Ensure using the correct AWS profile
3. It's recommended not to set `prevent_destroy` in development environments
