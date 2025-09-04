#!/bin/bash

echo "[AZ-CLI] Starting Azure CLI installation..."

# if command -v az &> /dev/null; then
#     echo "[AZ-CLI] Azure CLI already installed"
#     exit 0
# fi

echo "[AZ-CLI] Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

if command -v az &> /dev/null; then
    echo "[AZ-CLI] Azure CLI installed successfully"
    echo "[AZ-CLI] Logging in with managed identity..."
    az login --identity
    
    # Get subscription ID from Terraform outputs
    if [ -f "/home/azureuser/azure-workbench/terraform/outputs.env" ]; then
        SUBSCRIPTION_ID=$(grep "^SUBSCRIPTION_ID=" /home/azureuser/azure-workbench/terraform/outputs.env | cut -d'=' -f2)
        if [ -n "$SUBSCRIPTION_ID" ]; then
            echo "[AZ-CLI] Setting subscription: $SUBSCRIPTION_ID"
            az account set --subscription "$SUBSCRIPTION_ID"
        else
            echo "[AZ-CLI] Warning: Could not find subscription ID in outputs.env"
        fi
    else
        echo "[AZ-CLI] Warning: outputs.env file not found, using default subscription"
    fi
else
    echo "[AZ-CLI] Azure CLI installation failed"
    exit 1
fi