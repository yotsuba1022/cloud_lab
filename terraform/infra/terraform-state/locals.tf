locals {
  prefix = "${var.env}-${var.module_name}"
  common_tags = {
    Name        = "${local.prefix}"
    Environment = var.env
    Project     = var.module_name
    ManagedBy   = "Terraform"
  }
} 