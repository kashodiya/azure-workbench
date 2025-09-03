# azure-workbench

## Quick VM Lifecycle Management

### Create VM
```bash
cd terraform
terraform init
terraform apply
```

### Destroy VM
```bash
# Using script (recommended)
.\scripts\destroy-vm.bat
# or
.\scripts\destroy-vm.ps1

# Manual destroy
cd terraform
terraform destroy
```
