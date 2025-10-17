# Azure Virtual Network

> **Azure virtual network configuration with subnet and security group**

![Azure](https://img.shields.io/badge/Azure-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## About

This example demonstrates how to create a basic network infrastructure in Azure, including a Virtual Network, subnet and Network Security Group. It's a fundamental example to understand networking concepts in Azure.

## Resources Created

- **Resource Group**: Resource group to organize resources
- **Virtual Network**: Virtual network with address space 10.0.0.0/16
- **Subnet**: Subnet with prefix 10.0.1.0/24
- **Network Security Group**: Security group with SSH rule
- **NSG Association**: Association between subnet and NSG

## File Structure

```
azure-vnet/
├── network.tf           # Network configuration
└── README.md            # This file
```

## Configuração de Rede

### Virtual Network
- **Nome**: vnet-terraform
- **Espaço de Endereços**: 10.0.0.0/16
- **Localização**: Configurável via variável

### Subnet
- **Nome**: subnet-terraform
- **Prefix**: 10.0.1.0/24
- **Associada à VNet**: vnet-terraform

### Network Security Group
- **Nome**: nsg-terraform
- **Regras**:
  - SSH (porta 22) - Permitida para qualquer origem

## Como Executar

### 1. Pré-requisitos

- Terraform >= 1.3.0
- Azure CLI configurado

### 2. Configurar credenciais Azure

```bash
export ARM_CLIENT_ID="seu-client-id"
export ARM_CLIENT_SECRET="seu-client-secret"
export ARM_SUBSCRIPTION_ID="seu-subscription-id"
export ARM_TENANT_ID="seu-tenant-id"
```

### 3. Executar Terraform

```bash
# Inicializar
terraform init

# Planejar
terraform plan

# Aplicar
terraform apply

# Para destruir
terraform destroy
```

## Configuração Detalhada

### Resource Group
```hcl
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-vnet"
  location = var.location
  tags     = local.common_tags
}
```

### Virtual Network
```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.common_tags
}
```

### Subnet
```hcl
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-terraform"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

### Network Security Group
```hcl
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-terraform"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = local.common_tags
}
```

## Segurança

### Regras de Segurança
- **SSH (22)**: Permitido de qualquer origem
- **Prioridade**: 100
- **Direção**: Inbound
- **Protocolo**: TCP

### Associação NSG-Subnet
O NSG é automaticamente associado à subnet através do recurso `azurerm_subnet_network_security_group_association`.

## Arquitetura de Rede

```
┌─────────────────────────────────────┐
│         Azure Virtual Network       │
│          10.0.0.0/16                │
│                                     │
│  ┌─────────────────────────────────┐│
│  │         Subnet                  ││
│  │        10.0.1.0/24              ││
│  │                                 ││
│  │  ┌─────────────────────────────┐││
│  │  │    Network Security Group   │││
│  │  │    - SSH (22) Allow         │││
│  │  └─────────────────────────────┘││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

## Conceitos Demonstrados

- **Virtual Network**: Criação de rede virtual Azure
- **Subnets**: Divisão lógica da rede
- **Network Security Groups**: Controle de tráfego de rede
- **Associations**: Ligação entre recursos de rede
- **CIDR**: Notação de endereçamento de rede
- **Tags**: Organização e identificação de recursos

## Próximos Passos

- Adicionar mais subnets
- Configurar regras de segurança mais específicas
- Implementar peering entre VNets
- Adicionar gateways de rede
- Configurar rotas personalizadas

## Outputs Úteis

Para acessar informações dos recursos criados:

```bash
# Ver informações da VNet
terraform output

# Ver estado dos recursos
terraform show
```

---

**Base sólida para networking Azure com Terraform**
