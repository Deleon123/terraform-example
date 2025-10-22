# Azure Storage Accounts with For Expressions

> **Using Terraform For Expressions to transform and manipulate output data**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use Terraform's **for expressions** to transform and manipulate data from multiple resources. While resources are created using `for_each`, the focus is on using **for expressions** in outputs to create lists and maps from the created resources. The project creates Resource Groups, Storage Accounts, and Storage Containers in three different Azure regions (Brazil South, East US, and West Europe).

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
azure-for-expression-storage-account/
├── main.tf              # Provider configuration
├── storage_account.tf   # Storage resources with for_each
├── variables.tf         # Input variables
├── locals.tf            # Common tags
├── outputs.tf           # Outputs using for expressions
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

## Architecture & Data Flow

```
┌────────────────────────────────────────────────────────────────────┐
│                        AZURE RESOURCES                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │
│  │ rg_brazil   │  │   rg_eua    │  │  rg_europa  │                │
│  │   +         │  │      +      │  │      +      │                │
│  │ Storage     │  │  Storage    │  │  Storage    │                │
│  │ Account     │  │  Account    │  │  Account    │                │
│  │   +         │  │      +      │  │      +      │                │
│  │ Container   │  │  Container  │  │  Container  │                │
│  └─────────────┘  └─────────────┘  └─────────────┘                │
└────────────────────────────────────────────────────────────────────┘
                            |
                            | Resource Data
                            v
┌────────────────────────────────────────────────────────────────────┐
│                    FOR EXPRESSIONS (Outputs)                       │
│                                                                    │
│  Input: azurerm_storage_account.storage_account (Map)             │
│  {                                                                 │
│    "brazil" = { id="...", name="deleonsabrazil", ... }             │
│    "eua"    = { id="...", name="deleonsaeua", ... }                │
│    "europa" = { id="...", name="deleonsaeuropa", ... }             │
│  }                                                                 │
│                                                                    │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │ LIST TRANSFORMATION                                        │   │
│  │ [for sa in ... : sa.id]                                    │   │
│  │ Output: ["id1", "id2", "id3"]                              │   │
│  └────────────────────────────────────────────────────────────┘   │
│                                                                    │
│  ┌────────────────────────────────────────────────────────────┐   │
│  │ MAP TRANSFORMATION                                         │   │
│  │ {for k, v in ... : k => v.primary_access_key}              │   │
│  │ Output: {brazil="key1", eua="key2", europa="key3"}         │   │
│  └────────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────────┘
                            |
                            | Transformed Data
                            v
┌────────────────────────────────────────────────────────────────────┐
│                        OUTPUTS                                     │
│  ✓ storage_accounts_id (list)                                     │
│  ✓ sa_primary_access_keys (map)                                   │
└────────────────────────────────────────────────────────────────────┘
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

- **For Expressions**: Transform collections into lists and maps
- **List Comprehension**: Creating lists from resource attributes with `[for ...]`
- **Map Comprehension**: Creating maps from resource attributes with `{for ... : ... => ...}`
- **for_each**: Creating multiple similar resources from a map
- **Dependency Management**: Resources depend on each other (RG → SA → Container)
- **Data Transformation**: Converting resource data into useful output formats
- **Multi-region Deployment**: Resources across different Azure regions

## For Expressions in Outputs

The main focus of this project is demonstrating **for expressions** to transform resource data.

### What are For Expressions?

For expressions allow you to transform one collection type into another by iterating over its elements:

| Type | Syntax | Input | Output | Use Case |
|------|--------|-------|--------|----------|
| **List** | `[for x in list : x.attr]` | Map/List | List | Get all values as array |
| **Map** | `{for k, v in map : k => v.attr}` | Map | Map | Transform to key-value pairs |
| **Filtered List** | `[for x in list : x.attr if condition]` | Map/List | List | Filter and transform |
| **Object** | `{for x in list : x.key => {...}}` | List | Map | Create complex structures |

### Quick Comparison

```hcl
# Input: { "brazil" = {...}, "eua" = {...}, "europa" = {...} }

# List (extracts values only)
[for sa in storage : sa.name]
# → ["deleonsabrazil", "deleonsaeua", "deleonsaeuropa"]

# Map (keeps keys)
{ for k, sa in storage : k => sa.name }
# → { brazil = "deleonsabrazil", eua = "deleonsaeua", europa = "deleonsaeuropa" }

