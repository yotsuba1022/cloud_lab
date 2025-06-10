output "general_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.toy_box.id
}

output "general_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.toy_box.arn
}
