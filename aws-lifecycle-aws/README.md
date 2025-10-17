# AWS Lifecycle Rules Testing

> **Terraform lifecycle rules demonstration with EC2 instance and S3 bucket**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use Terraform lifecycle rules to control resource behavior during creation, updates, and destruction. It creates an EC2 instance and S3 bucket with different lifecycle configurations to showcase various lifecycle management strategies.

## Resources Created

- **S3 Bucket**: `deleon-bucket-aws-remote-state-lifecycle-new-2` with lifecycle rules
- **S3 Bucket Versioning**: Versioning enabled for the bucket
- **Key Pair**: SSH key pair for EC2 access
- **EC2 Instance**: Ubuntu instance with lifecycle rules
- **Remote State Connection**: Connection to external VPC resources

## File Structure

```
aws-lifecycle-aws/
├── main.tf              # Provider configuration and remote state
├── vm.tf                # EC2 instance with lifecycle rules
├── bucket.tf            # S3 bucket with lifecycle rules
├── output.tf            # Project outputs
├── aws-key              # Private SSH key
├── aws-key.pub          # Public SSH key
└── README.md            # This file
```

## Lifecycle Rules Demonstrated

### S3 Bucket Lifecycle Rules

```hcl
resource "aws_s3_bucket" "aws_bucket" {
  bucket = "deleon-bucket-aws-remote-state-lifecycle-new-2"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }

  tags = {
    terraform = "yes"
  }
}
```

**Lifecycle Rules Applied:**
- **`create_before_destroy = true`**: Creates new bucket before destroying old one
- **`ignore_changes = [tags]`**: Ignores changes to tags after creation

### EC2 Instance Lifecycle Rules

```hcl
resource "aws_instance" "vm" {
  ami                         = "ami-035efd31ab8835d8a"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.key.key_name
  subnet_id                   = data.terraform_remote_state.vpc.outputs.subnet_id
  vpc_security_group_ids      = [data.terraform_remote_state.vpc.outputs.security_group_id]
  associate_public_ip_address = true

  lifecycle {
    replace_triggered_by = [aws_s3_bucket.aws_bucket]
    prevent_destroy = false # alter to true if you want to prevent the destruction of the resource
  }

  tags = {
    Name = "vm-terraform"
  }
}
```

**Lifecycle Rules Applied:**
- **`replace_triggered_by = [aws_s3_bucket.aws_bucket]`**: Replaces instance when bucket changes
- **`prevent_destroy = false`**: Allows destruction (can be set to true for protection)

## Configuration

### Dependencies

This project depends on an `aws-vpc` project that must be run first to create:
- VPC
- Public subnet
- Internet Gateway
- Security Group

### Remote State

The project uses `terraform_remote_state` to access VPC resources:

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

### Backend Configuration

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "aws-lifecycle-aws/terraform.tfstate"
  region = "sa-east-1"
}
```

## Lifecycle Rules Explained

### 1. `create_before_destroy = true`

**Purpose**: Ensures zero-downtime updates
**Behavior**: 
- Creates new resource before destroying old one
- Useful for resources that can't be updated in-place
- Prevents service interruption

**Example Use Cases**:
- S3 buckets
- RDS instances
- Load balancers

### 2. `ignore_changes = [tags]`

**Purpose**: Prevents Terraform from managing specific attributes
**Behavior**:
- Ignores changes to specified attributes
- Useful for attributes managed outside Terraform
- Prevents unnecessary updates

**Example Use Cases**:
- Tags managed by external systems
- Auto-generated attributes
- Attributes changed by AWS services

### 3. `replace_triggered_by = [resource]`

**Purpose**: Forces resource replacement when another resource changes
**Behavior**:
- Replaces resource when referenced resource changes
- Useful for maintaining consistency
- Triggers recreation even if resource itself hasn't changed

**Example Use Cases**:
- Instances that depend on specific configurations
- Resources that need to be recreated together
- Maintaining state consistency

### 4. `prevent_destroy = true/false`

**Purpose**: Protects critical resources from accidental destruction
**Behavior**:
- `true`: Prevents resource destruction
- `false`: Allows normal destruction
- Must be explicitly changed to destroy resource

**Example Use Cases**:
- Production databases
- Critical storage buckets
- Important network resources

## How to Execute

### 1. Prerequisites

- The `aws-vpc` project must be run first
- Terraform >= 1.3.0
- AWS CLI configured
- SSH keys (included in the project)

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

## Testing Lifecycle Rules

### Test 1: S3 Bucket Update

```bash
# Modify bucket name in bucket.tf
# Run terraform plan to see create_before_destroy in action
terraform plan
```

### Test 2: Tag Changes

```bash
# Modify tags in bucket.tf
# Run terraform plan - should show no changes due to ignore_changes
terraform plan
```

### Test 3: Instance Replacement

```bash
# Modify bucket configuration
# Run terraform plan - should show instance replacement due to replace_triggered_by
terraform plan
```

### Test 4: Prevent Destroy

```bash
# Change prevent_destroy to true in vm.tf
# Try to destroy - should fail
terraform destroy
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Infrastructure                       │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    S3 Bucket                                ││
│  │         deleon-bucket-aws-remote-state-                     ││
│  │                    lifecycle-new-2                          ││
│  │                                                             ││
│  │  Lifecycle Rules:                                           ││
│  │  • create_before_destroy = true                             ││
│  │  • ignore_changes = [tags]                                  ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    VPC (External)                           ││
│  │                                                             ││
│  │  ┌─────────────────────────────────────────────────────────┐││
│  │  │                Public Subnet                            │││
│  │  │                                                         │││
│  │  │  ┌─────────────────────────────────────────────────────┐│││
│  │  │  │              EC2 Instance                           ││││
│  │  │  │              t3.micro                               ││││
│  │  │  │              Ubuntu 20.04                           ││││
│  │  │  │              + Public IP                            ││││
│  │  │  │                                                     ││││
│  │  │  │  Lifecycle Rules:                                   ││││
│  │  │  │  • replace_triggered_by = [bucket]                  ││││
│  │  │  │  • prevent_destroy = false                          ││││
│  │  │  └─────────────────────────────────────────────────────┘│││
│  │  └─────────────────────────────────────────────────────────┘││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

