resource "azurerm_resource_group" "resource_group" {
  name     = "rg-vm-${var.environment}"
  location = var.location

  tags = local.common_tags
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-${var.environment}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = "nic-${var.environment}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  ip_configuration {
    name                          = "public-ip-configuration"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "nisga" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.azure_nsg.id
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  depends_on            = [azurerm_network_interface_security_group_association.nisga]
  name                  = "vm-${var.environment}"
  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "terraform"
  network_interface_ids = [azurerm_network_interface.network_interface.id]

  admin_ssh_key {
    username   = "terraform"
    public_key = file("./azure-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.common_tags
}