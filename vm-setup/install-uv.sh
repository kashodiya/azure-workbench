#!/bin/bash

echo "[UV] Checking if uv Python package manager is installed..."

# Check if uv is already installed
if sudo -u azureuser bash -c 'source /home/azureuser/.bashrc 2>/dev/null && command -v uv' &> /dev/null; then
    echo "[UV] uv already installed, skipping installation"
    echo "[UV] Current version: $(sudo -u azureuser bash -c 'source /home/azureuser/.bashrc && uv --version')"
else
    echo "[UV] Installing uv Python package manager for azureuser..."
    
    # Switch to azureuser and install uv
    sudo -u azureuser bash -c '
        cd /home/azureuser
        curl -LsSf https://astral.sh/uv/install.sh | sh
        if ! grep -q "export PATH=.*\.cargo/bin" /home/azureuser/.bashrc; then
            echo "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" >> /home/azureuser/.bashrc
        fi
    '
    
    echo "[UV] Installation completed."
fi

echo "[UV] Testing uv installation..."
sudo -u azureuser bash -c 'source /home/azureuser/.bashrc && uv --version' || echo "uv not found in PATH"