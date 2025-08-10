resource "aws_vpc" "sonal" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "sonal"
    }
  depends_on = [ aws_s3_bucket.name ]
}
resource "aws_s3_bucket" "name" {
  bucket = "sonalrmeshram"
}