resource "azurerm_resource_group" "resource_group" {
  name     = "rg-terraform-console"
  location = var.location

  tags = local.common_tags
}
