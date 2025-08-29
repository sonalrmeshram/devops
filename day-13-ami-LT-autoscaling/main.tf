provider "aws" {
  
}

resource "aws_vpc" "custom" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true 
  tags = {
    Name = "custom"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.custom.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "pvt1" {
  vpc_id = aws_vpc.custom.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "pvt2" {
  vpc_id = aws_vpc.custom.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-2"
  }
}

resource "aws_security_group" "SG" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "custom-sg"
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "public"
  }
  route {
    gateway_id = aws_internet_gateway.name.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "public_1" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.sub1.id
}

resource "aws_route_table_association" "public_2" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.sub2.id
}

resource "aws_eip" "name" {
  tags = {
    Name = "NAT"
  }
}

resource "aws_nat_gateway" "name" {
   tags = {
     Name = "NAT"
   }
   subnet_id = aws_subnet.sub1.id
   connectivity_type = "public"
   allocation_id = aws_eip.name.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custom.id
  tags = {
    Name = "private"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.name.id
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.pvt1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.pvt2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_instance" "public_1" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.SG.id ]
  key_name = "b"
  subnet_id = aws_subnet.sub1.id
  associate_public_ip_address = true
  tags = {
    Name = "public-1"
  }
}

resource "aws_instance" "public_2" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.SG.id ]
  key_name = "b"
  subnet_id = aws_subnet.sub2.id
  associate_public_ip_address = true
  tags = {
    Name = "public-2"
  }
}

resource "aws_instance" "private" {
  ami = "ami-08a6efd148b1f7504"
  instance_type = "t2.micro"
  security_groups = [ aws_security_group.SG.id ]
  key_name = "b"
  subnet_id = aws_subnet.pvt1.id
  tags = {
    Name = "private"
  }

 user_data = base64encode(file("test.sh"))

}

resource "null_resource" "wait_for_httpd" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  depends_on = [aws_instance.private]
}

resource "aws_lb_target_group" "name" {
  tags = {
    Name = "Target"
  }
  name = "target"
  protocol = "HTTP"
  port = "80"
  ip_address_type = "ipv4"
  vpc_id = aws_vpc.custom.id

    health_check {
  path                = "/"
  matcher             = "200"
  interval            = 30
  timeout             = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}
  
}

resource "aws_lb_target_group_attachment" "name" {
  target_group_arn = aws_lb_target_group.name.arn
  target_id = aws_instance.private.id
  port = "80"
}

resource "aws_lb" "name" {
  load_balancer_type = "application"
  name = "load"
  internal = false
  ip_address_type = "ipv4"
  subnets = [ aws_subnet.sub1.id, aws_subnet.sub2.id ]
  security_groups = [ aws_security_group.SG.id ]
}

resource "aws_lb_listener" "name" {
  protocol = "HTTP"
  port = "80"
  load_balancer_arn = aws_lb.name.arn

  default_action {
    target_group_arn = aws_lb_target_group.name.arn
    type = "forward"
  }
}

resource "aws_ami_from_instance" "image" {
  source_instance_id = aws_instance.private.id
  name = "image"
  depends_on = [ null_resource.wait_for_httpd ]
}

resource "aws_launch_template" "launch" {
  name = "template"
  image_id = aws_ami_from_instance.image.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SG.id ]
  key_name = "b"
  user_data = base64encode(file("test.sh"))
  tag_specifications {
    resource_type = "instance"
    tags = {
    Name = "template"
  }
}
}

resource "aws_autoscaling_group" "terra" {
  name = "terra"
  min_size = 1
  max_size = 2
  desired_capacity = 1
  vpc_zone_identifier = [ aws_subnet.pvt1.id, aws_subnet.pvt2.id ]
  target_group_arns = [ aws_lb_target_group.name.arn ]
  launch_template {
    id = aws_launch_template.launch.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "terra"
    propagate_at_launch = true
  }
}