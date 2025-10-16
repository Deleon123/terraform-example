# Azure VM with Remote Module

> **Azure virtual machine example using remote module for networking**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create a complete Azure virtual machine using a **remote module** for network configuration. It's a more modular and reusable approach for infrastructure.

## Resources Created

- **Resource Group**: Resource group to organize resources
- **Public IP**: Dynamic public IP address
- **Network Interface**: Network interface with IP configuration
- **Linux VM**: Ubuntu 18.04 LTS virtual machine
- **Network Security Group**: Security group with SSH rule
- **Virtual Network**: Virtual network with subnet (via remote module)

## File Structure

```
azure-vm-remote-module/
├── main.tf              # Main configuration and network module
├── vm.tf                # Virtual machine definition
├── network.tf           # Network security configuration
├── variables.tf         # Input variables
├── locals.tf            # Common tags
├── azure-key.pub        # Public SSH key
├── azure-key            # Private SSH key
└── README.md            # This file
```

## Configuration

### Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `location` | Resource location | `westeurope` |
| `environment` | Resource environment | `development` |

### Remote Module

The project uses the official Azure module for networking:

```hcl
module "network" {
  source  = "Azure/network/azurerm"
  version = "5.3.0"
  
  resource_group_name = azurerm_resource_group.resource_group.name
  resource_group_location = var.location
  use_for_each        = true
  tags                = local.common_tags
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet-${var.environment}"]
  vnet_name           = "vnet-${var.environment}"
}
```

## How to Run

### 1. Prerequisites

- Terraform >= 1.3.0
- Azure CLI configured
- SSH keys (already included in the project)

### 2. Configure Azure credentials

```bash
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

# To destroy
terraform destroy
```

## Remote Backend

This project is configured to use a remote backend in Azure Storage:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-estudos-terraform"
  storage_account_name = "deleonterraform"
  container_name       = "container-tfvars-file"
  key                  = "azure-vm-remote-module/terraform.tfstate"
}
```

## VM Specifications

- **Operating System**: Ubuntu 18.04 LTS
- **Size**: Standard_B1s (1 vCPU, 1 GB RAM)
- **Admin User**: terraform
- **Disk**: Standard_LRS
- **Access**: SSH via public key

## Security

- **NSG**: Only port 22 (SSH) allowed
- **SSH**: Access via public/private key
- **Tags**: Resources tagged for organization

## Connectivity

After creation, you can access the VM via SSH:

```bash
ssh -i azure-key terraform@<public-ip>
```

## Concepts Demonstrated

- **Remote Modules**: Use of official Azure/network module
- **Dependencies**: Correct order of resource creation
- **Remote Backend**: Shared state in Azure Storage
- **Tags**: Resource organization and identification
- **Security Groups**: Network access control

## Next Steps

- Add more security rules to NSG
- Implement monitoring with Azure Monitor
- Configure automatic backup
- Add more subnets and network resources

---

**Developed to learn remote modules in Terraform**
