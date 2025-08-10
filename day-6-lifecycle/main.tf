resource "aws_instance" "name" {
ami = "ami-084a7d336e816906b"
instance_type ="t2.micro" 
availability_zone = "us-east-1a"
tags = {
  Name = "test"
}

    lifecycle {
      prevent_destroy  = true
      create_before_destroy = true
      ignore_changes = [ tags, ]
    }
}