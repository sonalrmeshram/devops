terraform {
  source = "./module/vpc"
}

inputs = {
  cidr_block  = "10.0.0.0/16"
  environment = "dev"
}
