terraform {
  backend "s3" {
    bucket = "sonalrmeshram"
    key    = "day-4/terraform.tfstate"
    region = "us-east-1"
  }
} 