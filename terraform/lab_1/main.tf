# Specify the AWS provider and set the region to us-east-1
provider "aws" {
  region = "us-east-1"
}
# Create an S3 bucket with a unique name
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-clu-terraform-test"
}
# Set the ownership controls for the S3 bucket to prefer the bucket owner
resource "aws_s3_bucket_ownership_controls" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
# Configure the S3 bucket's public access settings
resource "aws_s3_bucket_public_access_block" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# Set the ACL (Access Control List) for the S3 bucket to allow public read access
resource "aws_s3_bucket_acl" "my_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my_bucket,
    aws_s3_bucket_public_access_block.my_bucket,
  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}
# Upload an object (index.html) to the S3 bucket
resource "aws_s3_object" "my_object" {
  bucket = aws_s3_bucket.my_bucket.bucket # Reference the S3 bucket where the object will be stored
  key    = "index.html"   # Define the key (object name) in the bucket
  source = "index.html" # Specify the source file to upload
  content_type="text/html" # Set the content type of the object to text/html
}
# Define an IAM policy document to allow public read access to the S3 bucket
data "aws_iam_policy_document" "allow_access" {
  statement { # Define the principals that the policy applies to (in this case, all users)
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.my_bucket.arn,
      "${aws_s3_bucket.my_bucket.arn}/*",
    ]
  }
}
# Attach the IAM policy to the S3 bucket to allow public read access
resource "aws_s3_bucket_policy" "allow_access" {
 # Attach the IAM policy to the S3 bucket to allow public read access
  bucket = aws_s3_bucket.my_bucket.id
  # Use the IAM policy document defined above
  policy = data.aws_iam_policy_document.allow_access.json
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "LambdaRole" {
  name               = "LambdaRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "LambdaRoleAttachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.LambdaRole.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "LambdaFunction" {
  
  filename      = "lambda_function_payload.zip"
  function_name = "LambdaFunction"
  role          = aws_iam_role.LambdaRole.arn
  handler       = "lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"
  }
  
resource "aws_lambda_function_url" "LambdaFunction" {
    function_name      = aws_lambda_function.LambdaFunction.function_name
    authorization_type = "NONE"
 }
 output "function_url" {
    value = aws_lambda_function_url.LambdaFunction.function_url
 }
  
 resource "aws_security_group" "instance_sg" {
    name        = "allow-port-3000"
    description = "Allow incoming traffic on port 3000"
  
    ingress {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from any source IP
    }
      egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"  # Allow all outbound traffic
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
 resource "aws_instance" "my_app"{
    ami= "ami-0fa1ca9559f1892ec"
    instance_type= "t2.micro"
    key_name= null
    security_groups  = [aws_security_group.instance_sg.name]

    user_data=<<-EOF
    #!/bin/bash
    sudo yum -y update &&\
    sudo yum -y install git &&\
    sudo yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &&\
    sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1 &&\
    git clone https://github.com/theHaziqali/my-reactapp.git &&\
    cd my-reactapp &&\
    npm install &&\
    npm start
    EOF


    tags={
        Name="clab-app"
    }
}
output "public_ip" {
  value = aws_instance.my_app.public_ip
}  
