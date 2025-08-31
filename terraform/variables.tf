
variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
  default     = "your-resource-group-name"
}

# Note: Location will be retrieved from the existing resource group
# No need to specify location variable when using existing resource group

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Azure Workbench"
    ManagedBy   = "Terraform"
  }
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure service principal client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure service principal client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  sensitive   = true
}

