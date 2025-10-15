variable "location" {
  description = "Location where the resources will be created on Azure"
  type        = string
  default     = "Brazil South"
}

variable "account_tier" {
  type        = string
  default     = "Standard"
  description = "Tier of the storage account to be created on Azure"
}

variable "account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Replication type of the storage account to be created on Azure"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-estudos-terraform"
  description = "Name of the resource group to be created on Azure"
}

variable "storage_account_name" {
  type        = string
  default     = "deleonterraform"
  description = "Name of the storage account to be created on Azure"
}

variable "storage_container_name" {
  type        = string
  default     = "terraform-container-remote-state"
  description = "Name of the storage container to be created on Azure"
}