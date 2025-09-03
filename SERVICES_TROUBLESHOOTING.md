# Linux Services Troubleshooting Guide

## Services Overview
The vm-setup creates **3 systemd services** and **5 Docker containers**:

### Systemd Services
1. **caddy** - Web server and reverse proxy
2. **jupyterlab** - Jupyter Lab notebook server  
3. **openvscode-server** - VS Code server

### Docker Containers
1. **openhands** - OpenHands AI application
2. **litellm** - LiteLLM proxy service
3. **open-webui** - Open WebUI interface
4. **searxng** - Search engine
5. **portainer** - Docker management UI

## Systemd Services Troubleshooting

### Caddy Service
```bash
# Check service status
sudo systemctl status caddy

# Check if service is running
sudo systemctl is-active caddy

# Check if service is enabled
sudo systemctl is-enabled caddy

# Start/stop/restart service
sudo systemctl start caddy
sudo systemctl stop caddy
sudo systemctl restart caddy

# View logs
sudo journalctl -u caddy -f
sudo journalctl -u caddy --since "1 hour ago"

# Test configuration
sudo caddy validate --config /etc/caddy/Caddyfile

# Reload configuration
sudo systemctl reload caddy
```

### JupyterLab Service
```bash
# Check service status
sudo systemctl status jupyterlab

# Check if service is running
sudo systemctl is-active jupyterlab

# Start/stop/restart service
sudo systemctl start jupyterlab
sudo systemctl stop jupyterlab
sudo systemctl restart jupyterlab

# View logs
sudo journalctl -u jupyterlab -f
sudo journalctl -u jupyterlab --since "1 hour ago"

# Check if port is listening
sudo netstat -tlnp | grep :3006
sudo ss -tlnp | grep :3006
```

### OpenVSCode Server Service
```bash
# Check service status
sudo systemctl status openvscode-server

# Check if service is running
sudo systemctl is-active openvscode-server

# Start/stop/restart service
sudo systemctl start openvscode-server
sudo systemctl stop openvscode-server
sudo systemctl restart openvscode-server

# View logs
sudo journalctl -u openvscode-server -f
sudo journalctl -u openvscode-server --since "1 hour ago"

# Check if port is listening
sudo netstat -tlnp | grep :3002
sudo ss -tlnp | grep :3002
```

## Docker Services Troubleshooting

### General Docker Commands
```bash
# Check Docker daemon status
sudo systemctl status docker
sudo systemctl is-active docker

# List all containers
docker ps -a

# Check Docker network
docker network ls
docker network inspect shared_network

# View Docker logs
docker logs <container_name>
docker logs -f <container_name>
```

### OpenHands Container
```bash
# Check container status
docker ps | grep openhands

# View logs
docker logs openhands
docker logs -f openhands

# Restart container
cd /home/azureuser/docker/openhands
docker-compose restart

# Check port binding
sudo netstat -tlnp | grep :3000
sudo ss -tlnp | grep :3000

# Enter container for debugging
docker exec -it openhands /bin/bash
```

### LiteLLM Container
```bash
# Check container status
docker ps | grep litellm

# View logs
docker logs litellm
docker logs -f litellm

# Restart container
cd /home/azureuser/docker/litellm
docker-compose restart

# Check port binding
sudo netstat -tlnp | grep :4000
sudo ss -tlnp | grep :4000
```

### Open WebUI Container
```bash
# Check container status
docker ps | grep open-webui

# View logs
docker logs open-webui
docker logs -f open-webui

# Restart container
cd /home/azureuser/docker/open-webui
docker-compose restart

# Check port binding
sudo netstat -tlnp | grep :3001
sudo ss -tlnp | grep :3001
```

### SearXNG Container
```bash
# Check container status
docker ps | grep searxng

# View logs
docker logs searxng
docker logs -f searxng

# Restart container
cd /home/azureuser/docker/searxng
docker-compose restart

# Check port binding
sudo netstat -tlnp | grep :3002
sudo ss -tlnp | grep :3002
```

### Portainer Container
```bash
# Check container status
docker ps | grep portainer

# View logs
docker logs portainer
docker logs -f portainer

# Restart container
cd /home/azureuser/docker/portainer
docker-compose restart

# Check port binding
sudo netstat -tlnp | grep :9000
sudo ss -tlnp | grep :9000
```

## Port Mapping Summary
| Service | Port | Protocol |
|---------|------|----------|
| Caddy | 80, 443, 5000 | HTTP/HTTPS |
| JupyterLab | 3006 | HTTP |
| OpenVSCode Server | 3002 | HTTP |
| OpenHands | 3000 | HTTP |
| LiteLLM | 4000 | HTTP |
| Open WebUI | 3001 | HTTP |
| SearXNG | 3002 | HTTP |
| Portainer | 9000 | HTTP |

## Common Troubleshooting Commands

### Check All Service Status
```bash
# Systemd services
sudo systemctl status caddy jupyterlab openvscode-server

# Docker containers
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Check All Listening Ports
```bash
# All listening ports
sudo netstat -tlnp
sudo ss -tlnp

# Specific ports
sudo netstat -tlnp | grep -E ':(80|443|3000|3001|3002|3006|4000|5000|9000)'
```

### System Resource Usage
```bash
# Memory usage
free -h
docker stats --no-stream

# Disk usage
df -h
docker system df

# Process list
ps aux | grep -E '(caddy|jupyter|openvscode|docker)'
```

### Network Connectivity
```bash
# Test local connectivity
curl -I http://localhost:3000  # OpenHands
curl -I http://localhost:3001  # Open WebUI
curl -I http://localhost:3002  # SearXNG/VSCode
curl -I http://localhost:3006  # JupyterLab
curl -I http://localhost:4000  # LiteLLM
curl -I http://localhost:9000  # Portainer

# Test external connectivity
curl -I http://$(curl -s https://api.ipify.org):5000
```

### Log Analysis
```bash
# View all service logs
sudo journalctl -f

# View specific timeframe
sudo journalctl --since "1 hour ago" --until "now"

# View Docker compose logs
cd /home/azureuser/docker/openhands && docker-compose logs
cd /home/azureuser/docker/litellm && docker-compose logs
cd /home/azureuser/docker/open-webui && docker-compose logs
cd /home/azureuser/docker/searxng && docker-compose logs
cd /home/azureuser/docker/portainer && docker-compose logs
```

## Emergency Recovery Commands

### Restart All Services
```bash
# Restart systemd services
sudo systemctl restart caddy jupyterlab openvscode-server

# Restart Docker containers
cd /home/azureuser/docker/openhands && docker-compose restart
cd /home/azureuser/docker/litellm && docker-compose restart
cd /home/azureuser/docker/open-webui && docker-compose restart
cd /home/azureuser/docker/searxng && docker-compose restart
cd /home/azureuser/docker/portainer && docker-compose restart
```

### Stop All Services
```bash
# Stop systemd services
sudo systemctl stop caddy jupyterlab openvscode-server

# Stop Docker containers
cd /home/azureuser/docker/openhands && docker-compose down
cd /home/azureuser/docker/litellm && docker-compose down
cd /home/azureuser/docker/open-webui && docker-compose down
cd /home/azureuser/docker/searxng && docker-compose down
cd /home/azureuser/docker/portainer && docker-compose down
```

### Clean Docker Resources
```bash
# Remove stopped containers
docker container prune -f

# Remove unused images
docker image prune -f

# Remove unused volumes
docker volume prune -f

# Remove unused networks
docker network prune -f
```