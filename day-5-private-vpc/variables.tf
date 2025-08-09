#CIDR variables
variable "vpc_cidr_block" {
    description = "cidr block for the vpc"
    type = string
    default = "172.0.0.0/16"
}
#public subnet variables
variable "cidr_block_public" {
    description = "cidr block for the public subnet"
    type = string
    default = "172.0.0.0/24"
}
#public route table
variable "route_cidr_block" {
    description = "cidr block for the public route table"
    type = string
    default = "0.0.0.0/0"
  
}

#public security group
variable "ingress_port" {
    type = number
    default = 80
}
variable "ingress_protocol" {
  type = string
  default = "TCP"
}
variable "security_cidr_block" {
    type = string
    default = "0.0.0.0/0"
}

#public security group
variable "egress_port" {
    type = number
    default = 0
}
variable "egress_protocol" {
  type = string
  default = "-1"
}

#ami
variable "ami" {
    description = "ami on my aws console"
  type = string
  default = "ami-084a7d336e816906b"
}

#instance type
variable "instance_type" {
    description = "instance type for my server"
  type = string
  default = "t2.micro"
}

#vpc private cidr
variable "cidr_block_private" {
   type = string
   default = "172.0.1.0/24"
}