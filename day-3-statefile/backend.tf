terraform {
  backend "s3" {
    bucket = "sonalrmeshram"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
} 