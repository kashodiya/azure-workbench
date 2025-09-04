# Azure Workbench

A comprehensive development environment on Azure VM with AI tools, web services, and development platforms. Automatically provisions and configures a complete workbench with OpenHands, JupyterLab, Open WebUI, VS Code Server, and more.

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and authenticated
- Terraform installed
- Existing Azure Resource Group
- Azure OpenAI service access

### 1. Configure Variables
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 2. Deploy Infrastructure
```bash
terraform init
terraform apply
```

### 3. Deploy Applications
```bash
cd ../scripts
# Windows
deploy-to-vm.bat <admin_username> <public_ip>
# Linux/Mac
./deploy-to-vm.sh <admin_username> <public_ip>
```

## 📋 What Gets Deployed

### Infrastructure (Terraform)
- **Azure VM**: Ubuntu 22.04 LTS with Standard_D4s_v3
- **Azure OpenAI**: GPT-4o deployment with 236 capacity
- **Networking**: VNet, subnet, NSG with security rules
- **Storage**: Boot diagnostics storage account
- **Identity**: System-assigned managed identity

### Applications & Services
| Service | Port | Description | Access URL |
|---------|------|-------------|------------|
| **Caddy** | 80/443/5000 | Reverse proxy & web server | `http://<vm-ip>:5000` |
| **JupyterLab** | 3006 | Python notebook environment | `http://<vm-ip>:5000/jupyter` |
| **OpenHands** | 3000 | AI coding assistant | `http://<vm-ip>:5000/openhands` |
| **Open WebUI** | 3001 | ChatGPT-like interface | `http://<vm-ip>:5000/chat` |
| **VS Code Server** | 3002 | Web-based VS Code | `http://<vm-ip>:5000/vscode` |
| **LiteLLM** | 4000 | LLM proxy service | Internal only |
| **SearXNG** | 3002 | Privacy-focused search | Internal only |
| **Portainer** | 9000 | Docker management UI | `http://<vm-ip>:9000` |

## 🏗️ Project Structure

```
azure-workbench/
├── terraform/           # Infrastructure as Code
│   ├── main.tf          # Provider configuration
│   ├── compute.tf       # VM and networking
│   ├── openai.tf        # Azure OpenAI service
│   ├── variables.tf     # Input variables
│   └── outputs.tf       # Output values
├── vm-setup/            # VM configuration scripts
│   ├── main.sh          # Main orchestration script
│   ├── install-*.sh     # Individual service installers
│   └── setup-*.sh       # Service configuration scripts
├── docker/              # Docker Compose configurations
│   ├── openhands/       # OpenHands AI assistant
│   ├── open-webui/      # ChatGPT-like interface
│   ├── litellm/         # LLM proxy service
│   ├── searxng/         # Search engine
│   └── portainer/       # Docker management
├── caddy/               # Reverse proxy configuration
│   ├── Caddyfile        # Main Caddy config
│   ├── apps/            # Per-service configurations
│   └── users.txt        # Basic auth users
├── scripts/             # Deployment and utility scripts
└── temp/                # Temporary files and logs
```

## 🔧 Configuration

### Required Variables (terraform.tfvars)
```hcl
resource_group_name = "your-resource-group"
azure_api_key      = "your-azure-openai-key"
allowed_ips        = ["your.ip.address/32"]
admin_password     = "your-secure-password"
```

### Optional Variables
```hcl
project_name    = "azure-workbench"  # Resource prefix
vm_size        = "Standard_D4s_v3"   # VM size
admin_username = "azureuser"         # SSH username
timezone       = "UTC"               # VM timezone
```

## 🚀 Usage

### Access Services
After deployment, access services through the main URL:
- **Main Dashboard**: `http://<vm-ip>:5000`
- **Direct Access**: Use individual service URLs from the table above

### SSH Access
```bash
# SSH key is automatically generated
ssh -i terraform/private_key.pem azureuser@<vm-ip>
```

### Service Management
```bash
# Check all services
sudo systemctl status caddy jupyterlab openvscode-server
docker ps

# Restart services
sudo systemctl restart caddy
cd ~/docker/openhands && docker-compose restart
```

## 🛠️ Development

### Local Development
1. Clone the repository
2. Modify configurations in respective folders
3. Test changes using `deploy-to-vm` script

### Adding New Services
1. Create Docker Compose file in `docker/new-service/`
2. Add Caddy configuration in `caddy/apps/new-service.Caddyfile`
3. Create setup script in `vm-setup/setup-new-service.sh`
4. Update `vm-setup/main.sh` to include new service

### Customizing VM Setup
Modify installation flags in `vm-setup/main.sh`:
```bash
INSTALL_JUPYTERLAB=${INSTALL_JUPYTERLAB:-true}
INSTALL_OPENHANDS=${INSTALL_OPENHANDS:-true}
# Set to false to skip installation
```

## 🔍 Troubleshooting

### Common Issues
1. **Services not accessible**: Check NSG rules and VM firewall
2. **Docker containers failing**: Check logs with `docker logs <container>`
3. **Caddy not starting**: Validate configuration with `caddy validate`

### Debug Commands
```bash
# Check service status
sudo systemctl status caddy jupyterlab openvscode-server

# View logs
sudo journalctl -u caddy -f
docker logs -f openhands

# Check ports
sudo netstat -tlnp | grep -E ':(80|443|3000|3001|3002|3006|4000|5000|9000)'
```

See [SERVICES_TROUBLESHOOTING.md](SERVICES_TROUBLESHOOTING.md) for detailed troubleshooting guide.

## 🗑️ Cleanup

### Destroy VM and Resources
```bash
# Using script (recommended)
.\scripts\destroy-vm.bat
# or
.\scripts\destroy-vm.ps1

# Manual destroy
cd terraform
terraform destroy
```

### Partial Cleanup
```bash
# Stop services only
ssh -i terraform/private_key.pem azureuser@<vm-ip> "sudo systemctl stop caddy jupyterlab openvscode-server"
ssh -i terraform/private_key.pem azureuser@<vm-ip> "cd docker && docker-compose -f */docker-compose.yml down"
```

## 📝 Notes

- **Security**: Services are protected by basic authentication (admin/admin123 by default)
- **SSL**: Self-signed certificates are used for HTTPS
- **Persistence**: Docker volumes persist data across container restarts
- **Updates**: Services auto-update on container restart
- **Monitoring**: Use Portainer for Docker container management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source. See individual service licenses for their respective terms.
