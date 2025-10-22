# Multi-Cloud VM Deployment with Terraform

This project automates the provisioning of virtual machines across AWS and Azure using Terraform and GitLab CI/CD pipelines.

## 📋 Overview

This Terraform configuration creates and manages:

### AWS Resources
- **EC2 Instance**: t3.micro instance running Amazon Linux 2
- **SSH Key Pair**: For secure access to the EC2 instance
- **Network Configuration**: Uses existing VPC and security group from remote state

### Azure Resources
- **Resource Group**: Container for all Azure resources
- **Linux Virtual Machine**: Standard_B1s VM running Ubuntu 18.04 LTS
- **Public IP**: Static public IP address
- **Network Interface**: With dynamic private IP allocation
- **Security Group Association**: Links VM to existing network security group
- **SSH Key**: For secure access to the Azure VM

## 🏗️ Architecture

The project uses remote state to reference existing network infrastructure:
- **AWS**: References VPC and security group from `aws-vpc/terraform.tfstate`
- **Azure**: References VNet and NSG from `azure-vnet/terraform.tfstate`

### State Management
- **AWS State**: Stored in S3 bucket `deleon-bucket-aws-remote-state`
- **Azure State**: Stored in Azure Storage Account `deleonterraform`

## 🔧 Prerequisites

### Required Software
- Terraform >= 1.3.0
- GitLab account with CI/CD enabled

### Required Infrastructure
- **AWS VPC** with subnet and security group already created
- **Azure VNet** with subnet and network security group already created
- **S3 Bucket** for Terraform state storage
- **Azure Storage Account** for remote state

### Required Secrets (GitLab CI/CD Variables)
Set the following environment variables in your GitLab project:

| Variable | Description |
|----------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `ARM_CLIENT_ID` | Azure service principal client ID |
| `ARM_CLIENT_SECRET` | Azure service principal secret |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure tenant ID |
| `TF_VAR_aws_key_pub` | AWS SSH public key content |
| `TF_VAR_azure_key_pub` | Azure SSH public key content |

## 🚀 Pipeline Stages

The GitLab CI/CD pipeline consists of three stages:

### 1. **Validate** (Automatic)
- Initializes Terraform
- Validates Terraform configuration syntax
- Runs on every commit

### 2. **Plan & Apply** (Automatic)
- Creates an execution plan
- Applies the changes automatically
- Provisions VMs in both AWS and Azure
- Runs after successful validation

### 3. **Destroy** (Manual)
- Destroys all created infrastructure
- Must be triggered manually from GitLab UI
- Use with caution in production environments

## 📝 Usage

### Initial Setup

1. **Fork/Clone this repository**

2. **Configure GitLab CI/CD Variables**
   - Go to Settings > CI/CD > Variables
   - Add all required variables listed above

3. **Generate SSH Keys** (if you don't have them)
   ```bash
   # For AWS
   ssh-keygen -t rsa -b 4096 -f aws-key -N ""
   
   # For Azure
   ssh-keygen -t rsa -b 4096 -f azure-key -N ""
   ```

4. **Update Remote State Configuration** (if needed)
   - Edit `main.tf` to match your S3 bucket and Azure storage account

### Deploy Infrastructure

1. **Push to GitLab**
   ```bash
   git add .
   git commit -m "Deploy VMs"
   git push
   ```

2. **Monitor Pipeline**
   - Navigate to CI/CD > Pipelines
   - Watch the pipeline progress through validate and plan_apply stages

3. **Access VMs**
   - After successful deployment, use the output values to connect:
   ```bash
   # Connect to AWS VM
   ssh -i aws-key ec2-user@<aws_public_ip>
   
   # Connect to Azure VM
   ssh -i azure-key terraform@<azure_public_ip>
   ```

### Destroy Infrastructure

1. Go to CI/CD > Pipelines
2. Click on the latest pipeline
3. Find the "destroy" job
4. Click the play button (▶️) to manually trigger destruction

## 📦 Project Structure

```
aws-azure-vm/
├── .gitlab-ci.yml          # CI/CD pipeline configuration
├── main.tf                 # Provider and backend configuration
├── variables.tf            # Input variables
├── aws-vm.tf              # AWS EC2 instance configuration
├── azure-vm.tf            # Azure VM configuration
├── outputs.tf             # Output values
├── locals.tf              # Local values
├── aws-key.pub            # AWS SSH public key
└── azure-key.pub          # Azure SSH public key
```

## 🔐 Security Considerations

- SSH keys should be stored securely as GitLab CI/CD variables
- Never commit private keys to version control
- Use appropriate security groups/NSGs to restrict access
- Consider using bastion hosts for production environments
- Rotate credentials regularly

## 🌍 Regions

- **AWS**: Default region is `sa-east-1` (São Paulo)
- **Azure**: Default region is `brazilsouth` (Brazil South)

You can override these by setting `TF_VAR_aws_region` and `TF_VAR_azure_region` variables.

## 📊 Outputs

After successful deployment, the following outputs are available:
- AWS EC2 instance ID and public IP
- Azure VM ID and public IP
- Network interface details

## 🐛 Troubleshooting

### Pipeline Fails on Init
- Verify AWS and Azure credentials are correctly set
- Check S3 bucket and Azure storage account exist and are accessible

### Pipeline Fails on Apply
- Ensure remote state VPC/VNet resources exist
- Verify subnet and security group IDs are valid
- Check quota limits in both cloud providers

### Cannot Connect to VMs
- Verify security groups allow SSH (port 22) from your IP
- Ensure you're using the correct private key
- Check public IP addresses in outputs

## 📄 License

This project is provided as-is for educational and demonstration purposes.

## 👤 Author

Deleon

---

**Note**: Always review the execution plan before applying changes in production environments.

