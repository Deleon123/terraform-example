# AWS Network (VPC) with Count

> **Basic AWS network configuration with VPC and multiple subnets using count**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create a basic network infrastructure on AWS, including VPC and multiple subnets using Terraform's `count` resource. It's a fundamental example for understanding how to create multiple resources and networking concepts on AWS.

## Resources Created

- **VPC**: Private virtual network with CIDR 10.0.0.0/16
- **Subnets**: 3 subnets created using count with CIDRs:
  - Subnet 0: 10.0.0.0/24
  - Subnet 1: 10.0.1.0/24
  - Subnet 2: 10.0.2.0/24

## File Structure

```
aws-count-vpc/
├── main.tf              # Main provider and backend configuration
├── network.tf           # Network configuration (VPC and subnets)
├── outputs.tf           # Resource outputs
└── README.md            # This file
```

## Network Configuration

### VPC
- **Name**: vpc-terraform
- **CIDR**: 10.0.0.0/16
- **Region**: sa-east-1 (São Paulo)

### Subnets
- **Name**: sn-terraform-{0,1,2}
- **CIDRs**: 
  - sn-terraform-0: 10.0.0.0/24
  - sn-terraform-1: 10.0.1.0/24
  - sn-terraform-2: 10.0.2.0/24
- **Created with**: `count = 3` resource

## How to Execute

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

This project is configured to use a remote S3 backend:

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "count-aws-vpc/terraform.tfstate"
  region = "sa-east-1"
}
```

## Security

> **Note**: This project creates only basic VPC and subnets. For complete network functionality, it would be necessary to add Internet Gateway, Route Tables, Security Groups, and other connectivity resources.

## Network Architecture

```
┌─────────────────────────────────────┐
│              AWS VPC                │
│            10.0.0.0/16              │
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Subnet 0                ││
│  │         10.0.0.0/24             ││
│  │      sn-terraform-0             ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Subnet 1                ││
│  │         10.0.1.0/24             ││
│  │      sn-terraform-1             ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Subnet 2                ││
│  │         10.0.2.0/24             ││
│  │      sn-terraform-2             ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

## Concepts Demonstrated

- **VPC**: Private virtual network creation
- **Subnets**: Logical network division
- **Count**: Creation of multiple identical resources
- **CIDR**: Network addressing notation
- **Remote Backend**: Shared state in S3
- **Terraform Outputs**: Exporting values for other projects

## Outputs

The project exposes IDs of the created subnets for use in other projects:

```bash
# First subnet ID
terraform output subnet_id_1

# Second subnet ID
terraform output subnet_id_2

# Third subnet ID
terraform output subnet_id_3
```

## Usage in Other Projects

This project is used as a base for other projects that need a VPC. The outputs can be accessed via remote state:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "deleon-bucket-aws-remote-state"
    key    = "count-aws-vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}

# Use the subnets
subnet_id_1 = data.terraform_remote_state.vpc.outputs.subnet_id_1
subnet_id_2 = data.terraform_remote_state.vpc.outputs.subnet_id_2
subnet_id_3 = data.terraform_remote_state.vpc.outputs.subnet_id_3
```

## Next Steps

- Add Internet Gateway for external connectivity
- Configure Route Tables for each subnet
- Add Security Groups with specific rules
- Implement subnets in different Availability Zones
- Configure NAT Gateway for private subnets
- Add Network ACLs for additional control
- Implement VPC Peering
- Configure VPN Gateway

## References

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Solid foundation for AWS networking with Terraform using count for multiple subnets**
