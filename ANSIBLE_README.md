# Ansible Integration for TerraLambda

This project now includes Ansible integration for enhanced deployment orchestration, configuration management, and multi-environment support.

## Overview

The hybrid approach combines:
- **Terraform** for AWS infrastructure provisioning
- **Ansible** for deployment orchestration, configuration management, and application lifecycle

## Directory Structure

```
terralambda/
├── ansible.cfg                 # Ansible configuration
├── inventory/                  # Ansible inventory
│   ├── hosts.yml              # Host definitions
│   └── group_vars/            # Environment-specific variables
│       ├── all.yml            # Global variables
│       ├── dev.yml            # Development environment
│       └── prod.yml           # Production environment
├── playbooks/                 # Ansible playbooks
│   ├── deploy.yml             # Main deployment playbook
│   ├── destroy.yml            # Infrastructure destruction
│   ├── update.yml             # Code-only updates
│   ├── validate.yml           # Validation playbook
│   └── tasks/                 # Reusable task files
├── roles/                     # Ansible roles
│   ├── lambda-build/          # Lambda function building
│   ├── terraform-deploy/      # Terraform deployment
│   ├── terraform-destroy/     # Terraform destruction
│   ├── lambda-test/           # Function testing
│   └── backup-deployment/     # Backup management
└── Makefile                   # Updated with Ansible integration
```

## Quick Start

### Prerequisites

1. **Install Ansible**:
   ```bash
   pip install ansible
   ```

2. **Install AWS CLI** and configure credentials:
   ```bash
   aws configure
   ```

3. **Ensure Go and Terraform are installed** (as before)

### Basic Usage

#### Deploy to Development
```bash
make deploy-dev
# or
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit dev
```

#### Deploy to Production
```bash
make deploy-prod
# or
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit prod
```

#### Update Function Code Only
```bash
make update-dev
# or
ansible-playbook -i inventory/hosts.yml playbooks/update.yml --limit dev
```

#### Validate Configuration
```bash
make validate
# or
ansible-playbook -i inventory/hosts.yml playbooks/validate.yml
```

#### Destroy Infrastructure
```bash
make destroy-dev
# or
ansible-playbook -i inventory/hosts.yml playbooks/destroy.yml --limit dev
```

## Available Commands

### Makefile Commands

| Command | Description |
|---------|-------------|
| `make deploy-dev` | Deploy to development environment |
| `make deploy-staging` | Deploy to staging environment |
| `make deploy-prod` | Deploy to production environment |
| `make update-dev` | Update Lambda code in development |
| `make update-staging` | Update Lambda code in staging |
| `make update-prod` | Update Lambda code in production |
| `make destroy-dev` | Destroy development infrastructure |
| `make destroy-staging` | Destroy staging infrastructure |
| `make destroy-prod` | Destroy production infrastructure |
| `make validate` | Validate all configurations |
| `make clean` | Clean up build artifacts and backups |

### Direct Ansible Commands

```bash
# Deploy with specific environment
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit dev

# Deploy with extra variables
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit prod -e "lambda_config.memory_size=1024"

# Run with verbose output
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit dev -v

# Check what would be changed (dry run)
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit dev --check
```

## Environment Configuration

### Development Environment (`inventory/group_vars/dev.yml`)
- Smaller memory allocation (128MB)
- Shorter timeout (15 seconds)
- No CloudWatch alarms
- Development-specific tags

### Production Environment (`inventory/group_vars/prod.yml`)
- Larger memory allocation (512MB)
- Longer timeout (60 seconds)
- Strict monitoring and alarms
- Production-specific tags
- Extended log retention (30 days)

## Key Features

### 1. **Automated Backups**
- Pre-deployment backups
- Pre-destruction backups
- Backup manifests with restore instructions

### 2. **Environment Management**
- Separate configurations for dev/staging/prod
- Environment-specific variables
- Terraform workspace management

### 3. **Validation and Testing**
- Pre-deployment validation
- Function testing after deployment
- AWS credentials verification

### 4. **Rollback Capabilities**
- Automated backups before changes
- Easy restoration process
- State management

### 5. **Enhanced Monitoring**
- Environment-specific monitoring settings
- CloudWatch alarm configuration
- Function testing and verification

## Customization

### Adding New Environments

1. **Create environment group vars**:
   ```yaml
   # inventory/group_vars/staging.yml
   environment: "staging"
   terraform_workspace: "staging"
   lambda_config:
     function_name: "{{ project_name }}-staging"
     memory_size: 256
   ```

2. **Update inventory**:
   ```yaml
   # inventory/hosts.yml
   staging:
     hosts:
       localhost:
         ansible_connection: local
         environment: staging
         terraform_workspace: staging
   ```

3. **Add Makefile targets**:
   ```makefile
   ansible-deploy-staging:
       ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit staging
   ```

### Custom Variables

Add environment-specific variables in `inventory/group_vars/`:

```yaml
# Custom Lambda environment variables
lambda_config:
  environment_variables:
    CUSTOM_VAR: "value"
    API_KEY: "{{ vault_api_key }}"
```

## Security Considerations

- **AWS Credentials**: Use IAM roles or environment variables
- **Secrets Management**: Consider using Ansible Vault for sensitive data
- **Backup Security**: Ensure backup files are properly secured
- **Access Control**: Limit who can run production deployments

## Troubleshooting

### Common Issues

1. **AWS Credentials Not Found**:
   ```bash
   aws sts get-caller-identity
   ```

2. **Terraform Workspace Issues**:
   ```bash
   cd terraform && terraform workspace list
   ```

3. **Go Build Failures**:
   ```bash
   go version
   cd lambda && go mod tidy
   ```

### Debug Mode

Run with verbose output for debugging:
```bash
ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --limit dev -vvv
```

## Migration from Terraform-Only

Your existing Terraform setup remains fully functional. The Ansible integration is additive:

- **Old way**: `make deploy` (still works)
- **New way**: `make deploy-dev` (recommended)

You can gradually migrate to using Ansible commands while keeping the existing workflow as a fallback.

## Next Steps

1. **Test the setup**: Run `make validate` to check your configuration
2. **Deploy to dev**: Run `make deploy-dev` to test the full workflow
3. **Customize**: Modify variables in `inventory/group_vars/` for your needs
4. **Add monitoring**: Configure additional CloudWatch alarms as needed
5. **Set up CI/CD**: Integrate with your CI/CD pipeline using the Ansible commands
