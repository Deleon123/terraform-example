# AWS VM with Local Module

> **AWS virtual machine using local module for network configuration**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create an EC2 instance in AWS using a **local module** for network configuration. It's a modular approach that allows code reuse and keeps infrastructure organized.

## Resources Created

- **Key Pair**: SSH key pair for instance access
- **EC2 Instance**: Ubuntu instance with public IP
- **VPC**: Virtual network (via local module)
- **Subnet**: Public subnet (via local module)
- **Security Group**: Security group (via local module)

## File Structure

```
aws-vm-local-module/
├── main.tf              # Main configuration and network module
├── vm.tf                # EC2 instance definition
├── variables.tf         # Input variables
├── output.tf            # Project outputs
├── network/             # Local network module
│   ├── main.tf          # Module main configuration
│   ├── networks.tf      # Network resources
│   ├── outputs.tf       # Module outputs
│   └── variables.tf     # Module variables
├── aws-key.pub          # Public SSH key
├── aws-key              # Private SSH key
└── README.md            # This file
```

## Configuration

### Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `environment` | Resource environment | `development` |

### Local Module

The project uses a local module for networking:

```hcl
module "network" {
  source      = "./network"
  cidr_vpc    = "10.0.0.0/16"
  cidr_subnet = "10.0.1.0/24"
  environment = "vm-${var.environment}"
}
```

## How to Run

### 1. Prerequisites

- Terraform >= 1.3.0
- AWS CLI configured
- SSH keys (already included in the project)

### 2. Configure AWS credentials

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="sa-east-1"
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

This project is configured to use a remote backend in S3:

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "aws-vm-local-module/terraform.tfstate"
  region = "sa-east-1"
}
```

## Instance Specifications

- **AMI**: Ubuntu Server 20.04 LTS (ami-035efd31ab8835d8a)
- **Type**: t3.micro (1 vCPU, 1 GB RAM)
- **Access**: SSH via public key
- **Public IP**: Automatically associated
- **Region**: sa-east-1 (São Paulo)

## Security

### Key Pair
- **Name**: aws-key-{environment}
- **Key**: SSH key pair included in the project

### Security Group
- **SSH (22)**: Allowed from any source
- **HTTP (80)**: Allowed from any source
- **HTTPS (443)**: Allowed from any source

## Architecture

```
┌─────────────────────────────────────┐
│              AWS VPC                │
│            10.0.0.0/16              │
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Public Subnet           ││
│  │         10.0.1.0/24             ││
│  │                                 ││
│  │  ┌─────────────────────────────┐││
│  │  │      EC2 Instance           │││
│  │  │      t3.micro               │││
│  │  │      Ubuntu 20.04           │││
│  │  └─────────────────────────────┘││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

## Concepts Demonstrated

- **Local Modules**: Code organization and reuse
- **VPC and Subnets**: AWS virtual network creation
- **Security Groups**: Network access control
- **Key Pairs**: SSH authentication
- **Remote Backend**: Shared state in S3
- **Outputs**: Exposure of important information

## Network Module

The local `./network` module creates:

- **VPC**: Virtual network with configurable CIDR
- **Subnet**: Public subnet with configurable CIDR
- **Internet Gateway**: Internet connectivity
- **Security Group**: Security group with basic rules

### Module Outputs
- `subnet_id`: ID of created subnet
- `security_group_id`: ID of created security group

## Connectivity

After creation, you can access the instance via SSH:

```bash
ssh -i aws-key ubuntu@<public-ip>
```

## Outputs

The project exposes the instance's public IP:

```bash
terraform output vm_ip
```

## Next Steps

- Add more security rules
- Implement monitoring with CloudWatch
- Configure automatic backup
- Add load balancer
- Implement auto scaling

---

**Practical example of local modules in Terraform**