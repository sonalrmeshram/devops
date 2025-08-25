resource "aws_instance" "name" {
  ami = "ami-00ca32bbc84273381"
  instance_type = "t2.micro"
  tags = {
    Name = "public"
  }
}
#terraform import aws_instance.name instance_id

resource "aws_s3_bucket" "name" {
  bucket = "sonalrmeshram"
}

#terraform import aws_s3_bucket.name sonalrmeshram