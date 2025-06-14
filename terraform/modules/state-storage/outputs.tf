output "storage_name" {
  description = "The name of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.state_storage.id
}

output "storage_arn" {
  description = "The ARN of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.state_storage.arn
}

output "lock_table_name" {
  description = "The name of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.state_locks.name
}

output "lock_table_arn" {
  description = "The ARN of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.state_locks.arn
}

output "kms_key_id" {
  description = "The ID of the KMS key used for encryption"
  value       = aws_kms_key.state_storage_encryption.key_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for encryption"
  value       = aws_kms_key.state_storage_encryption.arn
}

output "kms_key_alias" {
  description = "The alias of the KMS key used for encryption"
  value       = aws_kms_alias.state_storage_encryption.name
}

output "kms_key_policy" {
  description = "The policy of the KMS key used for encryption"
  value       = aws_kms_key_policy.state_storage_encryption.policy
}

output "default_vpc_id" {
  description = "The ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "default_security_group_id" {
  description = "The ID of the default security group"
  value       = data.aws_security_group.default.id
}

output "default_subnet_ids" {
  description = "List of default subnet IDs"
  value       = data.aws_subnets.default.ids
}

output "default_subnet_details" {
  description = "Map of default subnet details"
  value = { for k, v in data.aws_subnet.default : k => {
    id                = v.id
    availability_zone = v.availability_zone
    cidr_block        = v.cidr_block
  } }
}
