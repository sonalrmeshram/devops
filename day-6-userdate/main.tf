resource "aws_instance" "public" {
ami = "ami-084a7d336e816906b"
instance_type ="t2.micro" 
availability_zone = "us-east-1a"
user_data = file("test.sh")
tags = {
  Name = "dev"
}
}