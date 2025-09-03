#!/usr/bin/env pwsh

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Azure Workbench VM Destroy Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Change to terraform directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$terraformPath = Join-Path (Split-Path -Parent $scriptPath) "terraform"
Set-Location $terraformPath

Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

# Check if Terraform state exists
Write-Host "Checking Terraform state..." -ForegroundColor Yellow
try {
    $null = terraform show -no-color 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "No state found"
    }
} catch {
    Write-Host "No Terraform state found or Terraform not initialized." -ForegroundColor Red
    Write-Host "Run 'terraform init' and 'terraform apply' first." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "WARNING: This will destroy ALL Azure resources managed by Terraform!" -ForegroundColor Red
Write-Host "This includes:" -ForegroundColor Yellow
Write-Host "- Virtual Machine" -ForegroundColor Yellow
Write-Host "- Virtual Network" -ForegroundColor Yellow
Write-Host "- Public IP" -ForegroundColor Yellow
Write-Host "- Storage Account" -ForegroundColor Yellow
Write-Host "- Network Security Group" -ForegroundColor Yellow
Write-Host "- All associated resources" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Are you sure you want to destroy all resources? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Destroy cancelled." -ForegroundColor Green
    Read-Host "Press Enter to exit"
    exit 0
}

Write-Host ""
Write-Host "Starting Terraform destroy..." -ForegroundColor Yellow
terraform destroy -auto-approve

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "SUCCESS: All resources destroyed!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "ERROR: Destroy failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "Check the output above for details." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"