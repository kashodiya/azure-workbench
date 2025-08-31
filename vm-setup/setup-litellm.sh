#!/bin/bash

echo "[LITELLM] Setting up LiteLLM service..."

cd /home/azureuser/docker/litellm

# Create .env file with the LiteLLM key
echo "[LITELLM] Creating environment file..."
echo "OPENHANDS_LITELLM_KEY=${OPENHANDS_LITELLM_KEY}" | sudo -u azureuser tee .env > /dev/null

echo "[LITELLM] Starting LiteLLM service..."
if ! sudo -u azureuser docker-compose ps | grep -q "Up"; then
    sudo -u azureuser docker-compose up -d --quiet-pull
    echo "[LITELLM] Service started"
else
    echo "[LITELLM] Service already running"
fi

echo "[LITELLM] Setup completed!"