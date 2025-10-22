output "vm_ip" {
  description = "IP of the created VM"
  value       = azurerm_linux_virtual_machine.linux_vm.public_ip_address
}
