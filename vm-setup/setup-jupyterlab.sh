#!/bin/bash

echo "[JUPYTERLAB] Setting up JupyterLab..."

# Install Python3 and pip if not already installed
echo "[JUPYTERLAB] Checking Python3 and pip installation..."
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null; then
    echo "[JUPYTERLAB] Installing Python3 and pip..."
    sudo apt install -y python3 python3-pip
else
    echo "[JUPYTERLAB] Python3 and pip already installed"
fi

# Create jupyter directory
echo "[JUPYTERLAB] Creating jupyter directory..."
if [ ! -d "/home/azureuser/jupyter" ]; then
    sudo -u azureuser mkdir -p /home/azureuser/jupyter
    echo "[JUPYTERLAB] Created jupyter directory"
else
    echo "[JUPYTERLAB] Jupyter directory already exists"
fi

# Install JupyterLab using pip as azureuser
echo "[JUPYTERLAB] Checking JupyterLab installation..."
if ! sudo -u azureuser bash -c 'command -v jupyter-lab' &> /dev/null; then
    echo "[JUPYTERLAB] Installing JupyterLab with pip..."
    sudo -u azureuser bash -c 'cd /home/azureuser/jupyter && pip3 install --user --quiet jupyterlab'
else
    echo "[JUPYTERLAB] JupyterLab already installed"
fi

# Create JupyterLab configuration
echo "[JUPYTERLAB] Creating JupyterLab configuration..."
sudo -u azureuser mkdir -p /home/azureuser/.jupyter
if [ ! -f "/home/azureuser/.jupyter/jupyter_lab_config.py" ]; then
    sudo -u azureuser cat > /home/azureuser/.jupyter/jupyter_lab_config.py << 'EOF'
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 3006
c.ServerApp.open_browser = False
c.ServerApp.allow_root = False
c.ServerApp.token = ''
c.ServerApp.password = ''
c.ServerApp.disable_check_xsrf = True
EOF
    echo "[JUPYTERLAB] Created JupyterLab configuration"
else
    echo "[JUPYTERLAB] JupyterLab configuration already exists"
fi

# Create systemd service
echo "[JUPYTERLAB] Creating systemd service..."
if [ ! -f "/etc/systemd/system/jupyterlab.service" ]; then
    sudo cat > /etc/systemd/system/jupyterlab.service << 'EOF'
[Unit]
Description=JupyterLab
After=network.target

[Service]
Type=simple
User=azureuser
WorkingDirectory=/home/azureuser/jupyter
Environment=PATH=/home/azureuser/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/home/azureuser/.local/bin/jupyter lab
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    echo "[JUPYTERLAB] Created systemd service file"
else
    echo "[JUPYTERLAB] Systemd service file already exists"
fi

# Enable and start service
echo "[JUPYTERLAB] Enabling and starting JupyterLab service..."
sudo systemctl daemon-reload
if ! sudo systemctl is-enabled jupyterlab &>/dev/null; then
    sudo systemctl enable jupyterlab
    echo "[JUPYTERLAB] Enabled JupyterLab service"
fi
if ! sudo systemctl is-active jupyterlab &>/dev/null; then
    sudo systemctl start jupyterlab
    echo "[JUPYTERLAB] Started JupyterLab service"
fi

echo "[JUPYTERLAB] JupyterLab setup completed."
echo "[JUPYTERLAB] Service status: $(sudo systemctl is-active jupyterlab)"