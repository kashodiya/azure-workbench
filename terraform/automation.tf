# Automation Account for VM scheduling
resource "azurerm_automation_account" "main" {
  name                = "${var.project_name}-automation"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Runbook to stop VM
resource "azurerm_automation_runbook" "stop_vm" {
  name                    = "StopVM"
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = azurerm_automation_account.main.name
  log_verbose             = false
  log_progress            = false
  runbook_type            = "PowerShell"

  content = <<-EOT
param(
    [string]$ResourceGroupName,
    [string]$VMName
)

Connect-AzAccount -Identity
Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
EOT

  tags = var.tags
}

# Runbook to start VM
resource "azurerm_automation_runbook" "start_vm" {
  name                    = "StartVM"
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = azurerm_automation_account.main.name
  log_verbose             = false
  log_progress            = false
  runbook_type            = "PowerShell"

  content = <<-EOT
param(
    [string]$ResourceGroupName,
    [string]$VMName
)

Connect-AzAccount -Identity
Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName
EOT

  tags = var.tags
}

# Schedule to stop VM at 8 PM daily
resource "azurerm_automation_schedule" "stop_vm" {
  name                    = "StopVMSchedule"
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = azurerm_automation_account.main.name
  frequency               = "Day"
  interval                = 1
  start_time              = timeadd(timestamp(), "10m")
  timezone                = var.timezone
}

# Schedule to start VM at 6 AM daily
resource "azurerm_automation_schedule" "start_vm" {
  name                    = "StartVMSchedule"
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = azurerm_automation_account.main.name
  frequency               = "Day"
  interval                = 1
  start_time              = timeadd(timestamp(), "15m")
  timezone                = var.timezone
}

# Job schedule for stopping VM
resource "azurerm_automation_job_schedule" "stop_vm" {
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = azurerm_automation_account.main.name
  schedule_name           = azurerm_automation_schedule.stop_vm.name
  runbook_name            = azurerm_automation_runbook.stop_vm.name

  parameters = {
    resourcegroupname = data.azurerm_resource_group.main.name
    vmname           = azurerm_linux_virtual_machine.main.name
  }
}

# Job schedule for starting VM
resource "azurerm_automation_job_schedule" "start_vm" {
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = azurerm_automation_account.main.name
  schedule_name           = azurerm_automation_schedule.start_vm.name
  runbook_name            = azurerm_automation_runbook.start_vm.name

  parameters = {
    resourcegroupname = data.azurerm_resource_group.main.name
    vmname           = azurerm_linux_virtual_machine.main.name
  }
}

# Role assignment for automation account to manage VMs
resource "azurerm_role_assignment" "automation_vm_contributor" {
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_automation_account.main.identity[0].principal_id
}