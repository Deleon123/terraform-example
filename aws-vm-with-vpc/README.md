# AWS VM with External VPC

> **AWS EC2 instance connected to external VPC via remote state**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create an EC2 instance in AWS that uses network resources (VPC, subnet, security group) created in a separate project. It's an example of how to divide infrastructure into modular and reusable projects.

## Resources Created

- **Key Pair**: SSH key pair for instance access
- **EC2 Instance**: Ubuntu instance with public IP
- **Remote State Connection**: Connection to external network resources

## File Structure

```
aws-vm-with-vpc/
├── main.tf              # Main configuration and remote data
├── vm.tf                # EC2 instance definition
├── output.tf            # Project outputs
├── aws-key.pub          # Public SSH key
├── aws-key              # Private SSH key
└── README.md            # This file
```

## Configuration

### Dependencies

This project depends on an `aws-vpc` project that must be run first to create:
- VPC
- Public subnet
- Internet Gateway
- Security Group

### Remote State

The project uses `terraform_remote_state` to access resources created in another project:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "deleon-bucket-aws-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}
```

## How to Run

### 1. Prerequisites

- The `aws-vpc` project must be run first
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
  key    = "aws-vm/terraform.tfstate"
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
- **Name**: aws-key
- **Key**: SSH key pair included in the project

### Security Group
- Uses the security group created in the `aws-vpc` project
- SSH and HTTP rules already configured

## Connectivity

After creation, you can access the instance via SSH:

```bash
ssh -i aws-key ubuntu@<public-ip>
```

## Concepts Demonstrated

- **Remote State**: Access to resources from other projects
- **Data Sources**: Query existing resources
- **Dependencies**: Execution order between projects
- **Remote Backend**: Shared state in S3
- **Modularization**: Separation of responsibilities

## Dependency Flow

```
1. aws-vpc/           (creates VPC, subnet, security group)
       ↓
2. aws-vm-with-vpc/   (uses VPC resources)
```

## Outputs

The project exposes the instance's public IP:

```bash
terraform output vm_ip
```

## Architecture

```
┌─────────────────────────────────────┐
│              AWS VPC                │
│         (created externally)        │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         Public Subnet           │ │
│  │                                 │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │      EC2 Instance           │ │ │
│  │  │      t3.micro               │ │ │
│  │  │      Ubuntu 20.04           │ │ │
│  │  │      + Public IP            │ │ │
│  │  └─────────────────────────────┘ │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Approach Advantages

- **Modularity**: Clear separation of responsibilities
- **Reusability**: VPC can be used by multiple instances
- **Scalability**: Easy addition of more instances
- **Maintenance**: Network changes don't affect instances
- **Collaboration**: Different teams can manage different parts

## Next Steps

- Add more instances to the same VPC
- Implement auto scaling group
- Configure load balancer
- Add instances in different AZs
- Implement monitoring with CloudWatch

---

**Example of modular and scalable architecture**