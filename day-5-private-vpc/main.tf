#vpc creation
resource "aws_vpc" "name" {
    cidr_block = "172.0.0.0/16"
    tags = {
      Name ="private-vpc"
       
    }
  
}
#subnet creation
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.name.id
    cidr_block = "172.0.0.0/24"
    tags = {
      Name ="public" 
    }
}
#internet gateway creation and attach to vpc
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name= "IGW"
  }
}
#create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name= "public"
  }
  route {
    cidr_block="0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }
}
#subnet Association
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}
#security group creation
resource "aws_security_group" "public" {
    tags = {
      Name = "public"
    }
    vpc_id = aws_vpc.name.id
    description = "allow"
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" #all protocol
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
#create public server
resource "aws_instance" "public" {
    tags = {
      Name = "public"
    }
  ami = "ami-084a7d336e816906b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public.id]
}

#create private subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.name.id
  cidr_block = "172.0.1.0/24"
  tags = {
    Name = "private"
  }
}

# creation of elastic IP
resource "aws_eip" "NAT" {
  tags = {
    Name = "NAT-EIP"
  }
}

#creation of NaT
resource "aws_nat_gateway" "NAT" {
  tags = {
    Name="NAT"
  }
  subnet_id = aws_subnet.public.id
  connectivity_type = "public"
  allocation_id = aws_eip.NAT.id
}

#create route table and route
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "private"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}
resource "aws_route_table_association" "NAT" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
  
}

#private security group
resource "aws_security_group" "private" {
    tags = {
      Name = "private"
      
    }
    description ="allow"
    vpc_id = aws_vpc.name.id
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" #all protocol
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

#creation of private server
resource "aws_instance" "private" {
    tags = {
      Name = "private"
    }
    ami = "ami-084a7d336e816906b"
        instance_type = "t2.micro"
        subnet_id = aws_subnet.private.id
        vpc_security_group_ids = [aws_security_group.private.id]
}