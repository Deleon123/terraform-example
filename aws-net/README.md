# AWS Network (VPC)

> **Basic AWS network configuration with VPC, subnet and security group**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create a basic network infrastructure in AWS, including VPC, public subnet, internet gateway, route table and security group. It's a fundamental example to understand networking concepts in AWS.

## Resources Created

- **VPC**: Private virtual network with CIDR 10.0.0.0/16
- **Subnet**: Public subnet with CIDR 10.0.1.0/24
- **Internet Gateway**: Gateway for internet connectivity
- **Route Table**: Route table with default route
- **Route Table Association**: Association between subnet and route table
- **Security Group**: Security group with SSH rules

## File Structure

```
aws-net/
├── main.tf              # Main provider configuration
├── network.tf           # Network configuration
├── outputs.tf           # Resource outputs
└── README.md            # This file
```

## Network Configuration

### VPC
- **Name**: vpc-terraform
- **CIDR**: 10.0.0.0/16
- **Region**: sa-east-1 (São Paulo)

### Subnet
- **Name**: sn-terraform
- **CIDR**: 10.0.1.0/24
- **Type**: Public (with internet gateway)

### Internet Gateway
- **Name**: igw-terraform
- **Function**: Internet connectivity

### Route Table
- **Name**: rt-terraform
- **Default Route**: 0.0.0.0/0 → Internet Gateway

### Security Group
- **Name**: security-group-terraform
- **Rules**:
  - SSH (22) - Allowed from any source
  - Egress - Allowed to any destination

## How to Run

### 1. Prerequisites

- Terraform >= 1.3.0
- AWS CLI configured

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
  key    = "aws-vpc/terraform.tfstate"
  region = "sa-east-1"
}
```

## Security

### Security Group Rules

#### Ingress (Inbound)
- **SSH (22)**: Allowed from any source (0.0.0.0/0)
- **Protocol**: TCP
- **IPv6**: Also allowed (::/0)

#### Egress (Outbound)
- **All ports**: Allowed to any destination
- **Protocol**: All (-1)

## Network Architecture

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
│  │  │    Internet Gateway         │││
│  │  │    (External Connectivity)  │││
│  │  └─────────────────────────────┘││
│  │                                 ││
│  │  ┌─────────────────────────────┐││
│  │  │    Route Table              │││
│  │  │    0.0.0.0/0 → IGW          │││
│  │  └─────────────────────────────┘││
│  │                                 ││
│  │  ┌─────────────────────────────┐││
│  │  │    Security Group           │││
│  │  │    SSH (22) Allow           │││
│  │  └─────────────────────────────┘││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

## Concepts Demonstrated

- **VPC**: Private virtual network creation
- **Subnets**: Logical network division
- **Internet Gateway**: Internet connectivity
- **Route Tables**: Routing control
- **Security Groups**: Network traffic control
- **CIDR**: Network addressing notation
- **Remote Backend**: Shared state in S3

## Outputs

The project exposes important IDs for use in other projects:

```bash
# Subnet ID
terraform output subnet_id

# Security Group ID
terraform output security_group_id
```

## Usage in Other Projects

This project is used as a base for other projects that need a VPC. The outputs can be accessed via remote state:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "deleon-bucket-aws-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}

# Use the subnet
subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id

# Use the security group
security_group_id = data.terraform_remote_state.vpc.outputs.security_group_id
```

## Next Steps

- Add more subnets in different AZs
- Configure NAT Gateway for private subnets
- Implement VPC Peering
- Add more security rules
- Configure VPN Gateway
- Implement Network ACLs

## References

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Solid foundation for AWS networking with Terraform**