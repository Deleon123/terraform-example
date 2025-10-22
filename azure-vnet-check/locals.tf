locals {
  common_tags = {
    Owner       = "Deleon"
    Project     = "Estudos Terraform"
    managed-by  = "terraform"
    environment = "Development"
  }

  allowed_ports     = ["80", "443", "3306"]
  allowed_protocols = ["Tcp"]
}