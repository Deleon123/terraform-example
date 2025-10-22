resource "aws_subnet" "subnet_default" {
  vpc_id     = module.vpc.vpc_id_provider_default
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sn-terraform-provider-default"
  }
}

resource "aws_subnet" "subnet_unitedstates" {
  provider   = aws.unitedstates
  vpc_id     = module.vpc.vpc_id_provider_1
  cidr_block = "10.1.0.0/24"

  tags = {
    Name = "sn-terraform-provider-1"
  }
}

resource "aws_subnet" "subnet_europe" {
  provider   = aws.europe
  vpc_id     = module.vpc.vpc_id_provider_2
  cidr_block = "10.2.1.0/24"

  tags = {
    Name = "sn-terraform-provider-2"
  }
}