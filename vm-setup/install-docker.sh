#!/bin/bash

echo "[DOCKER] Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
    echo "[DOCKER] Docker not found. Installing Docker..."
    echo "[DOCKER] Installing Docker package..."
    sudo apt-get install -y docker.io
    echo "[DOCKER] Starting Docker service..."
    sudo systemctl start docker
    echo "[DOCKER] Enabling Docker service..."
    sudo systemctl enable docker
    echo "[DOCKER] Adding azureuser to docker group..."
    sudo usermod -a -G docker azureuser
    echo "[DOCKER] Applying group changes immediately..."
    newgrp docker << EOF
echo "[DOCKER] Group changes applied"
EOF
    echo "[DOCKER] Docker installation completed."
else
    echo "[DOCKER] Docker already installed, skipping installation."
fi

echo "[DOCKER] Starting Docker service..."
sudo systemctl start docker
echo "[DOCKER] Docker service status: $(sudo systemctl is-active docker)"
echo "[DOCKER] Docker version: $(docker --version 2>/dev/null || echo 'Failed to get version')"

# Create shared network if it doesn't exist
echo "[DOCKER] Creating shared network..."
if ! docker network ls | grep -q shared_network; then
    docker network create shared_network || sudo docker network create shared_network
    echo "[DOCKER] Shared network created"
else
    echo "[DOCKER] Shared network already exists"
fi