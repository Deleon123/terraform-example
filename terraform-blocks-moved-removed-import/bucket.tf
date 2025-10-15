resource "aws_s3_bucket" "bucket_one" {
  bucket = "deleon-terraform-commands-moved-removed-import-1"
}

resource "aws_s3_bucket" "bucket_two" {
  bucket = "deleon-terraform-commands-moved-removed-import-2"
}

resource "aws_s3_bucket" "bucket_3" {
  bucket = "deleon-terraform-commands-moved-removed-import-1"
}
