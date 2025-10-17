variable "location" {
  description = "Location where the resources will be created on Azure"
  type        = map(string)
  default = {
    "brazil" = "brazilsouth"
    "eua"    = "eastus"
    "europa" = "westeurope"
  }
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
