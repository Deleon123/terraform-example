# Backend Configuration

> **Remote backend configuration for AWS S3 and Azure Storage**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This directory contains the configuration of remote backends needed to store Terraform state securely and shared. It creates resources both in AWS (S3) and Azure (Storage Account) to support different projects.

## Resources Created

### AWS
- **S3 Bucket**: Bucket to store remote state
- **Versioning**: Versioning enabled for the bucket

### Azure
- **Resource Group**: Resource group to organize resources
- **Storage Account**: Storage account for remote state
- **Storage Container**: Container to store state files

## File Structure

```
backend/
├── main.tf                    # Main provider configuration
├── bucket.tf                  # S3 bucket configuration
├── storage_account.tf         # Azure storage account configuration
├── variables.tf               # Input variables
├── locals.tf                  # Common tags
├── outputs.tf                 # Resource outputs
├── terraform.tfvars           # Variable values
└── README.md                  # This file
```

## Configuration

### Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `location` | Azure resource location | `Brazil South` |
| `account_tier` | Storage account tier | `Standard` |
| `account_replication_type` | Replication type | `LRS` |
| `resource_group_name` | Resource group name | `rg-estudos-terraform` |
| `storage_account_name` | Storage account name | `deleonterraform` |
| `storage_container_name` | Container name | `terraform-container-remote-state` |

### Common Tags

```hcl
locals {
  common_tags = {
    Owner       = "Deleon"
    Project     = "Estudos Terraform"
    managed-by  = "terraform"
    environment = "Development"
  }
}
```

## How to Run

### 1. Prerequisites

- Terraform >= 1.3.0
- AWS CLI configured
- Azure CLI configured

### 2. Configure credentials

```bash
# AWS
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"

# Azure
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### 3. Run Terraform

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply
```

## Detailed Configuration

### S3 Bucket (AWS)

```hcl
resource "aws_s3_bucket" "aws_bucket" {
  bucket = "deleon-bucket-aws-remote-state"
}

resource "aws_s3_bucket_versioning" "aws_bucket_versioning" {
  bucket = aws_s3_bucket.aws_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

### Storage Account (Azure)

```hcl
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rgazure1.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  
  blob_properties {
    versioning_enabled = true
  }
  
  tags = local.common_tags
}
```

## Backend Usage

### AWS S3 Backend

To use the S3 bucket as backend:

```hcl
terraform {
  backend "s3" {
    bucket = "deleon-bucket-aws-remote-state"
    key    = "path/to/terraform.tfstate"
    region = "sa-east-1"
  }
}
```

### Azure Storage Backend

To use the Azure storage account as backend:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-estudos-terraform"
    storage_account_name = "deleonterraform"
    container_name       = "terraform-container-remote-state"
    key                  = "path/to/terraform.tfstate"
  }
}
```

## Security

### S3 Bucket
- **Versioning**: Enabled for change history
- **Access**: Configured for Terraform use
- **Encryption**: Can be enabled as needed

### Azure Storage
- **Versioning**: Enabled for blobs
- **Access**: Private container
- **Encryption**: Automatic Azure encryption

## Outputs

The project exposes important information:

```bash
# S3 information
terraform output bucket_arn

# Azure Storage information
terraform output storage_account_id
terraform output sa_primary_access_key
```

## Remote Backend Benefits

- **Collaboration**: Multiple people can work on the same project
- **Consistency**: Centralized and versioned state
- **Security**: State stored securely
- **Backup**: Automatic versioning
- **Locking**: Prevents simultaneous executions (with DynamoDB/Table Storage)

## Next Steps

- Configure locking with DynamoDB (AWS) or Table Storage (Azure)
- Enable encryption on buckets/containers
- Configure more restrictive access policies
- Implement automatic backup
- Configure state change alerts

## References

- [Terraform Backends](https://www.terraform.io/docs/language/settings/backends/index.html)
- [S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [Azure Backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html)

---

**Foundation for collaborative and secure infrastructure**