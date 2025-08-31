#!/bin/bash

echo "[OPEN-WEBUI] Setting up Open WebUI service..."

cd /home/azureuser/docker/open-webui

# Create .env file directly
echo "OPENHANDS_LITELLM_KEY=${OPENHANDS_LITELLM_KEY}" | sudo -u azureuser tee .env > /dev/null

echo "[OPEN-WEBUI] Starting Open WebUI service..."
if ! sudo -u azureuser docker-compose ps | grep -q "Up"; then
    sudo -u azureuser docker-compose up -d --quiet-pull
    echo "[OPEN-WEBUI] Service started"
else
    echo "[OPEN-WEBUI] Service already running"
fi

echo "[OPEN-WEBUI] Setup completed!"