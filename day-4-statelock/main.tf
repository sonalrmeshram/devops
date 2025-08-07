resource "aws_instance" "dev" {
  ami           = "ami-084a7d336e816906b"
  instance_type = "t2.micro"
  tags = {
    Name ="dev" 
  }
}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "devops"
  }
  
}