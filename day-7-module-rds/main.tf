module "rds" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "rds"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  db_name  = "demodb"
  username = "admin"
  password = "Sonal45815"
  port     = "3306"
  family = "mysql8.0"
  major_engine_version = "8.0"
}