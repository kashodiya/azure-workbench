# Output the public IP address of the VM
output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

# Output the SSH connection command
output "ssh_connection_command" {
  value = "ssh -i private_key.pem ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

# Output your current IP that has access
output "your_current_ip" {
  value = local.my_ip
  description = "Your current public IP address that has access to the VM"
}

# Save SSH private key to file
resource "local_file" "private_key" {
  content  = tls_private_key.ssh.private_key_pem
  filename = "private_key.pem"
  file_permission = "0600"
}

# Generate outputs.env file
resource "local_file" "outputs_env" {
  content = <<-EOT
PROJECT_NAME=${var.project_name}
RESOURCE_GROUP_NAME=${data.azurerm_resource_group.main.name}
RESOURCE_GROUP_LOCATION=${data.azurerm_resource_group.main.location}
RESOURCE_GROUP_ID=${data.azurerm_resource_group.main.id}
VM_NAME=${azurerm_linux_virtual_machine.main.name}
VM_ID=${azurerm_linux_virtual_machine.main.id}
PUBLIC_IP=${azurerm_public_ip.main.ip_address}
ADMIN_USERNAME=${var.admin_username}
VNET_ID=${azurerm_virtual_network.main.id}
SUBNET_ID=${azurerm_subnet.internal.id}
NSG_ID=${azurerm_network_security_group.main.id}
NIC_ID=${azurerm_network_interface.main.id}
SSH_COMMAND=ssh -i private_key.pem ${var.admin_username}@${azurerm_public_ip.main.ip_address}
EOT
  filename = "outputs.env"
}