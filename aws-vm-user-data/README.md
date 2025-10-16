# AWS VM with User Data

> **AWS EC2 instance with user data for automatic configuration**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use **user data** in AWS to automate the initial configuration of an EC2 instance. User data is executed automatically when the instance is started for the first time.

## Resources Created

- **Key Pair**: SSH key pair for instance access
- **EC2 Instance**: Ubuntu instance with user data
- **Remote State Connection**: Connection to external network resources

## File Structure

```
aws-vm-user-data/
├── main.tf              # Main configuration and remote data
├── vm.tf                # Instance definition with user data
├── output.tf            # Project outputs
├── docs/                # Files for transfer
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

## User Data Implementation

```hcl
user_data = file("./docs/docker.sh")
```

### What User Data does:

The `docs/docker.sh` script is automatically executed during instance initialization to:
- Update packages
- Install Docker
- Configure services
- Create configuration files

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

## User Data Verification

After creation, you can verify if user data was executed:

```bash
# Connect to instance
ssh -i aws-key ubuntu@<public-ip>

# Check user data logs
sudo cat /var/log/cloud-init-output.log

# Check if Docker was installed
docker --version

# Check services
sudo systemctl status docker
```

## Concepts Demonstrated

- **User Data**: Automatic configuration during initialization
- **Cloud-Init**: Instance initialization system
- **Remote State**: Access to resources from other projects
- **Data Sources**: Query existing resources
- **Remote Backend**: Shared state in S3

## Remote Backend

This project is configured to use a remote backend in S3:

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "aws-vm-user-data/terraform.tfstate"
  region = "sa-east-1"
}
```

## User Data Advantages

- **Automatic**: Executes automatically during initialization
- **Idempotent**: Can be executed multiple times
- **Flexible**: Supports complex scripts
- **Integrated**: Works natively with EC2
- **Reliable**: Managed by AWS Cloud-Init

## Next Steps

- Implement more complex scripts
- Use templates for dynamic user data
- Configure complete web applications
- Implement automatic monitoring
- Add database configuration

---

**Practical example of automation with user data**