data "aws_subnet" "name" {
  filter {
    name = "tag:Name"
    values = [ "dev" ]
  }
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  owners = [ "amazon"]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }

  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

resource "aws_instance" "name" {
  ami = data.aws_ami.amazonlinux.id
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.name.id 
  tags = {
    Name = "dev"
  }
}

# data "aws_ami" "amzlinux" {
#   most_recent = true
#   owners = [ "self" ]
#   filter {
#     name = "name"
#     values = [ "frontend-ami" ]
#   }
# }