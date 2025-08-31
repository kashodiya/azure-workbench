

output "resource_group_name" {
  description = "Name of the existing resource group"
  value       = data.azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the existing resource group"
  value       = data.azurerm_resource_group.main.location
}

output "resource_group_id" {
  description = "ID of the existing resource group"
  value       = data.azurerm_resource_group.main.id
}


output "public_ip_address" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.main.ip_address
}

output "ssh_private_key" {
  description = "Private SSH key for connecting to the VM"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh -i private_key.pem ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

