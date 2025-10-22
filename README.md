# Terraform Learning Repository

> **A comprehensive repository for learning and practicing Infrastructure as Code with Terraform**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)

## Table of Contents

- [About](#about)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Directories](#directories)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Concepts Learned](#concepts-learned)
- [Contributing](#contributing)

## About

This repository was created to practice and learn Terraform through practical examples that cover:

- **AWS**: EC2 instances, VPCs, subnets, security groups
- **Azure**: Virtual machines, virtual networks, resource groups, storage accounts
- **Advanced Concepts**: Modules, provisioners, remote backends, outputs
- **Best Practices**: Code structure, versioning, tags, locals

## Project Structure

```
terraform-example/
├── aws-net/                     # Basic AWS network
├── aws-vm-local-module/         # AWS VM with local module
├── aws-vm-provisioners/         # AWS VM with provisioners
├── aws-vm-user-data/            # AWS VM with user data
├── aws-vm-with-vpc/             # AWS VM with custom VPC
├── azure-vm/                    # Basic Azure VM
├── azure-vm-custom-data/        # Azure VM with custom data
├── azure-vm-provisioners/       # Azure VM with provisioners
├── azure-vm-remote-module/      # Azure VM with remote module
├── azure-vnet/                  # Azure virtual network
├── backend/                     # Backend configuration
├── terraform-blocks-moved-removed-import/  # State manipulation examples
├── terraform-commands/          # Terraform commands
├── terraform-generate-config/   # Configuration generation
└── README.md                    # This file
```

## Quick Start

### 1. Clone the repository
```bash
git clone <your-repository>
cd terraform-example
```

### 2. Configure credentials
```bash
# AWS
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="sa-east-1"

# Azure
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### 3. Run an example
```bash
cd azure-vm-remote-module
terraform init
terraform plan
terraform apply
```

## Directories

### AWS
- **aws-net**: Basic AWS network configuration
- **aws-vm-local-module**: VM with local network module
- **aws-vm-provisioners**: VM with provisioning scripts
- **aws-vm-user-data**: VM with user data for initialization
- **aws-vm-with-vpc**: VM with custom VPC and subnet

### Azure
- **azure-vm**: Basic Azure virtual machine
- **azure-vm-custom-data**: VM with custom data
- **azure-vm-provisioners**: VM with provisioners
- **azure-vm-remote-module**: VM using Azure remote module
- **azure-vnet**: Azure virtual network with NSG

### Configuration
- **backend**: Remote backend configuration for S3 and Azure Storage

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [AWS CLI](https://aws.amazon.com/cli/) configured
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) configured
- SSH keys for instance access

## Configuration

### Environment Variables

Create a `.env` file based on `.env.example`:

```bash
# AWS
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_DEFAULT_REGION=sa-east-1

# Azure
ARM_CLIENT_ID=your-client-id
ARM_CLIENT_SECRET=your-client-secret
ARM_SUBSCRIPTION_ID=your-subscription-id
ARM_TENANT_ID=your-tenant-id
```

### SSH Keys

Each VM directory contains:
- `aws-key` / `azure-key`: Private SSH key
- `aws-key.pub` / `azure-key.pub`: Public SSH key

## Concepts Learned

### Terraform Core
- **Providers**: AWS and Azure
- **Resources**: EC2, VMs, VPCs, Subnets, Security Groups
- **Variables**: Input, output, locals
- **Modules**: Local and remote
- **Backends**: S3 and Azure Storage

### Architecture
- **Networking**: VPCs, subnets, security groups, NSGs
- **Compute**: EC2 instances, Azure VMs
- **Storage**: S3 buckets, Azure Storage Accounts
- **Security**: SSH keys, security groups, network security groups

### DevOps
- **Provisioners**: Initialization scripts
- **User Data**: Automatic instance configuration
- **Remote State**: Remote backend for collaboration
- **State Management**: Import, move, remove

## Contributing

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## License

This project is for educational purposes. Feel free to use and modify as needed.

---

**Developed to learn Terraform**
