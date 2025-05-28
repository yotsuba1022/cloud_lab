resource "aws_s3_bucket" "state_storage" {
  bucket = "${local.prefix}-s3"

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-s3" })
}

resource "aws_s3_bucket_versioning" "state_storage" {
  bucket = aws_s3_bucket.state_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_storage" {
  bucket = aws_s3_bucket.state_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state_storage" {
  bucket = aws_s3_bucket.state_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
