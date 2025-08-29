resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "dev"
  }
}

resource "aws_subnet" "p1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "p2" {
   vpc_id = aws_vpc.name.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "SG" {
  tags = {
    name ="SG"
  }
    vpc_id = aws_vpc.name.id
     
     ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
     }

     egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

     }
  }


resource "aws_db_subnet_group" "name" {
  subnet_ids = [ aws_subnet.p1.id, aws_subnet.p2.id ]
  tags = { name = "db-subnet"}
}

data "aws_secretsmanager_secret_version" "RDS" {
  secret_id = "secret"
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.RDS.secret_string)
}

resource "aws_db_instance" "RDS" {
    identifier              = "rds-instance"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "rds"
  skip_final_snapshot     = true
  publicly_accessible     = false
  deletion_protection = false    
  storage_type = "gp2"
  engine_version = "8.0"
  username = local.rds_credentials.username
  password = local.rds_credentials.password
  backup_retention_period = 7
  backup_window = "02:00-03:00" #daily backup

  db_subnet_group_name    = aws_db_subnet_group.name.id

  tags = {
    Name = "rds-instance"
  }
}
