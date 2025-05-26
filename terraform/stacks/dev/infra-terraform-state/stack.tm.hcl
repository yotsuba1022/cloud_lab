stack {
  name        = "infra-terraform-state"
  description = "Terraform state for the infrastructure"
  id          = "b6d8b5be-0e30-44cb-aead-4498bccb0d75"
  
  tags = [
    "dev-infra-terraform-state"
  ]
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "infra_terraform_state" {
      source = "../../../modules/infra-terraform-state"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "infra-terraform-state"
      managed_by = global.managed_by
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "state_bucket_name" {
      value = module.infra_terraform_state.s3_bucket_name
    }

    output "state_bucket_arn" {
      value = module.infra_terraform_state.s3_bucket_arn
    }

    output "state_dynamodb_table" {
      value = module.infra_terraform_state.dynamodb_table_name
    }

    output "state_dynamodb_table_arn" {
      value = module.infra_terraform_state.dynamodb_table_arn
    }
  }
}
