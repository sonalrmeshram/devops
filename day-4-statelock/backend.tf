terraform {
  backend "s3" {
    bucket = "sonalrmeshram"
    key    = "day-4/terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true  #s3 support lastest version >1.10.0
   dynamodb_table = "dev" #apply for any version
   encrypt = true
  }
} 