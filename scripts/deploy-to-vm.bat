@echo off
set ADMIN_USERNAME=%1
set PUBLIC_IP=%2

echo Admin Username: %ADMIN_USERNAME%
echo Public IP: %PUBLIC_IP%

echo Copying vm-setup folder to VM...
scp -i "..\terraform\private_key.pem" -r "..\vm-setup" "%ADMIN_USERNAME%@%PUBLIC_IP%:~/"

echo Running setup on VM...
ssh -i "..\terraform\private_key.pem" "%ADMIN_USERNAME%@%PUBLIC_IP%" "cd vm-setup && chmod +x main.sh && ./main.sh"