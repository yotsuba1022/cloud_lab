stack {
  name        = "default-vpc"
  description = "default-vpc"
  id          = "84f24704-8d51-4c02-9f75-4902836ae6c3"
  tags = [
    "dev",
    "default-vpc"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "default-vpc/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "default-vpc" {
      source = "../../../modules/default-vpc"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "default-vpc"
      managed_by = global.managed_by
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "vpc_id" {
      value = module.default-vpc.vpc_id
    }
    output "vpc_cidr" {
      value = module.default-vpc.vpc_cidr
    }
    output "subnet_ids" {
      value = module.default-vpc.subnet_ids
    }
    output "subnet_details" {
      value = module.default-vpc.subnet_details
    }
  }
}
