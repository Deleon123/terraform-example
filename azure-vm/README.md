# Azure Virtual Machine

> **Basic Azure virtual machine using remote network state**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create a basic Azure virtual machine that uses the remote state of an existing virtual network. It's a fundamental example that shows how to connect resources between different Terraform projects.

## Resources Created

- **Resource Group**: Resource group to organize resources
- **Public IP**: Dynamic public IP address
- **Network Interface**: Network interface connected to existing subnet
- **Linux VM**: Ubuntu 18.04 LTS virtual machine
- **NSG Association**: Association with existing NSG

## File Structure

```
azure-vm/
├── main.tf              # Main configuration and remote data
├── vm.tf                # Virtual machine definition
├── outputs.tf           # Project outputs
├── variables.tf         # Input variables
├── locals.tf            # Common tags
├── azure-key.pub        # Public SSH key
├── azure-key            # Private SSH key
└── README.md            # This file
```

## Configuration

### Dependencies

This project depends on the `azure-vnet` project that must be run first to create:
- Virtual Network
- Subnet
- Network Security Group

### Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `location` | Resource location | `westeurope` |

### Remote State

The project uses `terraform_remote_state` to access resources created in another project:

```hcl
data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-estudos-terraform"
    storage_account_name = "deleonterraform"
    container_name       = "container-tfvars-file"
    key                  = "azure-vnet/terraform.tfstate"
  }
}
```

## How to Run

### 1. Prerequisites

- The `azure-vnet` project must be run first
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
  key                  = "azure-vm/terraform.tfstate"
}
```

## VM Specifications

- **Operating System**: Ubuntu 18.04 LTS
- **Size**: Standard_B1s (1 vCPU, 1 GB RAM)
- **Admin User**: terraform
- **Disk**: Standard_LRS
- **Access**: SSH via public key

## Security

### Network Security Group
- Uses the NSG created in the `azure-vnet` project
- SSH rules already configured
- Automatic association via `nisga`

### SSH
- Access via public/private key
- Keys included in the project

## Connectivity

After creation, you can access the VM via SSH:

```bash
ssh -i azure-key terraform@<public-ip>
```

## Concepts Demonstrated

- **Remote State**: Access to resources from other projects
- **Data Sources**: Query existing resources
- **Dependencies**: Execution order between projects
- **Remote Backend**: Shared state in Azure Storage
- **Resource Groups**: Azure resource organization

## Dependency Flow

```
1. azure-vnet/     (creates network, subnet, NSG)
       ↓
2. azure-vm/       (uses network resources)
```

## Outputs

The project exposes the VM's public IP:

```bash
terraform output vm_ip
```

## Architecture

```
┌─────────────────────────────────────┐
│         Azure Resource Group        │
│         rg-vm-terraform             │
│                                     │
│  ┌─────────────────────────────────┐│
│  │      Linux Virtual Machine      ││
│  │      Ubuntu 18.04 LTS           ││
│  │      Standard_B1s               ││
│  │                                 ││
│  │  ┌─────────────────────────────┐││
│  │  │    Network Interface        │││
│  │  │    + Public IP              │││
│  │  └─────────────────────────────┘││
│  └─────────────────────────────────┘│
│                                     │
│  Connects to azure-vnet/ network    │
└─────────────────────────────────────┘
```

## Next Steps

- Add more security rules
- Implement monitoring with Azure Monitor
- Configure automatic backup
- Add more VMs to the same network
- Implement load balancer

---

**Example of Terraform project integration**