# AWS VM with Provisioners

> **AWS EC2 instance with provisioners for post-creation automation**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to use **provisioners** in Terraform to automate tasks after creating an EC2 instance in AWS. Provisioners allow you to execute scripts, transfer files, and configure the instance automatically.

## Resources Created

- **Key Pair**: SSH key pair for instance access
- **EC2 Instance**: Ubuntu instance with provisioners
- **Remote State Connection**: Connection to external network resources

## File Structure

```
aws-vm-provisioners/
├── main.tf              # Main configuration and remote data
├── vm.tf                # Instance definition with provisioners
├── output.tf            # Project outputs
├── teste.txt            # File for transfer
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

## Implemented Provisioners

### 1. Local Exec Provisioner

```hcl
provisioner "local-exec" {
  command = "echo ${self.public_ip} > public_ip.txt"
}
```

**Function**: Saves the instance's public IP to a local file after creation.

### 2. Remote Exec Provisioner

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx",
    "sudo systemctl start nginx",
    "sudo systemctl enable nginx"
  ]
}
```

**Function**: Executes commands on the instance to install and configure Nginx.

### 3. File Provisioner

```hcl
provisioner "file" {
  source      = "teste.txt"
  destination = "/tmp/teste.txt"
}
```

**Function**: Transfers the `teste.txt` file to `/tmp/teste.txt` on the instance.

## SSH Connection

```hcl
connection {
  type        = "ssh"
  host        = self.public_ip
  user        = "ubuntu"
  private_key = file("./aws-key")
}
```

**Configuration**: Defines how to connect to the instance to execute remote provisioners.

## Instance Specifications

- **AMI**: Ubuntu Server 20.04 LTS (ami-035efd31ab8835d8a)
- **Type**: t3.micro (1 vCPU, 1 GB RAM)
- **Access**: SSH via public key
- **Public IP**: Automatically associated
- **Region**: sa-east-1 (São Paulo)

## Provisioner Execution Order

1. **Local Exec**: Saves public IP locally
2. **Remote Exec**: Installs and configures Nginx
3. **File**: Transfers teste.txt file

## Provisioner Verification

After creation, connect to the instance and verify the results:

```bash
# Connect to instance
ssh -i aws-key ubuntu@<public-ip>

# Check if Nginx was installed
sudo systemctl status nginx

# Check transferred file
cat /tmp/teste.txt

# Test Nginx
curl http://localhost
```

## Concepts Demonstrated

- **Provisioners**: Post-creation resource automation
- **Local Exec**: Local environment command execution
- **Remote Exec**: Command execution on created instance
- **File Provisioner**: File transfer
- **Connection**: SSH connection configuration
- **Self References**: References to the resource itself

## Remote Backend

This project is configured to use a remote backend in S3:

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "aws-vm-provisioners/terraform.tfstate"
  region = "sa-east-1"
}
```

## Important Considerations

### Provisioners are a Last Resort
- Use provisioners only when there's no alternative
- Prefer user data, custom data or configuration tools
- Provisioners can fail and leave resources in inconsistent state

### Error Handling
```hcl
provisioner "remote-exec" {
  on_failure = continue  # Continue even if it fails
  inline = [...]
}
```

### Recommended Alternatives
- **User Data**: For initial configuration
- **Ansible/Chef**: For continuous configuration
- **CloudFormation**: For native AWS configuration
- **Packer**: For creating custom AMIs

## Next Steps

- Implement user data instead of provisioners
- Use tools like Ansible for configuration
- Implement health checks
- Configure automatic monitoring
- Add more robust initialization scripts

---

**Practical example of automation with provisioners**