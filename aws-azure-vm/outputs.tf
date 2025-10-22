
output "azure_vm_public_ip" {
  value = azurerm_linux_virtual_machine.linux_vm.public_ip_address
}
output "aws_vm_public_ip" {
  value = aws_instance.vm.public_ip
}
