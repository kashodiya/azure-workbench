#!/bin/bash

echo "[DOCKER] Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
    echo "[DOCKER] Docker not found. Installing Docker..."
    echo "[DOCKER] Installing Docker package..."
    sudo apt install -y docker.io
    echo "[DOCKER] Starting Docker service..."
    sudo systemctl start docker
    echo "[DOCKER] Enabling Docker service..."
    sudo systemctl enable docker
    echo "[DOCKER] Adding azureuser to docker group..."
    sudo usermod -a -G docker azureuser
    newgrp docker
    echo "[DOCKER] Docker installation completed."
else
    echo "[DOCKER] Docker already installed, skipping installation."
fi

echo "[DOCKER] Starting Docker service..."
sudo systemctl start docker
echo "[DOCKER] Docker service status: $(sudo systemctl is-active docker)"
echo "[DOCKER] Docker version: $(docker --version 2>/dev/null || echo 'Failed to get version')"