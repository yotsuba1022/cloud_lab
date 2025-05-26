resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private[*].id

  # Allow ALL ICMP (e.g., ping) for network diagnostics and monitoring
  # For ALL ICMP types in Network ACLs, we use from_port=-1, to_port=-1
  ingress {
    protocol   = "1" # ICMP
    rule_no    = 80
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0  # 0 means all ICMP types
    to_port    = 0  # 0 means all ICMP codes
    icmp_type  = -1 # Explicitly specify all ICMP types
    icmp_code  = -1 # Explicitly specify all ICMP codes
  }

  # Allow ephemeral port response traffic (1024-65535)
  # These high ports are typically used for responses to client connection requests
  # Must allow inbound traffic on these ports, otherwise outbound connections won't receive responses
  ingress {
    protocol   = "6" # TCP
    rule_no    = 90
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow HTTPS inbound traffic (port 443)
  # Used for receiving secure HTTPS requests from external sources
  ingress {
    protocol   = "6" # TCP
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow inbound traffic from within the VPC
  # Ensures communication between services within the VPC
  ingress {
    protocol   = "-1" # All protocols
    rule_no    = 110
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Default deny for all other inbound traffic
  # This is a defensive measure to ensure that traffic not explicitly allowed is rejected
  ingress {
    protocol   = "-1"
    rule_no    = 32766
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Egress rules

  # Allow ALL ICMP outbound traffic for network diagnostics
  # Ensures that ping requests can be sent to external hosts
  egress {
    protocol   = "1" # ICMP
    rule_no    = 80
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0  # 0 means all ICMP types
    to_port    = 0  # 0 means all ICMP codes
    icmp_type  = -1 # Explicitly specify all ICMP types
    icmp_code  = -1 # Explicitly specify all ICMP codes
  }

  # Allow HTTPS requests (port 443)
  # Used for secure web browsing, API calls, package managers (apt, yum)
  egress {
    protocol   = "6" # TCP
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow HTTP requests (port 80)
  # Used for regular web browsing and some package managers
  egress {
    protocol   = "6" # TCP
    rule_no    = 105
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allow UDP DNS queries to VPC Resolver
  # 10.0.0.2 is typically the DNS resolver address in AWS VPC
  egress {
    protocol   = "17" # UDP
    rule_no    = 110
    action     = "allow"
    cidr_block = "10.0.0.2/32"
    from_port  = 53
    to_port    = 53
  }

  # Allow TCP DNS queries within the VPC
  # Some DNS queries use TCP instead of UDP, especially for responses larger than 512 bytes
  egress {
    protocol   = "6" # TCP
    rule_no    = 111
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 53
    to_port    = 53
  }

  # Allow SSH outbound connections (port 22)
  # Used for connecting from EC2 instances to other servers
  egress {
    protocol   = "6" # TCP
    rule_no    = 115
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  # Allow internal VPC communication
  # Ensures services within the VPC can communicate with each other without restrictions
  egress {
    protocol   = "-1"
    rule_no    = 120
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  # Allow TCP high port outbound connections (1024-65535)
  # Used for client-initiated connections such as API calls, database connections, etc.
  egress {
    protocol   = "6" # TCP
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow UDP high port outbound connections (1024-65535)
  # Used for applications that use UDP, such as DNS responses, certain streaming protocols, etc.
  egress {
    protocol   = "17" # UDP
    rule_no    = 135
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Default deny for all other outbound traffic
  # Security best practice: only allow traffic that is explicitly needed
  egress {
    protocol   = "-1"
    rule_no    = 32766
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
  local.common_tags, { Name = "${local.prefix}-private-nacl" })
}
