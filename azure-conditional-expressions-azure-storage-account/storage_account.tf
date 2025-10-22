resource "azurerm_resource_group" "rgazure1" {
  name     = "rg_${var.environment}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "storage_account" {
  count = var.environment != "dev" ? 1 : 0

  name                     = "conditionaldeleon${var.environment}"
  resource_group_name      = azurerm_resource_group.rgazure1.name
  location                 = azurerm_resource_group.rgazure1.location
  account_tier             = var.environment != "prod" ? "Standard" : "Premium"
  account_replication_type = var.environment == "prod" ? "RAGZRS" : "LRS"

  tags = local.common_tags
}
