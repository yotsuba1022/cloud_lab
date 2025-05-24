locals {
  prefix = "${var.module_name}-${var.environment}"
  common_tags = {
    Project     = var.module_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}