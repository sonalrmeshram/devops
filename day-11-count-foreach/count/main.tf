resource "aws_instance" "name" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  count = 2
  tags = {
    Name = "test-${count.index}"
  }
}