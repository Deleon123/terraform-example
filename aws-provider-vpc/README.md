# AWS Multi-Provider VPC

> **Multiple AWS providers configuration creating VPCs and subnets across different regions**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to configure and use multiple AWS providers in Terraform to create VPCs and subnets across different AWS regions. It showcases provider aliases, module provider configuration, and cross-region resource management using a single Terraform configuration.

## Resources Created

### VPCs (Created via Module)
- **Default VPC**: `vpc-terraform-provider-default` in Brazil South (sa-east-1)
- **US VPC**: `vpc-terraform-provider-1` in US East (us-east-1)
- **Europe VPC**: `vpc-terraform-provider-2` in Europe Central (eu-central-1)

### Subnets (Created in Root Module)
- **Brazil Subnet**: `sn-terraform-provider-default` (10.0.1.0/24) in Brazil South
- **US Subnet**: `sn-terraform-provider-1` (10.1.0.0/24) in US East
- **Europe Subnet**: `sn-terraform-provider-2` (10.2.1.0/24) in Europe Central

## File Structure

```
aws-provider-vpc/
├── main.tf              # Provider configuration and module call
├── network.tf           # Subnet resources with different providers
├── outputs.tf           # Resource outputs
├── vpc/                 # VPC module directory
│   ├── main.tf          # Module provider requirements
│   ├── vpc.tf           # VPC resources with different providers
│   └── outputs.tf       # Module outputs
└── README.md            # This file
```

## Provider Configuration

### Multiple AWS Providers

```hcl
# Default provider (Brazil South)
provider "aws" {
  region = "sa-east-1"
  default_tags {
    tags = {
      Owner      = "Deleon"
      Project    = "Estudos Terraform"
      managed-by = "terraform"
    }
  }
}

# US provider alias
provider "aws" {
  alias  = "unitedstates"
  region = "us-east-1"
  default_tags {
    tags = {
      Owner      = "Deleon"
      Project    = "Estudos Terraform"
      managed-by = "terraform"
    }
  }
}

# Europe provider alias
provider "aws" {
  alias  = "europe"
  region = "eu-central-1"
  default_tags {
    tags = {
      Owner      = "Deleon"
      Project    = "Estudos Terraform"
      managed-by = "terraform"
    }
  }
}
```

### Module Provider Mapping

```hcl
module "vpc" {
  source = "./vpc"

  providers = {
    aws.provider_1 = aws.unitedstates
    aws.provider_2 = aws.europe
  }
}
```

## Module Configuration

### VPC Module Provider Requirements

```hcl
# vpc/main.tf
terraform {
  required_providers {
    aws = {
      version               = "~> 6.0"
      source                = "hashicorp/aws"
      configuration_aliases = [aws.provider_1, aws.provider_2]
    }
  }
}
```

### VPC Resources in Module

```hcl
# vpc/vpc.tf
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-terraform-provider-default"
  }
}

resource "aws_vpc" "vpc_provider_1" {
  provider   = aws.provider_1
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-terraform-provider-1"
  }
}

resource "aws_vpc" "vpc_provider_2" {
  provider   = aws.provider_2
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "vpc-terraform-provider-2"
  }
}
```

## Network Configuration

### Subnet Resources with Different Providers

```hcl
# Brazil South subnet (default provider)
resource "aws_subnet" "subnet_default" {
  vpc_id     = module.vpc.vpc_id_provider_default
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "sn-terraform-provider-default"
  }
}

# US East subnet (unitedstates provider)
resource "aws_subnet" "subnet_unitedstates" {
  provider   = aws.unitedstates
  vpc_id     = module.vpc.vpc_id_provider_1
  cidr_block = "10.1.0.0/24"
  tags = {
    Name = "sn-terraform-provider-1"
  }
}

# Europe Central subnet (europe provider)
resource "aws_subnet" "subnet_europe" {
  provider   = aws.europe
  vpc_id     = module.vpc.vpc_id_provider_2
  cidr_block = "10.2.1.0/24"
  tags = {
    Name = "sn-terraform-provider-2"
  }
}
```

