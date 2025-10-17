resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-terraform-provider-default"
  }
}


resource "aws_vpc" "vpc_provider_1" {
  provider   = aws.provider_1
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "vpc-terraform-provider-1"
  }
}


resource "aws_vpc" "vpc_provider_2" {
  provider   = aws.provider_2
  cidr_block = "10.2.0.0/16"

  tags = {
    Name = "vpc-terraform-provider-2"
  }
}
