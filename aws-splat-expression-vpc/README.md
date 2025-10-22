# Terraform Splat Expression - AWS VPC

> **Testing Splat Expression with multiple subnets**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

## What is Splat Expression?

Splat expression (`[*]`) is a Terraform syntax to extract attributes from multiple resources created with `count` or `for_each`.

## This Example

We create **3 subnets** using `count = 3` and use splat expression to get all IDs:

```hcl
# Creates 3 subnets
resource "aws_subnet" "subnet" {
  count = 3
  
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  
  tags = {
    Name = "sn-terraform-${count.index}"
  }
}

# Uses splat to get all IDs
output "subnets_ids" {
  value = aws_subnet.subnet[*].id
}
```

## Resources Created

- 1 VPC (10.0.0.0/16)
- 3 Subnets:
  - 10.0.0.0/24
  - 10.0.1.0/24
  - 10.0.2.0/24

## How to Use

```bash
terraform init
terraform apply

# View subnet IDs
terraform output subnets_ids
```

### Output Result

```hcl
subnets_ids = [
  "subnet-abc123",
  "subnet-def456",
  "subnet-ghi789"
]
```

## Splat vs Index

```hcl
# ❌ Without splat - gets only one
aws_subnet.subnet[0].id  # "subnet-abc123"

# ✅ With splat - gets all
aws_subnet.subnet[*].id  # ["subnet-abc123", "subnet-def456", "subnet-ghi789"]
```

## When to Use?

Use splat expression when you need to:
- Get attributes from multiple resources
- Work with resources created via `count`
- Pass a list of IDs to other resources

---

**Testing splat expressions in Terraform**