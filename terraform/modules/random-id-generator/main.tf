terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 1.11.4"
}

resource "random_string" "this" {
  count   = 10
  length  = var.length
  upper   = false
  number  = true
  special = false
  keepers = var.keepers
}
