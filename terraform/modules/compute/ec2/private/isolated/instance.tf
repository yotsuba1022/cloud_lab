data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "ec2" {
  name        = "${local.prefix}-sg"
  description = "Security group for EC2 instance"
  vpc_id      = data.terraform_remote_state.infra_networking.outputs.vpc_id

  egress {
    from_port   = 0             // 0 means all ports
    to_port     = 0             // 0 means all ports
    protocol    = "-1"          // -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] // 0.0.0.0/0 means all IP addresses
    description = "Allow all outbound traffic"
  }

  tags = merge(
    local.common_tags, { Name = "${local.prefix}-sg" }
  )
}

# Add IAM policy for Session Manager
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ec2_role" {
  name = "${local.prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.prefix}-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "this" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.terraform_remote_state.infra_networking.outputs.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name != "" ? var.key_name : null
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  # Ensure the instance has appropriate tags to identify it in Session Manager
  tags = merge(
    local.common_tags, {
      Name = "${local.prefix}",
      # Add more tags to help organize and filter instances in Systems Manager
      SessionManager = "enabled"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
