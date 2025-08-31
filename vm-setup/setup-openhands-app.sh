#!/bin/bash

echo "[OPENHANDS-APP] Setting up OpenHands application..."

cd /home/azureuser/docker/openhands

# Create .env file directly
echo "OPENHANDS_LITELLM_KEY=${OPENHANDS_LITELLM_KEY}" | sudo -u azureuser tee .env > /dev/null
echo "OPENHANDS_VSCODE_TOKEN=${OPENHANDS_VSCODE_TOKEN}" | sudo -u azureuser tee -a .env > /dev/null

# Substitute environment variables in settings template
sudo -u azureuser -E envsubst < .openhands/settings.json.template > .openhands/settings.json

echo "[OPENHANDS-APP] Checking runtime image..."
if ! docker images | grep -q "docker.all-hands.dev/all-hands-ai/runtime.*0.50-nikolaik"; then
    echo "[OPENHANDS-APP] Pulling runtime image..."
    docker pull -q docker.all-hands.dev/all-hands-ai/runtime:0.50-nikolaik
else
    echo "[OPENHANDS-APP] Runtime image already exists"
fi

echo "[OPENHANDS-APP] Starting OpenHands app..."
if ! sudo -u azureuser docker-compose ps | grep -q "Up"; then
    sudo -u azureuser docker-compose up -d --quiet-pull
    echo "[OPENHANDS-APP] Service started"
else
    echo "[OPENHANDS-APP] Service already running"
fi

echo "[OPENHANDS-APP] Setup completed!"