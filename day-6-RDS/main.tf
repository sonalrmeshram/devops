#creation of DB group
resource "aws_db_subnet_group" "group" {
    tags = {
      Name = "Subnet"
    }
    name = "db-subnet"
  description = "group"
    subnet_ids = [ 
        "subnet-08faae906048145fd",
        "subnet-0df0a3b8d28aeac92"
     ]
}

#creation of security group
resource "aws_security_group" "Name" {
  name = "rds"
  description = "allow"
  vpc_id = "vpc-0f44bce9519174caf"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "TCP"
         
  }
  egress {
    from_port = 0
    to_port =  0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

#creation of RDS
    resource "aws_db_instance" "main" {
  identifier              = "rds-instance"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "rds"
  username                = "admin"
  password                = "Sonal45815"
  skip_final_snapshot     = true
  publicly_accessible     = true
  storage_type = "gp2"
  engine_version = "8.0"

  backup_retention_period = 7

  vpc_security_group_ids  = [aws_security_group.Name.id]
  db_subnet_group_name    = aws_db_subnet_group.group.name

  tags = {
    Name = "rds-instance"
  }
}

resource "aws_db_instance" "RDS-read-replica" {
    identifier = "rds-read-replica"
    instance_class = "db.t3.micro"
    engine = aws_db_instance.main.engine
    publicly_accessible = false
    storage_type = "gp2"
    replicate_source_db = aws_db_instance.main.arn

    db_subnet_group_name = aws_db_subnet_group.group.name
    vpc_security_group_ids = [ aws_security_group.Name.id ]

    tags = {
        Name = "read-replica"
    }
}