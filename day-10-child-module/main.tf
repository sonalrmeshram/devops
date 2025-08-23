module "aws_vpc" {
  source = "./module/vpc"
  cidr_block = var.cidr_block
  subnet_cidr = var.subnet_cidr
  availability_zone = var.availability_zone
}

module "aws_s3_bucket" {
  source = "./module/s3"
  bucket_name = var.bucket_name
}

module "aws_instance" {
  source = "./module/ec2"
  subnet_id = module.aws_vpc.subnet_id
  ami = var.ami
  instance_type = var.instance_type
}