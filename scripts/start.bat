@echo off

echo ========================================
echo Azure Workbench Setup Script
echo ========================================

:: Navigate to terraform directory
cd /d "%~dp0\..\terraform"

:: Check if outputs.env exists
if not exist outputs.env (
    echo ERROR: outputs.env not found!
    echo Please run 'tf apply' first to generate outputs.env
    pause
    exit /b 1
)

:: Show and load outputs.env
echo Current environment variables:
type outputs.env
echo.
echo Loading environment variables...
for /f "tokens=1,2 delims==" %%a in (outputs.env) do set %%a=%%b

:: Create doskey shortcuts
echo Setting up command shortcuts...
doskey tf=terraform $*
doskey tfa=terraform apply
doskey tfaa=terraform apply -auto-approve
doskey tfp=terraform plan
doskey tfd=terraform destroy
doskey tfda=terraform destroy -auto-approve
doskey tfo=terraform output
doskey tft=terraform taint azurerm_linux_virtual_machine.main
doskey ssh=%SSH_COMMAND%
doskey env=type outputs.env
doskey deploy=call "%~dp0deploy-to-vm.bat" %ADMIN_USERNAME% %PUBLIC_IP%
doskey reload=call "%~dp0start.bat"
doskey start=az vm start --resource-group %RESOURCE_GROUP_NAME% --name %VM_NAME%
doskey restart=az vm restart --resource-group %RESOURCE_GROUP_NAME% --name %VM_NAME%
doskey shutdown=az vm deallocate --resource-group %RESOURCE_GROUP_NAME% --name %VM_NAME%
doskey forget=ssh-keygen -R %PUBLIC_IP%
doskey openhands=start https://%PUBLIC_IP%:5000
doskey portainer=start https://172.191.76.32:5003
doskey vscode=start https://172.191.76.32:5002/?folder=/home/azureuser

echo.
echo ========================================
echo Available shortcuts:
echo   tf      - terraform commands
echo   tfa     - terraform apply
echo   tfaa    - terraform apply -auto-approve
echo   tfp     - terraform plan
echo   tfd     - terraform destroy
echo   tfda    - terraform destroy -auto-approve
echo   tfo     - terraform output
echo   tft     - taint VM (mark for recreation)
echo   ssh     - connect to VM
echo   env     - show environment variables
echo   deploy  - deploy to VM (usage: deploy user host [path])
echo   reload  - reload this script
echo   start   - start the VM
echo   restart - restart the VM
echo   shutdown - shutdown/deallocate the VM
echo   forget  - forget SSH host key
echo   openhands - open OpenHands in browser
echo   portainer - open Portainer in browser
echo   vscode  - open VSCode in browser
echo ========================================