## Concepts Demonstrated

- **Lifecycle Rules**: Controlling resource behavior during updates
- **create_before_destroy**: Zero-downtime updates
- **ignore_changes**: Selective attribute management
- **replace_triggered_by**: Forced resource replacement
- **prevent_destroy**: Resource protection
- **Remote State**: Accessing external resources
- **Resource Dependencies**: Managing resource relationships

## Lifecycle Rule Examples

### Complete Lifecycle Block

```hcl
resource "aws_instance" "example" {
  # ... resource configuration ...

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags, ami]
    replace_triggered_by  = [aws_s3_bucket.example]
  }
}
```

### Common Lifecycle Patterns

#### Database Protection
```hcl
resource "aws_db_instance" "database" {
  # ... configuration ...
  
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [password]
  }
}
```

#### Load Balancer Zero-Downtime
```hcl
resource "aws_lb" "load_balancer" {
  # ... configuration ...
  
  lifecycle {
    create_before_destroy = true
  }
}
```

#### Auto-Scaling Group Updates
```hcl
resource "aws_autoscaling_group" "asg" {
  # ... configuration ...
  
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
```

## Outputs

The project exposes the instance's public IP:

```bash
# VM public IP
terraform output vm_ip
```

## Benefits of Lifecycle Rules

- **Zero Downtime**: `create_before_destroy` prevents service interruption
- **Resource Protection**: `prevent_destroy` prevents accidental deletion
- **Selective Management**: `ignore_changes` allows external management
- **Consistency**: `replace_triggered_by` maintains resource relationships
- **Flexibility**: Different rules for different resource types

## Common Use Cases

- **Production Systems**: Protect critical resources
- **Blue-Green Deployments**: Zero-downtime updates
- **External Management**: Ignore externally managed attributes
- **Resource Dependencies**: Maintain consistency across resources
- **Testing**: Control resource behavior during development

## Next Steps

- Add more complex lifecycle rules
- Implement conditional lifecycle rules
- Add resource-specific lifecycle configurations
- Test lifecycle rules with different resource types
- Implement lifecycle rules for modules
- Add monitoring for lifecycle events
- Create lifecycle rule documentation
- Implement automated lifecycle testing

## Troubleshooting

### Common Issues

1. **Prevent Destroy**: Resource won't destroy - change `prevent_destroy` to `false`
2. **Replace Triggered**: Unexpected replacements - check `replace_triggered_by`
3. **Ignore Changes**: Changes not ignored - verify attribute names
4. **Create Before Destroy**: Resources not created - check resource dependencies

### Debugging Tips

```bash
# Check lifecycle rules
terraform show

# Validate configuration
terraform validate

# Plan with detailed output
terraform plan -detailed-exitcode
```

## References

- [Terraform Lifecycle Rules](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [AWS EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [AWS S3 Bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Terraform Remote State](https://developer.hashicorp.com/terraform/language/state/remote-state-data)

---

**Comprehensive Terraform lifecycle rules testing and demonstration**