variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "env" {
  description = "Prefix for environment names"
  type        = string
}

variable "module_name" {
  description = "Prefix for resource names"
  type        = string
}
