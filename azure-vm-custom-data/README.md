# Azure VM with Custom Data

> **Azure virtual machine with custom data for automatic configuration**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use **custom data** in Azure to automate the initial configuration of a virtual machine. Custom data is executed automatically when the VM is started for the first time through the Azure VM Agent.

## Resources Created

- **Resource Group**: Resource group to organize resources
- **Public IP**: Dynamic public IP address
- **Network Interface**: Network interface connected to existing subnet
- **Linux VM**: Ubuntu 18.04 LTS virtual machine with custom data
- **NSG Association**: Association with existing NSG

## File Structure

```
azure-vm-custom-data/
├── main.tf              # Main configuration and remote data
├── vm.tf                # VM definition with custom data
├── outputs.tf           # Project outputs
├── variables.tf         # Input variables
├── locals.tf            # Common tags
├── docs/                # Scripts for custom data
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

## Custom Data Implementation

```hcl
custom_data = base64encode(file("./docs/docker.sh"))
```

### What Custom Data does:

The `docs/docker.sh` script is automatically executed during VM initialization to:
- Update the system
- Install Docker
- Configure services
- Create configuration files

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

## Custom Data Verification

After creation, you can verify if custom data was executed:

```bash
# Connect to VM
ssh -i azure-key terraform@<public-ip>

# Check custom data logs
sudo cat /var/log/azure/custom-script/handler.log

# Check if Docker was installed
docker --version

# Check services
sudo systemctl status docker
```

## Concepts Demonstrated

- **Custom Data**: Automatic configuration during initialization
- **Base64 Encoding**: Encoding required for custom data
- **Azure VM Agent**: Agent that executes custom data
- **Remote State**: Access to resources from other projects
- **Data Sources**: Query existing resources
- **Remote Backend**: Shared state in Azure Storage

## Remote Backend

This project is configured to use a remote backend in Azure Storage:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-estudos-terraform"
  storage_account_name = "deleonterraform"
  container_name       = "container-tfvars-file"
  key                  = "azure-vm-custom-data/terraform.tfstate"
}
```

## Custom Data Advantages

- **Automatic**: Executes automatically during initialization
- **Flexible**: Supports complex scripts
- **Integrated**: Works natively with Azure VMs
- **Reliable**: Managed by Azure VM Agent
- **Base64**: Secure encoding for transfer

## Important Considerations

### Custom Data Limitations
- **Size**: Maximum of 64KB
- **Execution**: Only on first initialization
- **Encoding**: Must be base64 encoded
- **Timeout**: Has time limit for execution

### Alternatives
- **Azure VM Extensions**: For more complex configurations
- **ARM Templates**: For native configurations
- **Ansible/Chef**: For continuous configuration

## Next Steps

- Implement Azure VM Extensions
- Use templates for dynamic custom data
- Configure complete web applications
- Implement automatic monitoring
- Add database configuration

---

**Practical example of automation with custom data**