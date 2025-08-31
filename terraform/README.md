


# Terraform Configuration for Azure Workbench

This directory contains Terraform configuration files to manage Azure infrastructure for the Azure Workbench project.

## Prerequisites

1. **Install Terraform**: Download and install Terraform from [terraform.io](https://www.terraform.io/downloads.html)
2. **Azure CLI**: Install Azure CLI from [docs.microsoft.com](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. **Azure Service Principal**: You need a service principal with appropriate permissions
4. **Existing Resource Group**: This configuration assumes you have an existing Azure Resource Group. It will not create a new one but will use the existing one specified in the configuration.

## Setup

### 1. Configure Azure Credentials

Copy the example variables file and fill in your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your Azure credentials:

```hcl
# Project configuration
project_name = "azure-workbench"

# Azure Subscription ID
subscription_id = "your-subscription-id-here"

# Azure Service Principal credentials
client_id     = "your-client-id-here"
client_secret = "your-client-secret-here"
tenant_id     = "your-tenant-id-here"

# Resource configuration
resource_group_name = "azure-workbench-rg"
vm_name            = "vm"
vm_size            = "Standard_B2s"
admin_username     = "azureuser"
```

### 2. Alternative: Environment Variables

Instead of using `terraform.tfvars`, you can set environment variables:

```bash
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
```

## Usage

### Initialize Terraform

```bash
terraform init
```

### Plan the deployment

```bash
terraform plan
```

### Apply the configuration

```bash
terraform apply
```

### Destroy resources (when needed)

```bash
terraform destroy
```

## Files Description

- `main.tf` - Main Terraform configuration with provider and resource definitions
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output value definitions
- `terraform.tfvars.example` - Example variables file (safe to commit)
- `terraform.tfvars` - Actual variables file (DO NOT commit - contains sensitive data)
- `.gitignore` - Git ignore rules for Terraform files

## Security Notes

- **Never commit `terraform.tfvars`** - it contains sensitive credentials
- The `.gitignore` file is configured to exclude sensitive files
- Consider using Azure Key Vault for production deployments
- Use least-privilege principle for service principal permissions

## Current Resources

This configuration currently creates:

- **Virtual Network**: `{project_name}-vnet` with address space 10.0.0.0/16
- **Subnet**: `{project_name}-subnet` with address prefix 10.0.2.0/24
- **Public IP**: `{project_name}-public-ip` with static allocation
- **Network Security Group**: `{project_name}-nsg` with SSH, HTTP, and HTTPS rules
- **Network Interface**: `{project_name}-nic` connecting VM to subnet and public IP
- **Storage Account**: `{project_name}diag{random_id}` for boot diagnostics (lowercase, no dashes)
- **Linux Virtual Machine**: `{project_name}-{vm_name}` running Ubuntu 22.04 LTS
- **SSH Key Pair**: Auto-generated RSA 4096-bit key for secure access
- Basic tagging structure for resource management

All resources use the `project_name` variable as a prefix, making it easy to identify and manage related resources.

## Configuration Variables

### Key Variables

- **`project_name`**: Used as a prefix for all Azure resources (default: "azure-workbench")
- **`resource_group_name`**: Name of the existing Azure Resource Group to use
- **`vm_name`**: Name suffix for the virtual machine (default: "vm")
- **`vm_size`**: Azure VM size (default: "Standard_B2s")
- **`admin_username`**: Admin username for the VM (default: "azureuser")

### Resource Naming Convention

Resources are named using the pattern: `{project_name}-{resource_type}`

Examples with `project_name = "my-project"`:
- Virtual Network: `my-project-vnet`
- Virtual Machine: `my-project-vm`
- Public IP: `my-project-public-ip`
- Network Security Group: `my-project-nsg`
- Storage Account: `myprojectdiag{random_id}` (special case for storage naming requirements)

## Extending the Configuration

To add more Azure resources, create additional `.tf` files in this directory. Common patterns:

- `network.tf` - Virtual networks, subnets, security groups
- `compute.tf` - Virtual machines, scale sets
- `storage.tf` - Storage accounts, containers
- `database.tf` - Database services


