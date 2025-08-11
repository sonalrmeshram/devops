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
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.name.id
    cidr_block = var.cidr_block_public
    availability_zone = var.availability_zone_1
    tags = {
      Name = var.aws_subnet_public
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
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.public.id
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
resource "aws_instance" "public" {
    tags = {
      Name = var.aws_instance_public
    }
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public.id]
}

#create private subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block_private
  availability_zone = var.availability_zone_1
  tags = {
    Name = var.aws_subnet_private
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
  subnet_id = aws_subnet.public.id
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
resource "aws_route_table_association" "NAT" {
    subnet_id = aws_subnet.private.id
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
resource "aws_instance" "private" {
    tags = {
      Name = var.aws_instance_private
    }
    ami = var.ami
        instance_type = var.instance_type
        subnet_id = aws_subnet.private.id
        vpc_security_group_ids = [aws_security_group.private.id]
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

  ingress {
    from_port = var.ingress_port_rds
    to_port = var.ingress_port_rds
    protocol = var.ingress_protocol
         
  }
  egress {
    from_port = var.egress_port
    to_port =  var.egress_port
    protocol = var.egress_protocol
    cidr_blocks = [ var.security_cidr_block ]
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

resource "aws_db_instance" "RDS-read-replica" {
    identifier = var.identifier_rds
    instance_class = var.instance_class
    engine = aws_db_instance.main.engine
    publicly_accessible = var.publicly_accessible_rds
    storage_type = var.storage_type
    replicate_source_db = aws_db_instance.main.arn
    skip_final_snapshot = var.skip_final_snapshot

    db_subnet_group_name = aws_db_subnet_group.group.name
    vpc_security_group_ids = [ aws_security_group.RDS.id ]

    tags = {
        Name = var.aws_rds_replica
    }
}