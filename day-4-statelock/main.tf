resource "aws_instance" "dev" {
  ami           = "ami-084a7d336e816906b"
  instance_type = "t2.micro"
  tags = {
    Name ="test" 
  }
  }
