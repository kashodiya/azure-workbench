#!/bin/bash

# Main orchestration script
echo "[MAIN] Starting main setup script..."
echo "[MAIN] Current user: $(whoami)"
echo "[MAIN] Current directory: $(pwd)"

# Update system packages once at the beginning (only if not updated recently)
echo "[MAIN] Checking if system packages need updating..."
if [ ! -f /var/lib/apt/periodic/update-success-stamp ] || [ $(find /var/lib/apt/periodic/update-success-stamp -mtime +1) ]; then
    echo "[MAIN] Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    echo "[MAIN] System update completed with exit code: $?"
else
    echo "[MAIN] System packages recently updated, skipping update"
fi

# Install gettext for envsubst
echo "[MAIN] Checking if gettext is installed..."
if ! command -v envsubst &> /dev/null; then
    echo "[MAIN] Installing gettext for template substitution..."
    sudo apt install -y gettext-base
    echo "[MAIN] gettext installation completed with exit code: $?"
else
    echo "[MAIN] gettext already installed, skipping installation"
fi

# Get project name - use hardcoded value since it's consistent
echo "[MAIN] Setting project name..."
PROJECT_NAME="oh"
echo "[MAIN] Project name: $PROJECT_NAME"

# Set default values (replace with your actual configuration method)
echo "[MAIN] Setting default configuration values..."
OPENHANDS_LITELLM_KEY="your-litellm-key-here"
ADMIN_PASSWORD="admin123"

# Export variables for use in child scripts
export OPENHANDS_LITELLM_KEY="$OPENHANDS_LITELLM_KEY"
export ADMIN_PASSWORD="$ADMIN_PASSWORD"
export OPENHANDS_VSCODE_TOKEN="vscode-token-$(date +%s)"

echo "[MAIN] Configuration retrieved successfully."
echo "[MAIN] LITELLM_KEY length: ${#OPENHANDS_LITELLM_KEY}"
echo "[MAIN] ADMIN_PASSWORD length: ${#ADMIN_PASSWORD}"

# Installation control flags - set to "true" to install, "false" to skip
INSTALL_DOCKER=${INSTALL_DOCKER:-true}
INSTALL_UV=${INSTALL_UV:-true}
INSTALL_JUPYTERLAB=${INSTALL_JUPYTERLAB:-true}
INSTALL_OPENHANDS=${INSTALL_OPENHANDS:-true}
INSTALL_LITELLM=${INSTALL_LITELLM:-true}
INSTALL_OPEN_WEBUI=${INSTALL_OPEN_WEBUI:-true}
INSTALL_SEARXNG=${INSTALL_SEARXNG:-true}
INSTALL_PORTAINER=${INSTALL_PORTAINER:-true}
INSTALL_VSCODE=${INSTALL_VSCODE:-true}
INSTALL_CADDY=${INSTALL_CADDY:-true}

# Run installation scripts
if [ "$INSTALL_DOCKER" = "true" ]; then
    echo "[MAIN] Running Docker installation..."
    bash ./install-docker.sh
    echo "[MAIN] Docker installation completed with exit code: $?"
else
    echo "[MAIN] Skipping Docker installation"
fi

if [ "$INSTALL_UV" = "true" ]; then
    echo "[MAIN] Installing uv Python package manager..."
    bash ./install-uv.sh
    echo "[MAIN] uv installation completed with exit code: $?"
else
    echo "[MAIN] Skipping uv installation"
fi

if [ "$INSTALL_JUPYTERLAB" = "true" ]; then
    echo "[MAIN] Setting up JupyterLab..."
    bash ./setup-jupyterlab.sh
    echo "[MAIN] JupyterLab setup completed with exit code: $?"
else
    echo "[MAIN] Skipping JupyterLab setup"
fi

if [ "$INSTALL_DOCKER" = "true" ]; then
    echo "[MAIN] Creating Docker network..."
    if ! docker network ls | grep -q shared_network; then
        docker network create shared_network
        echo "[MAIN] Docker network creation completed with exit code: $?"
    else
        echo "[MAIN] Docker network 'shared_network' already exists, skipping creation"
    fi
    
    echo "[MAIN] Running Docker Compose installation..."
    bash ./install-docker-compose.sh
    echo "[MAIN] Docker Compose installation completed with exit code: $?"
    
    echo "[MAIN] Creating docker configurations..."
    if [ ! -d "/home/azureuser/docker" ]; then
        mkdir -p /home/azureuser/docker/{openhands,litellm,open-webui,searxng,portainer}
        mkdir -p /home/azureuser/docker/openhands/{workspace,.openhands}
        
        # Create basic docker-compose files
        cat > /home/azureuser/docker/openhands/docker-compose.yml << 'EOF'
