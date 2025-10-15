removed {
  from = aws_s3_bucket.bucket_three

  lifecycle {
    destroy = false
  }
}