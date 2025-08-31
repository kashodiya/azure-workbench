
output "project_name" {
  description = "Name of the project used as prefix for resources"
  value       = var.project_name
}

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

# Create output file with all resource information for Windows batch scripts
resource "local_file" "output_env" {
  filename = "${path.module}/outputs.env"
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
}

# Create the private key file
resource "local_file" "private_key" {
  filename        = "${path.module}/private_key.pem"
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

