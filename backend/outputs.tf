output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "sa_primary_access_key" {
  description = "Primary access key of the storage account"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}

output "bucket_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.aws_bucket.arn
}
