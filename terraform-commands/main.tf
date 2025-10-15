terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-estudos-terraform"
    storage_account_name = "deleonterraform"
    container_name       = "container-tfvars-file"
    key                  = "commands/terraform.tfstate"
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
