
# Azure Workbench Repository

## Overview

This repository is designed to manage infrastructure on Microsoft Azure using Infrastructure as Code (IaC) principles. It provides a comprehensive Terraform-based solution for provisioning and managing Azure resources in a consistent, repeatable, and version-controlled manner.

## Purpose

The Azure Workbench serves as a foundation for:

- **Infrastructure Management**: Automated provisioning and management of Azure resources
- **Development Environment**: Quick setup of development and testing environments
- **Best Practices**: Implementation of Azure infrastructure best practices
- **Scalability**: Easy scaling and modification of infrastructure components
- **Cost Management**: Efficient resource utilization and cost optimization

## Key Features

- **Terraform Configuration**: Complete Terraform setup for Azure infrastructure
- **Modular Design**: Organized structure for easy maintenance and extension
- **Security First**: Secure credential management and access controls
- **Documentation**: Comprehensive documentation and setup guides
- **Automation**: Automated setup scripts and deployment processes

## Infrastructure Components

Currently includes:

- **Resource Group Management**: Uses existing Azure Resource Groups
- **Virtual Networking**: VNet, subnets, and network security groups
- **Compute Resources**: Linux virtual machines with static IP addresses
- **Storage**: Boot diagnostics and storage accounts
- **Security**: SSH key management and network security rules

## Getting Started

1. Run the setup script: `./.openhands/setup.sh`
2. Configure your Azure credentials in `terraform/terraform.tfvars`
3. Initialize and apply Terraform configuration
4. Access your provisioned infrastructure

## Target Use Cases

- Development and testing environments
- Proof of concept deployments
- Learning Azure infrastructure management
- Foundation for larger infrastructure projects
- CI/CD pipeline infrastructure

This repository provides a solid foundation for managing Azure infrastructure while following industry best practices for security, maintainability, and scalability.

