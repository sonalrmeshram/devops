
terraform {
  backend "s3" {
    bucket         = "sonalrmeshram"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    
  }
}