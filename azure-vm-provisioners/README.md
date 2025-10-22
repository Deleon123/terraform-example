# Azure VM with Provisioners

> **Azure virtual machine with provisioners for post-creation automation**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use **provisioners** in Terraform to automate tasks after creating an Azure virtual machine. Provisioners allow you to execute scripts, transfer files, and configure the VM automatically.

## Resources Created

- **Resource Group**: Resource group to organize resources
- **Public IP**: Dynamic public IP address
- **Network Interface**: Network interface connected to existing subnet
- **Linux VM**: Ubuntu 18.04 LTS virtual machine with provisioners
- **NSG Association**: Association with existing NSG

## File Structure

```
azure-vm-provisioners/
├── main.tf              # Main configuration and remote data
├── vm.tf                # VM definition with provisioners
├── outputs.tf           # Project outputs
├── variables.tf         # Input variables
├── locals.tf            # Common tags
├── docs/                # Files for transfer
│   ├── teste1.txt       # Example file
│   └── teste2.txt       # Example file
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

## Implemented Provisioners

### 1. Local Exec Provisioner

```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip_address} > public_ip.txt"
}
```

**Function**: Saves the VM's public IP to a local file after creation.

### 2. Remote Exec Provisioner

```hcl
provisioner "remote-exec" {
  inline = [
    "echo subnet_id ${data.terraform_remote_state.vnet.outputs.subnet_id} >> /tmp/network_info.txt",
    "echo network_security_group_id: ${data.terraform_remote_state.vnet.outputs.network_security_group_id} >> /tmp/network_info.txt",
  ]
}
```

**Function**: Executes commands on the VM to create a file with network information.

### 3. File Provisioner (Folder)

```hcl
provisioner "file" {
  source      = "./docs/"
  destination = "/tmp"
}
```

**Function**: Transfers all files from the `docs/` folder to `/tmp` on the VM.

### 4. File Provisioner (Content)

```hcl
provisioner "file" {
  content     = "Vm size: ${self.size}"
  destination = "/tmp/vm_size.txt"
}
```

**Function**: Creates a file with the VM size using dynamic content.

## SSH Connection

```hcl
connection {
  type        = "ssh"
  host        = self.public_ip_address
  user        = "terraform"
  private_key = file("./azure-key")
}
```

**Configuration**: Defines how to connect to the VM to execute remote provisioners.

## VM Specifications

- **Operating System**: Ubuntu 18.04 LTS
- **Size**: Standard_B1s (1 vCPU, 1 GB RAM)
- **Admin User**: terraform
- **Disk**: Standard_LRS
- **Access**: SSH via public key

## Provisioner Execution Order

1. **Local Exec**: Saves public IP locally
2. **Remote Exec**: Creates network information file
3. **File (Folder)**: Transfers files from docs/ folder
4. **File (Content)**: Creates file with VM size

## Provisioner Verification

After creation, connect to the VM and verify the created files:

```bash
# Connect to VM
ssh -i azure-key terraform@<public-ip>

# Check created files
ls -la /tmp/
cat /tmp/network_info.txt
cat /tmp/vm_size.txt
```

## Concepts Demonstrated

- **Provisioners**: Post-creation resource automation
- **Local Exec**: Local environment command execution
- **Remote Exec**: Command execution on created VM
- **File Provisioner**: File transfer
- **Connection**: SSH connection configuration
- **Self References**: References to the resource itself

## Remote Backend

This project is configured to use a remote backend in Azure Storage:

```hcl
backend "azurerm" {
  resource_group_name  = "rg-estudos-terraform"
  storage_account_name = "deleonterraform"
  container_name       = "container-tfvars-file"
  key                  = "azure-vm-provisioners/terraform.tfstate"
}
```

## Important Considerations

### Provisioners are a Last Resort
- Use provisioners only when there's no alternative
- Prefer user data, custom data or configuration tools
- Provisioners can fail and leave resources in inconsistent state

### Error Handling
```hcl
provisioner "remote-exec" {
  on_failure = continue  # Continue even if it fails
  inline = [...]
}
```

## Next Steps

- Implement user data instead of provisioners
- Use tools like Ansible for configuration
- Implement health checks
- Configure automatic monitoring
- Add more robust initialization scripts

---

**Practical example of automation with provisioners**