version: '3.8'
services:
  openhands:
    image: docker.all-hands.dev/all-hands-ai/openhands:0.50
    container_name: openhands
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/opt/workspace_base
      - ./.openhands:/home/openhands/.openhands
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.50-nikolaik
      - WORKSPACE_BASE=/opt/workspace_base
    networks:
      - shared_network
    restart: unless-stopped
networks:
  shared_network:
    external: true
EOF
        
        cat > /home/azureuser/docker/litellm/docker-compose.yml << 'EOF'
version: '3.8'
services:
  litellm:
    image: ghcr.io/berriai/litellm:main-latest
    container_name: litellm
    ports:
      - "4000:4000"
    networks:
      - shared_network
    restart: unless-stopped
networks:
  shared_network:
    external: true
EOF
        
        cat > /home/azureuser/docker/open-webui/docker-compose.yml << 'EOF'
version: '3.8'
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    ports:
      - "3001:8080"
    volumes:
      - open-webui:/app/backend/data
    networks:
      - shared_network
    restart: unless-stopped
volumes:
  open-webui:
networks:
  shared_network:
    external: true
EOF
        
        cat > /home/azureuser/docker/searxng/docker-compose.yml << 'EOF'
version: '3.8'
services:
  searxng:
    image: searxng/searxng:latest
    container_name: searxng
    ports:
      - "3002:8080"
    networks:
      - shared_network
    restart: unless-stopped
networks:
  shared_network:
    external: true
EOF
        
        cat > /home/azureuser/docker/portainer/docker-compose.yml << 'EOF'
version: '3.8'
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    networks:
      - shared_network
    restart: unless-stopped
volumes:
  portainer_data:
networks:
  shared_network:
    external: true
EOF
        
        chown -R azureuser:azureuser /home/azureuser/docker
        echo "[MAIN] Docker directories and configurations created successfully"
    else
        echo "[MAIN] Docker configurations already exist, skipping creation"
    fi
else
    echo "[MAIN] Skipping Docker setup (Docker not installed)"
fi

if [ "$INSTALL_OPENHANDS" = "true" ]; then
    echo "[MAIN] Setting up OpenHands app..."
    bash ./setup-openhands-app.sh
    echo "[MAIN] OpenHands app setup completed with exit code: $?"
else
    echo "[MAIN] Skipping OpenHands app setup"
fi

if [ "$INSTALL_LITELLM" = "true" ]; then
    echo "[MAIN] Setting up LiteLLM..."
    bash ./setup-litellm.sh
    echo "[MAIN] LiteLLM setup completed with exit code: $?"
else
    echo "[MAIN] Skipping LiteLLM setup"
fi

if [ "$INSTALL_OPEN_WEBUI" = "true" ]; then
    echo "[MAIN] Setting up Open WebUI..."
    bash ./setup-open-webui.sh
    echo "[MAIN] Open WebUI setup completed with exit code: $?"
else
    echo "[MAIN] Skipping Open WebUI setup"
fi

if [ "$INSTALL_SEARXNG" = "true" ]; then
    echo "[MAIN] Setting up SearXNG..."
    bash ./setup-searxng.sh
    echo "[MAIN] SearXNG setup completed with exit code: $?"
else
    echo "[MAIN] Skipping SearXNG setup"
fi

if [ "$INSTALL_PORTAINER" = "true" ]; then
    echo "[MAIN] Setting up Portainer..."
    bash ./setup-portainer.sh
    echo "[MAIN] Portainer setup completed with exit code: $?"
else
    echo "[MAIN] Skipping Portainer setup"
fi

if [ "$INSTALL_VSCODE" = "true" ]; then
    echo "[MAIN] Installing VSCode Server..."
    bash ./install-vscode-server.sh
    echo "[MAIN] VSCode Server installation completed with exit code: $?"
else
    echo "[MAIN] Skipping VSCode Server installation"
fi

if [ "$INSTALL_CADDY" = "true" ]; then
    echo "[MAIN] Installing Caddy..."
    bash ./install-caddy.sh
    echo "[MAIN] Caddy installation completed with exit code: $?"
else
    echo "[MAIN] Skipping Caddy installation"
fi

echo "[MAIN] Main setup script completed successfully."