resource "azurerm_network_security_group" "azure_nsg" {
  name                = "nsg-${var.environment}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "azure_nsg_subnet_association" {
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
  subnet_id                 = module.network.vnet_subnets[0]
}