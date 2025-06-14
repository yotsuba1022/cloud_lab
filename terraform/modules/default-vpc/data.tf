data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_security_group" "default_security_group" {
  vpc_id = data.aws_vpc.default_vpc.id
  name   = "default"
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_subnet" "default_subnet" {
  for_each = toset(data.aws_subnets.default_subnets.ids)
  id       = each.key
}
