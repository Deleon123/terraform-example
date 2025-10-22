
output "storage_accounts_id" {
  description = "IDs of the storage accounts"
  value       = [for storage_account in azurerm_storage_account.storage_account : storage_account.id]
}


output "sa_primary_access_keys" {
  description = "Primary access keys of the storage accounts"
  value       = { for key, value in azurerm_storage_account.storage_account : key => value.primary_access_key }
  sensitive   = true
}