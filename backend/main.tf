terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }

    azurerm = {
      version = "~> 3.0"
      source  = "hashicorp/azurerm"
    }
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

provider "azurerm" {
  features {}
}