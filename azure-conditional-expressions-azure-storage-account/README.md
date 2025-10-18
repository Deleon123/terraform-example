# Azure Storage Account with Conditional Expressions

> **Conditional resource creation using Terraform conditional expressions based on environment**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use Terraform's **conditional expressions** to create resources dynamically based on the environment variable. The storage account is created or skipped depending on the environment, and its configuration (tier and replication type) changes based on whether it's a production environment or not.

## How It Works

- **Resource Group**: Always created with name `rg_{environment}`
- **Storage Account**: 
  - **NOT created** if `environment = "dev"` 
  - **Created** if `environment != "dev"`
  - Uses **Premium tier + RAGZRS replication** if `environment = "prod"`
  - Uses **Standard tier + LRS replication** for any other environment

## File Structure

```
azure-conditional-expressions-azure-storage-account/
├── main.tf              # Provider configuration
├── storage_account.tf   # Conditional resource creation
├── variables.tf         # Input variables
├── locals.tf            # Common tags
└── README.md            # This file
```

## Variables

| Variable | Type | Default Value | Description |
|----------|------|---------------|-------------|
| `location` | `string` | `brazilsouth` | Azure region for resources |
| `environment` | `string` | (required) | Environment name (dev, prod, etc.) |

## Common Tags

```hcl
locals {
  common_tags = {
    Owner       = "Deleon"
    Project     = "Estudos Terraform"
    managed-by  = "terraform"
    environment = var.environment
  }
}
```

## How to Test

This example is designed for **testing with `terraform plan`** only. You don't need to apply the changes.

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

### 3. Test Different Environments

```bash
# Initialize
terraform init

# Test with DEV environment (Storage Account will NOT be created)
export TF_VAR_environment=dev
terraform plan

# Test with PROD environment (Premium Storage Account with RAGZRS)
export TF_VAR_environment=prod
terraform plan

# Test with any other environment (Standard Storage Account with LRS)
export TF_VAR_environment=staging
terraform plan

# Or pass the variable directly
terraform plan -var="environment=prod"
```

## Conditional Logic Flow

```
Environment Variable (TF_VAR_environment)
          |
          v
    ┌─────────────┐
    │ environment │
    └─────────────┘
          |
          v
    ┌──────────────────────────────────┐
    │ Resource Group Created           │
    │ Name: rg_{environment}           │
    │ Location: brazilsouth            │
    └──────────────────────────────────┘
          |
          v
    ┌─────────────────────────┐
    │ Is environment == "dev"?│
    └─────────────────────────┘
          |
    ┌─────┴─────┐
    |           |
   YES         NO
    |           |
    v           v
┌───────┐  ┌──────────────────────────┐
│ SKIP  │  │ Is environment == "prod"?│
│Storage│  └──────────────────────────┘
│Account│        |
└───────┘  ┌─────┴─────┐
           |           |
          YES         NO
           |           |
           v           v
   ┌──────────────┐ ┌──────────────┐
   │   Premium    │ │   Standard   │
   │   Storage    │ │   Storage    │
   │   Account    │ │   Account    │
   │              │ │              │
   │ Tier: Premium│ │Tier: Standard│
   │ Repl: RAGZRS │ │ Repl: LRS    │
   └──────────────┘ └──────────────┘
```

## Key Implementation Details

### Resource Group (Always Created)

```hcl
resource "azurerm_resource_group" "rgazure1" {
  name     = "rg_${var.environment}"
  location = var.location
  tags     = local.common_tags
}
```

### Storage Account (Conditional Creation)

```hcl
resource "azurerm_storage_account" "storage_account" {
  # Only create if environment is NOT "dev"
  count = var.environment != "dev" ? 1 : 0

  name                     = "conditionaldeleon${var.environment}"
  resource_group_name      = azurerm_resource_group.rgazure1.name
  location                 = azurerm_resource_group.rgazure1.location
  
  # Premium tier for prod, Standard for others
  account_tier             = var.environment != "prod" ? "Standard" : "Premium"
  
  # RAGZRS for prod, LRS for others
  account_replication_type = var.environment == "prod" ? "RAGZRS" : "LRS"

  tags = local.common_tags
}
```

## Concepts Demonstrated

- **Conditional Expressions**: Using ternary operators (`condition ? true_val : false_val`)
- **Count Meta-Argument**: Conditionally creating resources with `count`
- **Dynamic Configuration**: Different resource configurations based on environment
- **Variable Usage**: Using variables to control resource behavior
- **Local Values**: Common tags applied to all resources
- **Resource Dependencies**: Storage account depends on resource group
- **Environment-based Deployment**: Different configurations for dev, prod, staging

## Test Scenarios & Expected Results

### Scenario 1: Development Environment

```bash
export TF_VAR_environment=dev
terraform plan
```

**Expected Output:**
- ✅ Resource Group `rg_dev` will be created
- ❌ Storage Account will NOT be created (count = 0)

### Scenario 2: Production Environment

```bash
export TF_VAR_environment=prod
terraform plan
```

**Expected Output:**
- ✅ Resource Group `rg_prod` will be created
- ✅ Storage Account `conditionaldeleonprod` will be created
  - **Tier**: Premium
  - **Replication**: RAGZRS (Read-Access Geo-Zone-Redundant Storage)

### Scenario 3: Any Other Environment (staging, qa, test, etc.)

```bash
export TF_VAR_environment=staging
terraform plan
```

**Expected Output:**
- ✅ Resource Group `rg_staging` will be created
- ✅ Storage Account `conditionaldeleonstaging` will be created
  - **Tier**: Standard
  - **Replication**: LRS (Locally-Redundant Storage)

## Benefits of Conditional Expressions

- **Cost Optimization**: Premium resources only in production
- **Flexibility**: Different configurations per environment
- **Simplicity**: Single codebase for all environments
- **Safety**: No storage account in dev to prevent accidental costs
- **Maintainability**: Easy to understand conditional logic

## Next Steps

- Add more conditional logic for different storage features
- Implement network rules based on environment
- Add container creation conditionally
- Configure different encryption settings per environment
- Add monitoring and alerting based on environment
- Implement lifecycle management policies
- Use `for_each` instead of `count` for more flexibility
- Add validation rules for environment variable

## Real-World Use Cases

1. **Cost Control**: Expensive resources only in production
2. **Development Efficiency**: Skip unnecessary resources in dev/test
3. **Configuration Management**: Different settings per environment
4. **Compliance**: Enforce production-grade features only in prod
5. **Testing**: Safe environment testing without resource creation

## References

- [Terraform Conditional Expressions](https://developer.hashicorp.com/terraform/language/expressions/conditionals)
- [Terraform Count Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [Azure Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [Azure Storage Replication Types](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy)

---

**Environment-based conditional resource deployment with Terraform expressions**