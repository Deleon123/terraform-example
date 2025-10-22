resource "aws_s3_bucket" "aws_bucket" {
  bucket = "deleon-bucket-aws-remote-state-lifecycle-new-2"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }

  tags = {
    terraform = "yes"
  }
}

resource "aws_s3_bucket_versioning" "aws_bucket_versioning" {
  bucket = aws_s3_bucket.aws_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}