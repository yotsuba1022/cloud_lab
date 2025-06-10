output "archive_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.archive_box.id
}

output "archive_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.archive_box.arn
}
