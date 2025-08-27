resource "aws_s3_bucket" "name" {
  bucket = "sonalrmeshram"
}


resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.name.id
  key = "app.zip"
  source = "C:/Users/Hp/Downloads/app.zip"
  etag = filemd5("C:/Users/Hp/Downloads/app.zip")
}

resource "aws_iam_role" "s3_access" {
  name = "s3_access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "s3_lambda" {
  role = aws_iam_role.s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_lambda_function" "s3_on_lambda" {
  runtime = "python3.13"
  function_name = "s3_on_lambda"
  role = aws_iam_role.s3_access.arn
  handler = "app.lambda_handler"
  timeout = 900
  memory_size = 128
  s3_bucket = aws_s3_bucket.name.bucket
  s3_key = aws_s3_object.name.key
  

  
   source_code_hash = filebase64sha256("C:/Users/Hp/Downloads/app.zip")    

     #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
}