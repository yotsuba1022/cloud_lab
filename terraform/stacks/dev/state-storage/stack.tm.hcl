stack {
  name        = "state-storage"
  description = "Terraform state storage"
  id          = "b6d8b5be-0e30-44cb-aead-4498bccb0d75"
  tags = [
    "dev-state-storage"
  ]
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "state_storage" {
      source = "../../../modules/state-storage"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "state-storage"
      managed_by = global.managed_by
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "state_bucket_name" {
      value = module.state_storage.storage_name
    }

    output "state_bucket_arn" {
      value = module.state_storage.storage_arn
    }

    output "state_dynamodb_table" {
      value = module.state_storage.lock_table_name
    }

    output "state_lock_table_arn" {
      value = module.state_storage.lock_table_arn
    }
  }
}
