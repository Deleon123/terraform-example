# Azure Storage Accounts with for_each

> **Multiple Azure Storage Accounts creation using for_each in different regions**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create multiple Azure Storage Accounts across different regions using Terraform's `for_each` construct. It creates Resource Groups, Storage Accounts, and Storage Containers in three different Azure regions (Brazil South, East US, and West Europe) using a single configuration block.

## Resources Created

- **Resource Groups**: 3 resource groups created using `for_each`
  - `rg_brazil` in Brazil South
  - `rg_eua` in East US  
  - `rg_europa` in West Europe

- **Storage Accounts**: 3 storage accounts created using `for_each`
  - `deleonsabrazil` in Brazil South
  - `deleonsaeua` in East US
  - `deleonsaeuropa` in West Europe

- **Storage Containers**: 3 private containers created using `for_each`
  - `container-each-brazil`
  - `container-each-eua`
  - `container-each-europa`

## File Structure

```
azure-for-each-storage-account/
├── main.tf              # Provider configuration
├── storage_account.tf   # Storage resources with for_each
├── variables.tf         # Input variables
├── locals.tf            # Common tags
├── outputs.tf           # Resource outputs
└── README.md            # This file
```

## Variables

| Variable | Type | Default Value | Description |
|----------|------|---------------|-------------|
| `location` | `map(string)` | See below | Azure regions for resources |
| `account_tier` | `string` | `Standard` | Storage account tier |
| `account_replication_type` | `string` | `LRS` | Replication type |

### Default Locations

```hcl
variable "location" {
  default = {
    "brazil" = "brazilsouth"
    "eua"    = "eastus"
    "europa" = "westeurope"
  }
}
```

## Common Tags

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

## How to Execute

### 1. Prerequisites

- Terraform >= 1.3.0
- Azure CLI configured
- Azure subscription

### 2. Configure Azure credentials

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "your-subscription-id"
```

### 3. Run Terraform

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# To destroy
terraform destroy
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Azure Cloud                              │
│                                                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   Brazil South  │  │    East US      │  │  West Europe    │  │
│  │                 │  │                 │  │                 │  │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │ Resource    │ │  │ │ Resource    │ │  │ │ Resource    │ │  │
│  │ │ Group       │ │  │ │ Group       │ │  │ │ Group       │ │  │
│  │ │ rg_brazil   │ │  │ │ rg_eua      │ │  │ │ rg_europa   │ │  │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  │                 │  │                 │  │                 │  │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │ Storage     │ │  │ │ Storage     │ │  │ │ Storage     │ │  │
│  │ │ Account     │ │  │ │ Account     │ │  │ │ Account     │ │  │
│  │ │deleonsa-    │ │  │ │deleonsa-    │ │  │ │deleonsa-    │ │  │
│  │ │brazil       │ │  │ │eua          │ │  │ │europa       │ │  │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  │                 │  │                 │  │                 │  │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │ Container   │ │  │ │ Container   │ │  │ │ Container   │ │  │
│  │ │container-   │ │  │ │container-   │ │  │ │container-   │ │  │
│  │ │each-brazil  │ │  │ │each-eua     │ │  │ │each-europa  │ │  │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Key Implementation Details

### Resource Group Creation

```hcl
resource "azurerm_resource_group" "rgazure1" {
  for_each = var.location

  name     = "rg_${each.key}"
  location = each.value
  tags     = local.common_tags
}
```

### Storage Account Creation

```hcl
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
```

### Storage Container Creation

```hcl
resource "azurerm_storage_container" "storage_container" {
  for_each = azurerm_storage_account.storage_account

  name                  = "container-each-${each.key}"
  storage_account_name  = each.value.name
  container_access_type = "private"
}
```

## Concepts Demonstrated

- **for_each**: Creating multiple similar resources from a map
- **Dependency Management**: Resources depend on each other (RG → SA → Container)
- **Variable Usage**: Using variables to define regions and configuration
- **Local Values**: Common tags applied to all resources
- **Resource Naming**: Dynamic naming using `each.key`
- **Azure Storage**: Storage accounts with versioning enabled
- **Multi-region Deployment**: Resources across different Azure regions

## Outputs

The project exposes storage account information for each region:

```bash
# Storage account IDs
terraform output storage_account_brazil_id
terraform output storage_account_eua_id
terraform output storage_account_europa_id

# Storage account access keys (sensitive)
terraform output sa_primary_access_key_brazil
terraform output sa_primary_access_key_eua
terraform output sa_primary_access_key_europa
```

## Usage Examples

### Accessing Storage Account Information

```hcl
# Reference a specific storage account
storage_account_id = azurerm_storage_account.storage_account["brazil"].id

# Reference storage account name
storage_account_name = azurerm_storage_account.storage_account["eua"].name

# Reference primary access key (sensitive)
access_key = azurerm_storage_account.storage_account["europa"].primary_access_key
```

### Iterating Over All Storage Accounts

```hcl
# Get all storage account names
storage_account_names = [
  for key, sa in azurerm_storage_account.storage_account : sa.name
]

# Get all storage account IDs
storage_account_ids = {
  for key, sa in azurerm_storage_account.storage_account : key => sa.id
}
```

## Benefits of for_each

- **Scalability**: Easy to add/remove regions by updating the variable
- **Consistency**: All resources follow the same pattern
- **Maintainability**: Single configuration block for multiple resources
- **Flexibility**: Different configurations per region if needed
- **Cost Management**: Resources can be easily managed per region

## Next Steps

- Add different storage account tiers per region
- Implement storage account encryption
- Add Network Rules for access control
- Configure backup policies
- Add monitoring and alerting
- Implement lifecycle management policies
- Add custom domains for storage accounts
- Configure cross-region replication

## References

- [Terraform for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [Azure Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [Azure Storage Container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)

---

**Efficient multi-region Azure storage deployment with Terraform for_each**