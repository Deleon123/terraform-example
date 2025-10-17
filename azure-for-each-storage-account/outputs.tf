output "storage_account_brazil_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.storage_account["brazil"].id
}

output "storage_account_eua_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.storage_account["eua"].id
}

output "storage_account_europa_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.storage_account["europa"].id
}



output "sa_primary_access_key_brazil" {
  description = "Primary access key of the storage account"
  value       = azurerm_storage_account.storage_account["brazil"].primary_access_key
  sensitive   = true
}

output "sa_primary_access_key_eua" {
  description = "Primary access key of the storage account"
  value       = azurerm_storage_account.storage_account["eua"].primary_access_key
  sensitive   = true
}
output "sa_primary_access_key_europa" {
  description = "Primary access key of the storage account"
  value       = azurerm_storage_account.storage_account["europa"].primary_access_key
  sensitive   = true
}
