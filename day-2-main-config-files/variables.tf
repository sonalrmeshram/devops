variable "ami-id" {
  description = "inserting the ami values to main.tf"
  type = string
  default = ""  
}

variable "instance-type" {
    type = string
  default = "t2.small"  
}