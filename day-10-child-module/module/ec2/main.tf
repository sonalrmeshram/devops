resource "aws_instance" "public" {
    tags = {
      Name = "public"
    }
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
}