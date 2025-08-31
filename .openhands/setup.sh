#!/bin/bash

# Azure Workbench Setup Script
# This script installs Terraform and other required tools

set -e

echo "🚀 Setting up Azure Workbench environment..."

# Update package list
echo "📦 Updating package list..."
sudo apt-get update -y

# Install required packages
echo "📦 Installing required packages..."
sudo apt-get install -y \
    curl \
    wget \
    unzip \
    gnupg \
    software-properties-common

# Install Terraform
echo "🔧 Installing Terraform..."
TERRAFORM_VERSION="1.6.6"

# Download Terraform
wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Unzip and install
unzip -q "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
sudo mv terraform /usr/local/bin/
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Verify Terraform installation
echo "✅ Verifying Terraform installation..."
terraform version

# Install Azure CLI (optional but recommended)
echo "🔧 Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Verify Azure CLI installation
echo "✅ Verifying Azure CLI installation..."
az version

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Navigate to the terraform directory: cd terraform"
echo "2. Copy the example variables file: cp terraform.tfvars.example terraform.tfvars"
echo "3. Edit terraform.tfvars with your Azure credentials"
echo "4. Initialize Terraform: terraform init"
echo "5. Plan your deployment: terraform plan"
echo "6. Apply your configuration: terraform apply"
echo ""
echo "For more information, see the README.md file in the terraform directory."