## Backend Configuration

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "aws-provider-vpc/terraform.tfstate"
  region = "sa-east-1"
}
```

## How to Execute

### 1. Prerequisites

- Terraform >= 1.3.0
- AWS CLI configured
- Access to all three regions (sa-east-1, us-east-1, eu-central-1)

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

## Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                        AWS Global Infrastructure               │
│                                                                │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   Brazil South  │  │    US East      │  │ Europe Central  │ │
│  │   (sa-east-1)   │  │   (us-east-1)   │  │ (eu-central-1)  │ │
│  │                 │  │                 │  │                 │ │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │ │
│  │ │ VPC         │ │  │ │ VPC         │ │  │ │ VPC         │ │ │
│  │ │10.0.0.0/16  │ │  │ │10.1.0.0/16  │ │  │ │10.2.0.0/16  │ │ │
│  │ │(default)    │ │  │ │(provider_1) │ │  │ │(provider_2) │ │ │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │ │
│  │                 │  │                 │  │                 │ │
│  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │ │
│  │ │ Subnet      │ │  │ │ Subnet      │ │  │ │ Subnet      │ │ │
│  │ │10.0.1.0/24  │ │  │ │10.1.0.0/24  │ │  │ │10.2.1.0/24  │ │ │
│  │ └─────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└────────────────────────────────────────────────────────────────┘
```

## Key Implementation Details

### Provider Aliases
- **Default**: No alias, uses sa-east-1
- **unitedstates**: Alias for us-east-1
- **europe**: Alias for eu-central-1

### Module Provider Mapping
- **provider_1**: Maps to `aws.unitedstates`
- **provider_2**: Maps to `aws.europe`
- **Default**: Uses root module's default provider

### Resource Dependencies
- VPCs are created in the module using different providers
- Subnets are created in the root module, referencing module outputs
- Each subnet uses the appropriate provider for its region

## Concepts Demonstrated

- **Provider Aliases**: Multiple providers for the same service
- **Module Provider Configuration**: Passing providers to modules
- **Cross-Region Deployment**: Resources across multiple AWS regions
- **Provider Requirements**: Declaring required provider aliases in modules
- **Resource Provider Assignment**: Explicitly assigning providers to resources
- **Module Outputs**: Accessing resources from different providers via module
- **Default Tags**: Consistent tagging across all providers

## Outputs

The project exposes subnet IDs from all three regions:

```bash
# Brazil South subnet ID
terraform output subnet_id

# US East subnet ID  
terraform output subnet_id_provider_1

# Europe Central subnet ID
terraform output subnet_id_provider_2
```

## Usage Examples

### Accessing Resources from Different Providers

```hcl
# Reference Brazil South subnet
subnet_id_brazil = aws_subnet.subnet_default.id

# Reference US East subnet
subnet_id_us = aws_subnet.subnet_unitedstates.id

# Reference Europe Central subnet
subnet_id_europe = aws_subnet.subnet_europe.id
```

### Module Output Usage

```hcl
# Access VPC IDs from module
vpc_id_brazil = module.vpc.vpc_id_provider_default
vpc_id_us = module.vpc.vpc_id_provider_1
vpc_id_europe = module.vpc.vpc_id_provider_2
```

## Benefits of Multiple Providers

- **Multi-Region Deployment**: Deploy resources across multiple regions
- **Disaster Recovery**: Resources in different geographic locations
- **Compliance**: Meet data residency requirements
- **Performance**: Resources closer to end users
- **Flexibility**: Different configurations per region
- **Cost Optimization**: Choose regions based on pricing

## Common Use Cases

- **Global Applications**: Deploy across multiple regions
- **Backup and DR**: Cross-region backup strategies
- **Compliance**: Data residency requirements
- **Performance**: Latency optimization
- **Cost Management**: Regional pricing differences

## Next Steps

- Add Internet Gateways for each VPC
- Configure Route Tables per region
- Add Security Groups with region-specific rules
- Implement VPC Peering between regions
- Add NAT Gateways for private subnets
- Configure Cross-Region Backup
- Add monitoring and alerting per region
- Implement Network Load Balancers across regions

## Troubleshooting

### Common Issues

1. **Provider Authentication**: Ensure AWS credentials work in all regions
2. **Resource Limits**: Check region-specific resource limits
3. **Pricing**: Verify costs across different regions
4. **Latency**: Consider network latency between regions

### Debugging Tips

```bash
# Check provider configuration
terraform providers

# Validate configuration
terraform validate

# Show execution plan
terraform plan -detailed-exitcode
```

## References

- [Terraform Provider Configuration](https://developer.hashicorp.com/terraform/language/providers/configuration)
- [Provider Aliases](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
- [Module Provider Requirements](https://developer.hashicorp.com/terraform/language/modules/develop/providers)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Multi-region AWS infrastructure with Terraform provider aliases**