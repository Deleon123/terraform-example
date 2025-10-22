terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    azurerm = {
      version = "~> 3.0"
      source  = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-estudos-terraform"
    storage_account_name = "deleonterraform"
    container_name       = "container-tfvars-file"
    key                  = "azure-vm-remote-module/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source  = "Azure/network/azurerm"
  version = "5.3.0"

  resource_group_name = azurerm_resource_group.resource_group.name
  resource_group_location = var.location
  use_for_each        = true
  tags                = local.common_tags
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet-${var.environment}"]
  vnet_name           = "vnet-${var.environment}"
}