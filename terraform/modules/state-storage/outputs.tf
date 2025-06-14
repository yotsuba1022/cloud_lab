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
