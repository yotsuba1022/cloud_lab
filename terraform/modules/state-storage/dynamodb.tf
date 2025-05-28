resource "aws_dynamodb_table" "state_locks" {
  name         = "${local.prefix}-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-locks" })
}
