globals {
    env        = "dev"
    aws_region = global.region
    
}

globals "backend" "s3" {
  bucket = "dev-infra-terraform-state-s3"
}

globals "backend" "dynamodb" {
  table = "dev-infra-terraform-state-locks"
}

generate_hcl "_terramate_generated_provider.tf" {
  content {
    provider "aws" {
      region = global.aws_region
    }
  }
} 
