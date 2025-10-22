resource "azurerm_resource_group" "resource_group" {
  name     = "rg-block-check"
  location = var.location

  tags = local.common_tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = local.common_tags
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = toset(local.allowed_ports)

  name                       = "Allow-Port-${each.value}"
  priority                   = index(local.allowed_ports, each.key) + 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = each.value
  source_address_prefix      = "*"
  destination_address_prefix = "*"

  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.resource_group.name
}