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
    key    = "aws-provider-vpc/terraform.tfstate"
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

provider "aws" {
  alias  = "unitedstates"
  region = "us-east-1"

  default_tags {
    tags = {
      Owner      = "Deleon"
      Project    = "Estudos Terraform"
      managed-by = "terraform"
    }
  }
}

provider "aws" {
  alias  = "europe"
  region = "eu-central-1"

  default_tags {
    tags = {
      Owner      = "Deleon"
      Project    = "Estudos Terraform"
      managed-by = "terraform"
    }
  }
}

module "vpc" {
  source = "./vpc"

  providers = {
    aws.provider_1 = aws.unitedstates
    aws.provider_2 = aws.europe
  }
}