#!/bin/bash

echo "[SEARXNG] Setting up SearXNG service..."

cd /home/azureuser/docker/searxng

echo "[SEARXNG] Starting SearXNG service..."
if ! sudo -u azureuser docker-compose ps | grep -q "Up"; then
    sudo -u azureuser docker-compose up -d --quiet-pull
    echo "[SEARXNG] Service started"
else
    echo "[SEARXNG] Service already running"
fi

echo "[SEARXNG] Setup completed!"