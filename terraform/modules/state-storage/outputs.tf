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
