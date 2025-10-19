resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-terraform-${terraform.workspace}"
  }
}

resource "aws_subnet" "subnet" {
  count = terraform.workspace == "production" ? 5 : 2
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "sn-terraform-${terraform.workspace}-${count.index}"
  }
}
