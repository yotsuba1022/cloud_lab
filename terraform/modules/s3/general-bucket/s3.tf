resource "aws_s3_bucket" "toy_box" {
  bucket = "${local.prefix}-toy-box"

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-toy-box" })
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.toy_box.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.toy_box.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "object_lifecycle_policy" {
  bucket = aws_s3_bucket.toy_box.id

  rule {
    id     = "delete-expired-objects"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 7
    }
  }
}
