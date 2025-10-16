# Terraform Commands

> **Practical examples of Terraform commands and backend configurations**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

## About

This directory contains practical examples of Terraform commands and backend configurations for different environments. It's a reference guide for essential commands and advanced configurations.

## File Structure

```
terraform-commands/
├── main.tf              # Main configuration
├── bucket.tf            # S3 bucket configuration
├── backend-dev.hcl      # Development backend configuration
├── backend-prod.hcl     # Production backend configuration
├── state.tfstate        # Local state file
└── README.md            # This file
```

## Essential Terraform Commands

### Initialization

```bash
# Initialize Terraform
terraform init

# Initialize with specific backend
terraform init -backend-config=backend-dev.hcl

# Reconfigure backend
terraform init -reconfigure
```

### Planning

```bash
# Create execution plan
terraform plan

# Save plan to file
terraform plan -out=plan.out

# Apply saved plan
terraform apply plan.out

# Plan with variables
terraform plan -var="environment=production"
```

### Application

```bash
# Apply changes
terraform apply

# Apply without confirmation
terraform apply -auto-approve

# Apply with variables
terraform apply -var="instance_type=t3.medium"
```

### Destruction

```bash
# Destroy resources
terraform destroy

# Destroy without confirmation
terraform destroy -auto-approve

# Destroy specific resources
terraform destroy -target=aws_instance.example
```

## Backend Configurations

### Development Backend

```hcl
# backend-dev.hcl
bucket = "deleon-bucket-aws-remote-state-dev"
key    = "terraform/dev/terraform.tfstate"
region = "sa-east-1"
```

### Production Backend

```hcl
# backend-prod.hcl
bucket = "deleon-bucket-aws-remote-state-prod"
key    = "terraform/prod/terraform.tfstate"
region = "sa-east-1"
```

### Using Backends

```bash
# Initialize with development backend
terraform init -backend-config=backend-dev.hcl

# Initialize with production backend
terraform init -backend-config=backend-prod.hcl
```

## State Commands

### Visualization

```bash
# Show current state
terraform show

# List resources
terraform state list

# Show specific resource
terraform state show aws_instance.example
```

### Manipulation

```bash
# Move resource
terraform state mv aws_instance.old aws_instance.new

# Remove resource from state
terraform state rm aws_instance.example

# Import existing resource
terraform import aws_instance.example i-1234567890abcdef0
```

## Debug Commands

### Logs

```bash
# Enable detailed logs
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Run command
terraform apply
```

### Validation

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt

# Check formatting
terraform fmt -check
```

## Output Commands

### Visualization

```bash
# Show outputs
terraform output

# Show specific output
terraform output instance_ip

# Show outputs in JSON
terraform output -json
```

## Workspace Commands

### Management

```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new production

# Select workspace
terraform workspace select production

# Show current workspace
terraform workspace show
```

## Advanced Commands

### Import

```bash
# Import existing resource
terraform import aws_instance.example i-1234567890abcdef0

# Import with configuration
terraform import -config=import.tf aws_instance.example i-1234567890abcdef0
```

### Refresh

```bash
# Update state with real infrastructure
terraform refresh

# Refresh with specific target
terraform refresh -target=aws_instance.example
```

### Taint

```bash
# Mark resource for recreation
terraform taint aws_instance.example

# Remove taint
terraform untaint aws_instance.example
```

## Configuration Structure

### main.tf
```hcl
terraform {
  required_version = ">= 1.3.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "deleon-bucket-example"
}
```

### bucket.tf
```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = "deleon-bucket-aws-remote-state"
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
```

## Tips and Best Practices

### 1. Always use remote backend
```bash
terraform init -backend-config=backend-prod.hcl
```

### 2. Save plans for audit
```bash
terraform plan -out=plan.out
terraform apply plan.out
```

### 3. Use workspaces for environments
```bash
terraform workspace new staging
terraform workspace select production
```

### 4. Validate before applying
```bash
terraform validate
terraform plan
terraform apply
```

### 5. Use variables for configuration
```bash
terraform apply -var="environment=production" -var="instance_count=3"
```

## Recommended Workflow

1. **Development**:
   ```bash
   terraform init -backend-config=backend-dev.hcl
   terraform workspace select development
   terraform plan
   terraform apply
   ```

2. **Production**:
   ```bash
   terraform init -backend-config=backend-prod.hcl
   terraform workspace select production
   terraform plan -out=production.plan
   terraform apply production.plan
   ```

## References

- [Terraform CLI Commands](https://www.terraform.io/docs/cli/commands/index.html)
- [Terraform Backend Configuration](https://www.terraform.io/docs/language/settings/backends/index.html)
- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)

---

**Complete Terraform commands guide**