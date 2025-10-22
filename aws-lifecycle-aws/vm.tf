resource "aws_key_pair" "key" {
  key_name   = "aws-key"
  public_key = file("./aws-key.pub")
}

resource "aws_instance" "vm" {
  ami                         = "ami-035efd31ab8835d8a"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.security_group_id]
  associate_public_ip_address = true

  lifecycle {
    replace_triggered_by = [aws_s3_bucket.aws_bucket]
    prevent_destroy = false # alter to true if you want to prevent the destruction of the resource
  }

  tags = {
    Name = "vm-terraform"
  }
}
