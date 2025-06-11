stack {
  name        = "random-id-generator"
  description = "Random ID generator"
  id          = "480ba3d6-2518-4813-a693-933a7b00f4d3"

  tags = [
    "random-id-generator"
  ]
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "random-id-generator" {
      source = "../../modules/random-id-generator"
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "generated_ids" {
      value = module.random-id-generator.results
    }
  }
}
