data "terraform_remote_state" "infra_networking" {
  backend = "s3"
  config = {
    bucket = "dev-infra-terraform-state-s3"
    key    = "infra-networking/terraform.tfstate"
    region = var.aws_region
  }
}