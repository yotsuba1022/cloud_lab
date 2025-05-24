bucket         = "dev-infra-terraform-state-s3"
key            = "infra-networking/terraform.tfstate"
region         = "ap-northeast-1"
encrypt        = true
dynamodb_table = "dev-infra-terraform-state-locks"
