data "terraform_remote_state" "infra_networking" {
  backend = "s3"
  config = {
    bucket = "dev-state-storage-s3"
    key    = "networking/terraform.tfstate"
    region = var.aws_region
  }
}