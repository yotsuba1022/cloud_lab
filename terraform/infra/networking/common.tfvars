env = "dev"
module_name = "infra-networking"
aws_region = "ap-northeast-1"

# VPC CIDR block
# 10.0.0.0 ~ 10.0.255.255
vpc_cidr = "10.0.0.0/16"

# Availability Zones
azs = [
  "ap-northeast-1a",
  "ap-northeast-1c"
]

# Public Subnet CIDR blocks
public_subnet_cidrs = [
  "10.0.1.0/24",  # ap-northeast-1a [10.0.1.0 ~ 10.0.1.255]
  "10.0.2.0/24"   # ap-northeast-1c [10.0.2.0 ~ 10.0.2.255]
]

# Private Subnet CIDR blocks
private_subnet_cidrs = [
  "10.0.11.0/24",  # ap-northeast-1a [10.0.11.0 ~ 10.0.11.255]
  "10.0.12.0/24"   # ap-northeast-1c [10.0.12.0 ~ 10.0.12.255]
]
