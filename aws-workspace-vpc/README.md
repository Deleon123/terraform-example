# Terraform Workspace - AWS VPC

> **Testing Terraform Workspaces with environment-based infrastructure**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

## What is Terraform Workspace?

Workspaces allow you to manage multiple environments (dev, staging, production) using the **same configuration** but with **separate state files**.

## This Example

Creates different infrastructure based on the workspace:
- **default/dev/others**: VPC with **2 subnets**
- **production**: VPC with **5 subnets**

### Code Using Workspace

```hcl
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "vpc-terraform-${terraform.workspace}"
  }
}

resource "aws_subnet" "subnet" {
  count      = terraform.workspace == "production" ? 5 : 2
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  
  tags = {
    Name = "sn-terraform-${terraform.workspace}-${count.index}"
  }
}
```

## Workspace Commands

### List Workspaces

```bash
terraform workspace list
```

**Output:**
```
  default
* dev
  production
```

> The `*` indicates the current workspace

### Show Current Workspace

```bash
terraform workspace show
```

**Output:**
```
dev
```

### Create New Workspace

```bash
terraform workspace new production
```

**Output:**
```
Created and switched to workspace "production"!
```

### Switch Workspace

```bash
terraform workspace select dev
```

**Output:**
```
Switched to workspace "dev".
```

### Delete Workspace

```bash
# Cannot delete current workspace, switch first
terraform workspace select default

# Delete workspace
terraform workspace delete dev
```

## Complete Workflow Example

### 1. Initialize Project

```bash
terraform init
```

### 2. Work in Default Workspace

```bash
# Check current workspace
terraform workspace show
# Output: default

# Apply infrastructure (creates 2 subnets)
terraform apply
```

**Resources created:**
- VPC: `vpc-terraform-default`
- 2 Subnets: `sn-terraform-default-0`, `sn-terraform-default-1`

### 3. Create Development Workspace

```bash
# Create and switch to dev
terraform workspace new dev

# Apply infrastructure (creates 2 subnets)
terraform apply
```

**Resources created:**
- VPC: `vpc-terraform-dev`
- 2 Subnets: `sn-terraform-dev-0`, `sn-terraform-dev-1`

### 4. Create Production Workspace

```bash
# Create and switch to production
terraform workspace new production

# Apply infrastructure (creates 5 subnets)
terraform apply
```

**Resources created:**
- VPC: `vpc-terraform-production`
- 5 Subnets: `sn-terraform-production-0` to `sn-terraform-production-4`

### 5. Switch Between Environments

```bash
# Switch to dev
terraform workspace select dev
terraform plan

# Switch to production
terraform workspace select production
terraform plan
```

## Workspace Variable

Use `terraform.workspace` in your code:

```hcl
# In tags
Name = "resource-${terraform.workspace}"

# In conditionals
count = terraform.workspace == "production" ? 5 : 2

# In resource names
name = "${var.app_name}-${terraform.workspace}"
```

## State File Organization

Each workspace has its own state file:

```
terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── production/
│   └── terraform.tfstate
└── staging/
    └── terraform.tfstate

terraform.tfstate  # default workspace state
```

## Comparison Table

| Workspace    | Subnets | VPC Name                   |
|--------------|---------|----------------------------|
| default      | 2       | vpc-terraform-default      |
| dev          | 2       | vpc-terraform-dev          |
| production   | 5       | vpc-terraform-production   |

## When to Use Workspaces?

✅ **Good for:**
- Same configuration, different environments
- Quick environment switching
- Testing configuration changes
- Small-medium projects

❌ **Not ideal for:**
- Completely different configurations per environment
- Different regions per environment
- Large enterprise projects (use separate folders/repos instead)

## Quick Reference

```bash
terraform workspace list           # List all workspaces
terraform workspace show           # Show current workspace
terraform workspace new <name>     # Create and switch to new workspace
terraform workspace select <name>  # Switch to existing workspace
terraform workspace delete <name>  # Delete workspace
```

## Key Points

- **Default workspace**: Always exists, cannot be deleted
- **Isolated states**: Each workspace has separate state
- **Same code**: All workspaces use the same `.tf` files
- **Switch freely**: Change workspaces without reinitializing

---

**Testing multiple environments with Terraform Workspaces**