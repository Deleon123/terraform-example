resource "aws_s3_bucket" "aws_bucket" {
  bucket = "deleon-bucket-aws-remote-state"
}

resource "aws_s3_bucket_versioning" "aws_bucket_versioning" {
  bucket = aws_s3_bucket.aws_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}