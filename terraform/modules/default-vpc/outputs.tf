output "vpc_id" {
  description = "ID of the default VPC"
  value       = data.aws_vpc.default_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the default VPC"
  value       = data.aws_vpc.default_vpc.cidr_block
}

output "subnet_ids" {
  description = "List of subnet IDs in the default VPC"
  value       = data.aws_subnets.default_subnets.ids
}

output "subnet_details" {
  description = "Map of subnet details in the default VPC"
  value = {
    for subnet in data.aws_subnet.default_subnet : subnet.id => {
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
      is_public         = subnet.map_public_ip_on_launch
    }
  }
}
