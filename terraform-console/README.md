# Terraform Console - Testing Functions

> **Testing Terraform Console and built-in functions**

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)

## What is Terraform Console?

`terraform console` is an interactive command-line tool that lets you evaluate Terraform expressions and test built-in functions. Perfect for debugging and learning!

## This Project

A simple Azure Resource Group project used to demonstrate different ways to use `terraform console`:
- With initialized project (access to variables, locals, resources)
- Without initialization (error demonstration)
- In empty folder (only built-in functions)

## Three Ways to Use Console

### 1️⃣ In Initialized Project (Full Access)

```bash
# Initialize first
terraform init

# Open console
terraform console
```

**What you can access:**
- ✅ Variables: `var.location`
- ✅ Locals: `local.common_tags`
- ✅ Resources: `azurerm_resource_group.resource_group` (if applied)
- ✅ Built-in functions: `upper()`, `lower()`, `join()`, etc.

**Example commands:**
```hcl
> var.location
"brazilsouth"

> local.common_tags
{
  "Owner" = "Deleon"
  "Project" = "Estudos Terraform"
  "environment" = "Development"
  "location" = "brazilsouth"
  "managed-by" = "terraform"
}

> upper(var.location)
"BRAZILSOUTH"

> keys(local.common_tags)
["Owner", "Project", "environment", "location", "managed-by"]
```

### 2️⃣ Without Init (Error)

```bash
# Try to open console without init
terraform console
```

**Result:**
```
Error: Terraform has not been initialized
```

❌ **You must run `terraform init` first!**

### 3️⃣ In Empty Folder (Functions Only)

```bash
# Create empty directory
mkdir /tmp/test-console
cd /tmp/test-console

# Open console
terraform console
```

**What you can access:**
- ✅ Built-in functions only
- ❌ No variables
- ❌ No locals
- ❌ No resources

**Example commands:**
```hcl
> upper("hello world")
"HELLO WORLD"

> join(", ", ["a", "b", "c"])
"a, b, c"

> length([1, 2, 3, 4, 5])
5

> max(5, 12, 9)
12
```

## State Locking Behavior

### 🔒 Console Locks State

When you open console in an initialized project, **Terraform locks the state file**:

**Terminal 1:**
```bash
terraform console
> # Console is open, state is locked
```

**Terminal 2 (Another terminal):**
```bash
terraform plan
# ❌ Error: Error acquiring the state lock
# State locked by: terraform console (PID: xxxxx)
```

### Why?

- Console reads the state file
- Prevents concurrent modifications
- Must exit console to release lock

**To release the lock:**
```bash
> exit  # or Ctrl+D
```

## Useful Functions to Test

### String Functions

```hcl
> upper("terraform")
"TERRAFORM"

> lower("TERRAFORM")
"terraform"

> title("hello world")
"Hello World"

> replace("hello world", "world", "terraform")
"hello terraform"

> substr("terraform", 0, 5)
"terra"

> format("Hello, %s!", "World")
"Hello, World!"
```

### Collection Functions

```hcl
> length(["a", "b", "c"])
3

> concat(["a", "b"], ["c", "d"])
["a", "b", "c", "d"]

> contains(["a", "b", "c"], "b")
true

> merge({a = 1}, {b = 2})
{
  "a" = 1
  "b" = 2
}

> keys({name = "test", env = "dev"})
["env", "name"]

> values({name = "test", env = "dev"})
["dev", "test"]
```

### Numeric Functions

```hcl
> max(5, 12, 9)
12

> min(5, 12, 9)
5

> ceil(5.1)
6

> floor(5.9)
5
```

### Type Conversion Functions

```hcl
> tostring(42)
"42"

> tonumber("42")
42

> tolist(["a", "b"])
["a", "b"]

> tomap({key = "value"})
{
  "key" = "value"
}
```

### Encoding Functions

```hcl
> base64encode("Hello World")
"SGVsbG8gV29ybGQ="

> base64decode("SGVsbG8gV29ybGQ=")
"Hello World"

> jsondecode("{\"name\": \"test\"}")
{
  "name" = "test"
}

> jsonencode({name = "test"})
"{\"name\":\"test\"}"
```

## Project Resources

This simple project creates:
- 1 Azure Resource Group

**Files:**
```
terraform-console/
├── main.tf              # Provider configuration
├── resource_group.tf    # Resource Group
├── variables.tf         # Variables
├── locals.tf            # Local values
├── outputs.tf           # Outputs
└── README.md            # This file
```

## Quick Start

```bash
# Initialize
terraform init

# Open console
terraform console

# Test some functions
> upper(var.location)
> local.common_tags
> keys(local.common_tags)

# Exit console
> exit
```

## Console Commands

```bash
terraform console      # Open interactive console
terraform console -h   # Help
exit                   # Exit console (or Ctrl+D)
```

## Tips

- Use **Tab** for auto-completion
- Use **Ctrl+D** to exit
- Use **Ctrl+C** to cancel current expression
- Multi-line expressions are supported
- No changes are applied (read-only)

## Common Use Cases

1. **Test expressions** before using in code
2. **Debug complex functions** interactively
3. **Learn Terraform functions** hands-on
4. **Validate data transformations** before apply
5. **Query state values** after resources are created

---

**Testing and learning Terraform interactively**
