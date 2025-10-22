check "nsg_rules" {
  data "azurerm_network_security_group" "rules" {
    name                = azurerm_network_security_group.nsg.name
    resource_group_name = azurerm_resource_group.resource_group.name
  }

  assert {
    condition     = sort([for rule in data.azurerm_network_security_group.rules.security_rule : rule.destination_port_range]) == sort(local.allowed_ports)
    error_message = "There are missing or extra security rules in the network security group"
  }
}