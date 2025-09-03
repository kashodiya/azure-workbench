variable "project_name" {
  description = "Name of the project - used as prefix for all resources"
  type        = string
  default     = "azure-workbench"
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
  default     = "your-resource-group-name"
}

# Note: Location will be retrieved from the existing resource group
# No need to specify location variable when using existing resource group

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Azure Workbench"
    ManagedBy   = "Terraform"
  }
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the VM"
  type        = list(string)
  default     = []
}

variable "azure_api_key" {
  description = "Azure OpenAI API key"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for Caddy authentication"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "timezone" {
  description = "Timezone for VM scheduling (e.g., 'UTC', 'America/New_York')"
  type        = string
  default     = "UTC"
}

