#vpc creation
resource "aws_vpc" "name" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support =  true
    tags = {
      Name = var.aws_vpc_name
       
    }
  
}
#subnet creation
resource "aws_subnet" "public_1" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.cidr_block_public_1
    availability_zone = var.availability_zone_1
    tags = {
      Name = var.aws_subnet_public_1
    }
}
resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.cidr_block_public_2
    availability_zone = var.availability_zone_2
    tags = {
      Name = var.aws_subnet_public_2
    }
}

#internet gateway creation and attach to vpc
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name= var.aws_internet_gateway
  }
}
#create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name= var.aws_route_table_public
  }
  route {
    cidr_block=var.route_cidr_block
    gateway_id = aws_internet_gateway.name.id
  }
}
#subnet Association
resource "aws_route_table_association" "public_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

#security group creation
resource "aws_security_group" "public" {
    tags = {
      Name = var.aws_security_group_public
    }
    vpc_id = aws_vpc.name.id
    description = var.aws_security_group_public_description
    ingress  {
        from_port = var.ingress_port
        to_port = var.ingress_port
        protocol = var.ingress_protocol
        cidr_blocks = [var.security_cidr_block]
    }
    egress {
        from_port = var.egress_port
        to_port = var.egress_port
        protocol = var.egress_protocol #all protocol
        cidr_blocks = [var.security_cidr_block]
    }
  
}
#create public server
resource "aws_instance" "public_1" {
    tags = {
      Name = var.aws_instance_public_1
    }
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true
  key_name               = var.key_name
}
resource "aws_instance" "public_2" {
    tags = {
      Name = var.aws_instance_public_2
    }
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_2.id
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true
  key_name               = var.key_name
}

#create private subnet
resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_private_1
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.aws_subnet_private_1
  }
}
resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_private_2
  availability_zone = var.availability_zone_2
  tags = {
    Name = var.aws_subnet_private_2
  }
}
resource "aws_subnet" "private_3" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_private_3
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.aws_subnet_private_3
  }
}
resource "aws_subnet" "private_4" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_private_4
  availability_zone = var.availability_zone_2
  tags = {
    Name = var.aws_subnet_private_4
  }
}


#create private subnet
resource "aws_subnet" "RDS-1" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_rds_1
  availability_zone = var.availability_zone_1
    tags = {
    Name = var.aws_subnet_rds_1
  }
}

#create private subnet
resource "aws_subnet" "RDS-2" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_rds_2
  availability_zone = var.availability_zone_2
    tags = {
    Name = var.aws_subnet_rds_2
  }
}

# creation of elastic IP
resource "aws_eip" "NAT" {
  tags = {
    Name = var.aws_nat_name
  }
}

#creation of NaT
resource "aws_nat_gateway" "NAT" {
  tags = {
    Name= var.aws_nat_name
  }
  subnet_id = aws_subnet.public_1.id
  connectivity_type = var.aws_connectivity
  allocation_id = aws_eip.NAT.id
}

#create route table and route
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name = var.aws_route_table_private
  }
  route {
    cidr_block = var.route_cidr_block
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}
resource "aws_route_table_association" "private_1" {
    subnet_id = aws_subnet.private_1.id
    route_table_id = aws_route_table.private.id
  
}
resource "aws_route_table_association" "private_2" {
    subnet_id = aws_subnet.private_2.id
    route_table_id = aws_route_table.private.id
  
}
resource "aws_route_table_association" "private_3" {
    subnet_id = aws_subnet.private_3.id
    route_table_id = aws_route_table.private.id
  
}
resource "aws_route_table_association" "private_4" {
    subnet_id = aws_subnet.private_4.id
    route_table_id = aws_route_table.private.id
  
}

#private security group
resource "aws_security_group" "private" {
    tags = {
      Name = var.aws_security_group_private
      
    }
    description = var.description
    vpc_id = aws_vpc.name.id
    ingress{
        from_port = var.ingress_port
        to_port = var.ingress_port
        protocol = var.ingress_protocol
        cidr_blocks = [ var.security_cidr_block ]
    }
    egress {
        from_port = var.egress_port
        to_port = var.egress_port
        protocol = var.egress_protocol #all protocol
        cidr_blocks = [ var.security_cidr_block]
    }
}

#creation of private server
resource "aws_instance" "private_1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.aws_instance_private_1
  }
}
resource "aws_instance" "private_3" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_3.id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.admin_profile.name

  
  tags = {
    Name = var.aws_instance_private_3
  }
}
   
#creation of DB group
resource "aws_db_subnet_group" "group" {
    tags = {
      Name = var.aws_db_subnet_group_tag
    }
    name = var.aws_db_subnet_group_name
  description = var.aws_db_subnet_group_description
    subnet_ids = [ 
        aws_subnet.RDS-1.id,
        aws_subnet.RDS-2.id
     ]
}

#creation of security group
resource "aws_security_group" "RDS" {
  name = var.aws_security_group_RDS
  description = var.aws_security_group_rds_description
  vpc_id = aws_vpc.name.id  

    ingress  {
        from_port = var.ingress_port
        to_port = var.ingress_port
        protocol = var.ingress_protocol
        cidr_blocks = [var.security_cidr_block]
    }
    egress {
        from_port = var.egress_port
        to_port = var.egress_port
        protocol = var.egress_protocol #all protocol
        cidr_blocks = [var.security_cidr_block]
    }
}

#creation of RDS
    resource "aws_db_instance" "main" {
  identifier              = var.identifier
  engine                  = var.engine
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  skip_final_snapshot     = var.skip_final_snapshot
  publicly_accessible     = var.publicly_accessible
  storage_type = var.storage_type
  engine_version = var.engine_version

  backup_retention_period = var.backup_retention_period

  vpc_security_group_ids  = [aws_security_group.RDS.id]
  db_subnet_group_name    = aws_db_subnet_group.group.name

  tags = {
    Name = var.aws_rds_main
  }
}
resource "aws_iam_role" "ec2_full_access_role" {
  name = "ec2-full-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.ec2_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-full-access-profile"
  role = aws_iam_role.ec2_full_access_role.name
}

resource "aws_iam_role" "admin_role" {
  name = "ec2-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "admin_profile" {
  name = "ec2-admin-profile"
  role = aws_iam_role.admin_role.name
}