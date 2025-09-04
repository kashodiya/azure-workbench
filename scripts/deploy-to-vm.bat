@echo off
set ADMIN_USERNAME=%1
set PUBLIC_IP=%2

echo Admin Username: %ADMIN_USERNAME%
echo Public IP: %PUBLIC_IP%

@REM echo WARNING: This will overwrite all Docker and configuration files on the server!
@REM set /p confirm=Type Y to continue or any other key to exit: 
@REM if /i "%confirm%" neq "Y" if /i "%confirm%" neq "y" exit /b

echo Copying project files to VM (excluding temp folder)...
ssh -i "..\terraform\private_key.pem" "%ADMIN_USERNAME%@%PUBLIC_IP%" "mkdir -p azure-workbench"
scp -i "..\terraform\private_key.pem" -r "..\docker" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/azure-workbench/"
scp -i "..\terraform\private_key.pem" -r "..\caddy" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/azure-workbench/"
ssh -i "..\terraform\private_key.pem" "%ADMIN_USERNAME%@%PUBLIC_IP%" "mkdir -p azure-workbench/terraform"
scp -i "..\terraform\private_key.pem" "..\terraform\*.tf" "..\terraform\*.tfvars" "..\terraform\outputs.env" "..\terraform\private_key.pem" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/azure-workbench/terraform/" 2>nul || echo Skipping missing terraform files
scp -i "..\terraform\private_key.pem" -r "..\scripts" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/azure-workbench/"
scp -i "..\terraform\private_key.pem" -r "..\vm-setup" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/azure-workbench/"
scp -i "..\terraform\private_key.pem" "..\README.md" "..\.gitignore" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/azure-workbench/"

echo Running setup on VM...
echo This may take several minutes. Press Ctrl+C to cancel if it hangs.
ssh -i "..\terraform\private_key.pem" -o ConnectTimeout=30 -o ServerAliveInterval=60 "%ADMIN_USERNAME%@%PUBLIC_IP%" "cd azure-workbench/vm-setup && chmod +x *.sh && timeout 1800 ./main.sh || echo 'Setup timed out after 30 minutes'"