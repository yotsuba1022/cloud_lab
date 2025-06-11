resource "aws_dynamodb_table" "state_locks" {
  name         = "${local.prefix}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.state_storage_encryption.arn
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-locks" }
  )
}
