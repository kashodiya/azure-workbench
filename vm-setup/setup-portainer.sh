#!/bin/bash

echo "[PORTAINER] Setting up Portainer service..."

cd /home/azureuser/docker/portainer

echo "[PORTAINER] Starting Portainer service..."
if ! sudo -u azureuser docker-compose ps | grep -q "Up"; then
    sudo -u azureuser docker-compose up -d --quiet-pull
    echo "[PORTAINER] Service started"
else
    echo "[PORTAINER] Service already running"
fi

echo "[PORTAINER] Setup completed!"