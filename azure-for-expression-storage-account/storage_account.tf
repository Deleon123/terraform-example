resource "azurerm_resource_group" "rgazure1" {
  for_each = var.location

  name     = "rg_${each.key}"
  location = each.value
  tags     = local.common_tags
}

resource "azurerm_storage_account" "storage_account" {
  for_each = azurerm_resource_group.rgazure1

  name                     = "deleonsa${each.key}"
  resource_group_name      = each.value.name
  location                 = each.value.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = local.common_tags

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "storage_container" {
  for_each = azurerm_storage_account.storage_account

  name                  = "container-each-${each.key}"
  storage_account_name  = each.value.name
  container_access_type = "private"
}
