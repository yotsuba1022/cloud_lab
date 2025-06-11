data "aws_caller_identity" "current" {}

resource "aws_kms_key" "state_storage_encryption" {
  description             = "KMS key for state storage encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}-kms" }
  )
}

resource "aws_kms_alias" "state_storage_encryption" {
  name          = "alias/${local.prefix}-kms-key"
  target_key_id = aws_kms_key.state_storage_encryption.key_id
}

resource "aws_kms_key_policy" "state_storage_encryption" {
  key_id = aws_kms_key.state_storage_encryption.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAccountRoot"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowFederatedUsers"
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:sts::362395300803:assumed-role/AWSReservedSSO_admin_76a22123d22e66e7/clu-admin",
            "arn:aws:sts::362395300803:assumed-role/AWSReservedSSO_dev_e86f1833a1f72c5a/clu-dev"
          ]
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowS3UseKey"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}