# Filtered (with condition)
[for sa in storage : sa.name if sa.location == "eastus"]
# → ["deleonsaeua"]
```

### List Output (Array of IDs)

```hcl
output "storage_accounts_id" {
  description = "IDs of the storage accounts"
  value       = [for storage_account in azurerm_storage_account.storage_account : storage_account.id]
}
```

This creates a **list** containing all storage account IDs:
```bash
terraform output storage_accounts_id
# Output:
# [
#   "/subscriptions/.../resourceGroups/rg_brazil/providers/Microsoft.Storage/storageAccounts/deleonsabrazil",
#   "/subscriptions/.../resourceGroups/rg_eua/providers/Microsoft.Storage/storageAccounts/deleonsaeua",
#   "/subscriptions/.../resourceGroups/rg_europa/providers/Microsoft.Storage/storageAccounts/deleonsaeuropa"
# ]
```

### Map Output (Object with Keys)

```hcl
output "sa_primary_access_keys" {
  description = "Primary access keys of the storage accounts"
  value       = { for key, value in azurerm_storage_account.storage_account : key => value.primary_access_key }
  sensitive   = true
}
```

This creates a **map** with region names as keys and access keys as values:
```bash
terraform output sa_primary_access_keys
# Output:
# {
#   "brazil" = "abcd1234..."
#   "eua"    = "efgh5678..."
#   "europa" = "ijkl9012..."
# }
```

## For Expression Examples

### List Comprehension Examples

```hcl
# List of storage account names
output "storage_account_names" {
  value = [for sa in azurerm_storage_account.storage_account : sa.name]
  # Result: ["deleonsabrazil", "deleonsaeua", "deleonsaeuropa"]
}

# List of storage account locations
output "storage_account_locations" {
  value = [for sa in azurerm_storage_account.storage_account : sa.location]
  # Result: ["brazilsouth", "eastus", "westeurope"]
}

# List of resource IDs
output "storage_account_ids" {
  value = [for sa in azurerm_storage_account.storage_account : sa.id]
  # Result: ["/subscriptions/.../deleonsabrazil", "/subscriptions/.../deleonsaeua", ...]
}
```

### Map Comprehension Examples

```hcl
# Map of region => storage account name
output "region_to_storage_name" {
  value = { for key, sa in azurerm_storage_account.storage_account : key => sa.name }
  # Result: { brazil = "deleonsabrazil", eua = "deleonsaeua", europa = "deleonsaeuropa" }
}

# Map of region => storage account ID
output "region_to_storage_id" {
  value = { for key, sa in azurerm_storage_account.storage_account : key => sa.id }
  # Result: { brazil = "/subscriptions/.../deleonsabrazil", ... }
}

# Map of storage name => primary endpoint
output "name_to_primary_blob_endpoint" {
  value = { for key, sa in azurerm_storage_account.storage_account : sa.name => sa.primary_blob_endpoint }
  # Result: { deleonsabrazil = "https://deleonsabrazil.blob.core.windows.net/", ... }
}
```

### Conditional For Expressions

```hcl
# Only storage accounts in specific regions
output "us_storage_accounts" {
  value = [
    for key, sa in azurerm_storage_account.storage_account : sa.name
    if sa.location == "eastus"
  ]
  # Result: ["deleonsaeua"]
}

# Storage accounts with specific tier
output "standard_storage_accounts" {
  value = [
    for sa in azurerm_storage_account.storage_account : sa.name
    if sa.account_tier == "Standard"
  ]
}
```

### Complex Transformations

```hcl
# Create custom objects with for expressions
output "storage_account_details" {
  value = [
    for key, sa in azurerm_storage_account.storage_account : {
      region   = key
      name     = sa.name
      location = sa.location
      tier     = sa.account_tier
      endpoint = sa.primary_blob_endpoint
    }
  ]
}
```

## Benefits of For Expressions

- **Data Transformation**: Convert resource collections into desired formats
- **Flexibility**: Create lists, maps, or complex objects from resource data
- **Filtering**: Use conditional expressions to filter data
- **Readability**: Clear and concise syntax for data manipulation
- **Reusability**: Outputs can be consumed by other Terraform modules or external tools
- **Type Safety**: Terraform validates the output structure

## For Expression Syntax Patterns

### List Pattern
```hcl
[for item in collection : item.attribute]
```

### Map Pattern
```hcl
{ for key, value in collection : key => value.attribute }
```

### Conditional Pattern
```hcl
[for item in collection : item.attribute if condition]
```

### Complex Object Pattern
```hcl
[for item in collection : {
  field1 = item.attribute1
  field2 = item.attribute2
}]
```

## Next Steps

- Add more complex for expressions with filtering
- Implement for expressions with multiple conditions
- Use for expressions in local values
- Combine for expressions with other Terraform functions
- Create nested for expressions for hierarchical data
- Use for expressions with `flatten()` function
- Transform data for external integrations

## Real-World Use Cases

1. **CI/CD Integration**: Export resource IDs as lists for pipeline consumption
2. **Monitoring Setup**: Generate maps of resources for monitoring tools
3. **Documentation**: Create structured outputs for automated documentation
4. **Cross-Module References**: Export data in formats expected by other modules
5. **API Integration**: Transform Terraform data for external APIs

## References

- [Terraform For Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
- [Terraform for_each Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [Terraform Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)
- [Azure Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)

---

**Transform and manipulate Terraform data with powerful for expressions**