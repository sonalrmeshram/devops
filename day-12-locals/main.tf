locals {
  region = "us-east-1"
  instance_type = "t2.micro"
  ami = "ami-08a6efd148b1f7504"
}

provider "aws" {
  region = local.region
}

resource "aws_instance" "name" {
  ami = local.ami
  instance_type = local.ami
}