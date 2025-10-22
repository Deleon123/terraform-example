# Terraform Dynamic Block - AWS Security Group

> **Testing Dynamic Blocks with multiple security group rules**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)

## What is Dynamic Block?

Dynamic blocks allow you to dynamically generate nested blocks (like `ingress` or `egress`) based on a collection (list, map, or set). This avoids repeating the same block multiple times.

## This Example

We create a security group with **7 ingress rules** using a single `dynamic` block that iterates over a variable:

### Variable Definition (variables.tf)

```hcl
variable "ports" {
  description = "Ports to be opened in the security group"
  type = map(object({
    description = string
    cidr_blocks = list(string)
    protocol    = string
  }))
  default = {
    22   = { description = "ssh port 22", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
    80   = { description = "web server port 80", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
    443  = { description = "web server port 443", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
    3306 = { description = "mysql port 3306", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
    5432 = { description = "postgresql port 5432", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
    6379 = { description = "redis port 6379", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
    8080 = { description = "php port 8080", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"], protocol = "tcp" }
  }
}
```

### Dynamic Block Usage (network.tf)

```hcl
resource "aws_security_group" "security_group" {
  name        = "security-group-terraform"
  description = "Allow access to multiple ports"
  vpc_id      = aws_vpc.vpc.id

  # Dynamic block iterates over the ports variable
  dynamic "ingress" {
    for_each = var.ports
    content {
      description      = ingress.value.description
      from_port        = ingress.key
      to_port          = ingress.key
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## Resources Created

- 1 VPC (10.0.0.0/16)
- 1 Subnet (10.0.1.0/24)
- 1 Internet Gateway
- 1 Route Table
- 1 Security Group with **7 dynamic ingress rules**

## Security Group Rules Created

| Port | Service    | Protocol | CIDR Blocks                      |
|------|------------|----------|----------------------------------|
| 22   | SSH        | TCP      | 10.0.1.0/24, 10.0.2.0/24        |
| 80   | HTTP       | TCP      | 10.0.1.0/24, 10.0.2.0/24        |
| 443  | HTTPS      | TCP      | 10.0.1.0/24, 10.0.2.0/24        |
| 3306 | MySQL      | TCP      | 10.0.1.0/24, 10.0.2.0/24        |
| 5432 | PostgreSQL | TCP      | 10.0.1.0/24, 10.0.2.0/24        |
| 6379 | Redis      | TCP      | 10.0.1.0/24, 10.0.2.0/24        |
| 8080 | PHP/App    | TCP      | 10.0.1.0/24, 10.0.2.0/24        |

## How to Use

```bash
terraform init
terraform apply
```

## Static vs Dynamic Blocks

### ❌ Without Dynamic Block (Repetitive)

```hcl
resource "aws_security_group" "sg" {
  name = "my-sg"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  # ... repeat for each port
}
```

### ✅ With Dynamic Block (Clean)

```hcl
resource "aws_security_group" "sg" {
  name = "my-sg"
  
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

## Dynamic Block Syntax

```hcl
dynamic "BLOCK_NAME" {
  for_each = COLLECTION
  content {
    # Use BLOCK_NAME.key and BLOCK_NAME.value
    # to access the current item
  }
}
```

## When to Use?

Use dynamic blocks when you need to:
- Generate multiple nested blocks from a collection
- Avoid repetitive code
- Make configurations more maintainable
- Conditionally create blocks based on variables

## Key Points

- **Iterator**: By default, uses the block name (e.g., `ingress`)
- **Access key**: `ingress.key` (for maps, the key; for lists, the index)
- **Access value**: `ingress.value` (the current item)
- **for_each**: Can iterate over maps, lists, or sets

---

**Testing dynamic blocks in Terraform**