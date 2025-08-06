provider "aws" {
  region = "us-east-1"
}

# Reference existing IAM instance profile
data "aws_iam_instance_profile" "existing_profile" {
  name = "role2"
}

resource "aws_instance" "dev" {
  ami           = "ami-084a7d336e816906b"
  instance_type = "t2.micro"

  iam_instance_profile = data.aws_iam_instance_profile.existing_profile.name

  tags = {
    Name = "dev"
  }
}