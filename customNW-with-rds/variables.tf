#CIDR variables
variable "vpc_cidr_block" {
    description = "cidr block for the vpc"
    type = string
    default = ""
}
#public subnet variables
variable "cidr_block_public" {
    description = "cidr block for the public subnet"
    type = string
    default = ""
}
#public route table
variable "route_cidr_block" {
    description = "cidr block for the public route table"
    type = string
    default = ""
  
}

#public security group
variable "ingress_port" {
    type = number
    default = null
}

#public security group
variable "ingress_port_rds" {
    type = number
    default = null
}

variable "ingress_protocol" {
  type = string
    default = ""
}
variable "security_cidr_block" {
    type = string
    default = ""
}

#public security group
variable "egress_port" {
    type = number
    default = null
}
variable "egress_protocol" {
  type = string
    default = ""
}

#ami
variable "ami" {
    description = "ami on my aws console"
  type = string
    default = ""
}

#instance type
variable "instance_type" {
    description = "instance type for my server"
  type = string
    default = ""
}

#vpc private cidr
variable "cidr_block_private" {
   type = string
    default = ""
}

#vpc private cidr
variable "cidr_block_rds_1" {
   type = string
    default = ""
}

#vpc private cidr
variable "cidr_block_rds_2" {
   type = string
    default = ""
}

variable "identifier" {
    type = string
    default = ""
}

variable "engine" {
  type = string
    default = ""
}

variable "instance_class" {
  type = string
    default = ""
}

variable "allocated_storage" {
  type = number
    default = null
}

variable "db_name" {
  type = string
    default = ""
}

variable "username" {
  type = string
    default = ""
}

variable "password" {
  type = string
    default = ""
  sensitive = true
}
variable "storage_type" {
  type = string
    default = ""
}
variable "backup_retention_period" {
  type = number
    default = null
}
variable "skip_final_snapshot" {
  type = bool
    default = null
}
variable "publicly_accessible" {
  type = bool
    default = null
}
variable "engine_version" {
  type = string
    default = ""
}

variable "identifier_rds" {
  type = string
    default = ""
}

variable "publicly_accessible_rds" {
  type = bool
    default = null
}

variable "availability_zone_1" {
    type = string
    default = ""
  
}

variable "availability_zone_2" {
    type = string
    default = ""
  
}

variable "sensitive" {
    type = bool
    default = null
}

variable "description" {
    type = string
  default = ""
}

variable "db_subnet_group_name" {
    type = string
    default = ""
}

variable "aws_vpc_name" {
    type = string
    default = ""
}

variable "aws_subnet_public" {
  type = string
  default = ""
}

variable "aws_internet_gateway" {
  type = string
  default = ""
}

variable "aws_route_table_public" {
  type = string
  default = ""
}

variable "aws_security_group_public" {
  type = string
  default = ""
}

variable "aws_security_group_public_description" {
  type = string
  default = ""
}

variable "aws_instance_public" {
  type = string
  default = ""
}

variable "aws_subnet_private" {
  type = string
  default = ""
}

variable "aws_subnet_rds_1" {
  type = string
  default = ""
}

variable "aws_subnet_rds_2" {
  type = string
  default = ""
}

variable "aws_nat_name" {
  type = string
  default = ""
}

variable "aws_connectivity" {
  type = string
  default = ""
}

variable "aws_route_table_private" {
  type = string
  default = ""
}

variable "aws_security_group_private" {
  type = string
  default = ""
}

variable "aws_instance_private" {
  type = string
  default = ""
}

variable "aws_db_subnet_group_tag" {
  type = string
  default = ""
}

variable "aws_db_subnet_group_name" {
  type = string
  default = ""
}

variable "aws_db_subnet_group_description" {
  type = string
  default = ""
}

variable "aws_security_group_RDS" {
  type = string
  default = ""
}

variable "aws_security_group_rds_description" {
  type = string
  default = ""
}

variable "aws_rds_main" {
  type = string
  default = ""
}

variable "aws_rds_replica" {
  type = string
  default = ""
}