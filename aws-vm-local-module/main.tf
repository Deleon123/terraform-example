terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "deleon-bucket-aws-remote-state"
    key    = "aws-vm-local-module/terraform.tfstate"
    region = "sa-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"

  default_tags {
    tags = {
      Owner      = "Deleon"
      Project    = "Estudos Terraform"
      managed-by = "terraform"
    }
  }
}

module "network" {
  source = "./network"
  cidr_vpc = "10.0.0.0/16"
  cidr_subnet = "10.0.1.0/24"
  environment = "vm-${var.environment}"
}