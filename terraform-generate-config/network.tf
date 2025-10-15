# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_subnet" "subnet_one" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = "vpc-0d2c8a9fc9d674aaa"

  tags = {
    Name       = "subnet-1"
    managed-by = "portal"
  }
}

# __generated__ by Terraform
resource "aws_subnet" "subnet_two" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = "vpc-0d2c8a9fc9d674aaa"

  tags = {
    Name = "subnet-2"
  }
}

# __generated__ by Terraform
resource "aws_vpc" "vpc_one" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-generate-config"
  }
}
