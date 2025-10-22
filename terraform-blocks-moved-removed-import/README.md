# Terraform State Management

> **Examples of state manipulation: move, remove and import**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

## About

This directory contains practical examples of Terraform state manipulation, including commands to move, remove and import resources. These operations are essential for managing existing infrastructure and reorganizing projects.

## State Operations

### 1. Move Resources

Move resources between configurations or rename resources:

```bash
# Move resource to new name
terraform state mv aws_instance.old_name aws_instance.new_name

# Move resource to module
terraform state mv aws_instance.example module.vm.aws_instance.example

# Move resource between configurations
terraform state mv aws_s3_bucket.example aws_s3_bucket.new_example
```

### 2. Remove Resources

Remove resources from state without destroying them:

```bash
# Remove resource from state
terraform state rm aws_instance.example

# Remove multiple resources
terraform state rm aws_instance.example1 aws_instance.example2

# Remove resource from module
terraform state rm module.vm.aws_instance.example
```

### 3. Import Resources

Import existing resources into state:

```bash
# Import EC2 instance
terraform import aws_instance.example i-1234567890abcdef0

# Import S3 bucket
terraform import aws_s3_bucket.example my-existing-bucket

# Import VPC
terraform import aws_vpc.example vpc-12345678
```

## Practical Use Cases

### 1. Code Refactoring

```bash
# Rename resource
terraform state mv aws_instance.web_server aws_instance.app_server

# Move to module
terraform state mv aws_instance.example module.app.aws_instance.example
```

### 2. Project Migration

```bash
# Remove from old project
terraform state rm aws_s3_bucket.example

# Import to new project
terraform import aws_s3_bucket.example my-existing-bucket
```

### 3. State Cleanup

```bash
# Remove unused resources
terraform state rm aws_instance.old_instance
terraform state rm aws_security_group.old_sg
```

## Verification Commands

### List Resources

```bash
# List all resources
terraform state list

# List module resources
terraform state list module.vm

# Filter by type
terraform state list | grep aws_instance
```

### Show Resources

```bash
# Show specific resource
terraform state show aws_instance.example

# Show module resource
terraform state show module.vm.aws_instance.example
```

### Verify State

```bash
# Verify current state
terraform show

# Verify differences
terraform plan
```

## Practical Examples

### Example 1: Rename Resource

```bash
# 1. Check current resource
terraform state show aws_instance.web_server

# 2. Move to new name
terraform state mv aws_instance.web_server aws_instance.app_server

# 3. Verify change
terraform state show aws_instance.app_server

# 4. Validate configuration
terraform plan
```

### Example 2: Move to Module

```bash
# 1. Create module
mkdir modules/vm
# ... create module files ...

# 2. Move resource
terraform state mv aws_instance.example module.vm.aws_instance.example

# 3. Verify state
terraform state list module.vm

# 4. Apply changes
terraform apply
```

### Example 3: Import Existing Resource

```bash
# 1. Create basic configuration
resource "aws_instance" "existing" {
  # Configuration will be filled
}

# 2. Import resource
terraform import aws_instance.existing i-1234567890abcdef0

# 3. Generate configuration
terraform plan -generate-config-out=generated.tf

# 4. Validate
terraform validate
```

## Debug Commands

### Detailed Logs

```bash
# Enable logs
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Run command
terraform state mv aws_instance.old aws_instance.new
```

### State Verification

```bash
# Check state integrity
terraform state pull | jq .

# Check for orphaned resources
terraform plan -detailed-exitcode
```

## Tips and Best Practices

### 1. Backup State

```bash
# Always backup before manipulating
cp terraform.tfstate terraform.tfstate.backup
```

### 2. Continuous Validation

```bash
# Validate after each operation
terraform state mv aws_instance.old aws_instance.new
terraform validate
terraform plan
```

### 3. Gradual Operations

```bash
# Do one operation at a time
terraform state mv aws_instance.old aws_instance.new
terraform plan
terraform state rm aws_instance.unused
terraform plan
```

### 4. Documentation

```bash
# Document changes
echo "Moved aws_instance.old to aws_instance.new" >> CHANGELOG.md
```

## Important Considerations

### Risks

- **State Loss**: Incorrect operations can corrupt state
- **Orphaned Resources**: Resources may be left unmanaged
- **Dependencies**: Dependencies may be broken

### Mitigations

- **Backup**: Always backup state
- **Testing**: Test in development environment
- **Validation**: Validate after each operation
- **Monitoring**: Monitor resources after changes

## Recommended Workflow

### 1. Preparation

```bash
# Backup state
cp terraform.tfstate terraform.tfstate.backup

# Check current state
terraform state list
```

### 2. Operation

```bash
# Execute operation
terraform state mv aws_instance.old aws_instance.new
```

### 3. Validation

```bash
# Validate configuration
terraform validate

# Check differences
terraform plan
```

### 4. Application

```bash
# Apply if necessary
terraform apply
```

## References

- [Terraform State Commands](https://www.terraform.io/docs/cli/commands/state/index.html)
- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)
- [Terraform Import](https://www.terraform.io/docs/cli/commands/import.html)

---

**Complete guide for Terraform state manipulation**