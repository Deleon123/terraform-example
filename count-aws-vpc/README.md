# AWS Network (VPC)

> **Configuração básica de rede AWS com VPC, subnet e security group**

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

## Sobre

Este exemplo demonstra como criar uma infraestrutura de rede básica na AWS, incluindo VPC, subnet pública, internet gateway, route table e security group. É um exemplo fundamental para entender os conceitos de networking na AWS.

## Recursos Criados

- **VPC**: Rede virtual privada com CIDR 10.0.0.0/16
- **Subnet**: Subnet pública com CIDR 10.0.1.0/24
- **Internet Gateway**: Gateway para conectividade com a internet
- **Route Table**: Tabela de rotas com rota padrão
- **Route Table Association**: Associação entre subnet e route table
- **Security Group**: Grupo de segurança com regras SSH

## Estrutura de Arquivos

```
aws-net/
├── main.tf              # Configuração principal dos providers
├── network.tf           # Configuração de rede
├── outputs.tf           # Outputs dos recursos
└── README.md            # Este arquivo
```

## Configuração de Rede

### VPC
- **Nome**: vpc-terraform
- **CIDR**: 10.0.0.0/16
- **Região**: sa-east-1 (São Paulo)

### Subnet
- **Nome**: sn-terraform
- **CIDR**: 10.0.1.0/24
- **Tipo**: Pública (com internet gateway)

### Internet Gateway
- **Nome**: igw-terraform
- **Função**: Conectividade com a internet

### Route Table
- **Nome**: rt-terraform
- **Rota Padrão**: 0.0.0.0/0 → Internet Gateway

### Security Group
- **Nome**: security-group-terraform
- **Regras**:
  - SSH (22) - Permitido de qualquer origem
  - Egress - Permitido para qualquer destino

## Como Executar

### 1. Pré-requisitos

- Terraform >= 1.3.0
- AWS CLI configurado

### 2. Configurar credenciais AWS

```bash
export AWS_ACCESS_KEY_ID="sua-access-key"
export AWS_SECRET_ACCESS_KEY="sua-secret-key"
export AWS_DEFAULT_REGION="sa-east-1"
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

## Backend Remoto

Este projeto está configurado para usar um backend remoto no S3:

```hcl
backend "s3" {
  bucket = "deleon-bucket-aws-remote-state"
  key    = "aws-vpc/terraform.tfstate"
  region = "sa-east-1"
}
```

## Segurança

### Security Group Rules

#### Ingress (Entrada)
- **SSH (22)**: Permitido de qualquer origem (0.0.0.0/0)
- **Protocolo**: TCP
- **IPv6**: Também permitido (::/0)

#### Egress (Saída)
- **Todas as portas**: Permitido para qualquer destino
- **Protocolo**: Todos (-1)

## Arquitetura de Rede

```
┌─────────────────────────────────────┐
│              AWS VPC                │
│            10.0.0.0/16              │
│                                     │
│  ┌─────────────────────────────────┐ │
│  │         Subnet Pública          │ │
│  │         10.0.1.0/24             │ │
│  │                                 │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │    Internet Gateway         │ │ │
│  │  │    (Conectividade Externa)  │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                 │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │    Route Table              │ │ │
│  │  │    0.0.0.0/0 → IGW          │ │ │
│  │  └─────────────────────────────┘ │ │
│  │                                 │ │
│  │  ┌─────────────────────────────┐ │ │
│  │  │    Security Group           │ │ │
│  │  │    SSH (22) Allow           │ │ │
│  │  └─────────────────────────────┘ │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## Conceitos Demonstrados

- **VPC**: Criação de rede virtual privada
- **Subnets**: Divisão lógica da rede
- **Internet Gateway**: Conectividade com a internet
- **Route Tables**: Controle de roteamento
- **Security Groups**: Controle de tráfego de rede
- **CIDR**: Notação de endereçamento de rede
- **Backend Remoto**: Estado compartilhado no S3

## Outputs

O projeto expõe IDs importantes para uso em outros projetos:

```bash
# ID da subnet
terraform output subnet_id

# ID do security group
terraform output security_group_id
```

## Uso em Outros Projetos

Este projeto é usado como base para outros projetos que precisam de uma VPC. Os outputs podem ser acessados via remote state:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "deleon-bucket-aws-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}

# Usar a subnet
subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id

# Usar o security group
security_group_id = data.terraform_remote_state.vpc.outputs.security_group_id
```

## Próximos Passos

- Adicionar mais subnets em diferentes AZs
- Configurar NAT Gateway para subnets privadas
- Implementar VPC Peering
- Adicionar mais regras de segurança
- Configurar VPN Gateway
- Implementar Network ACLs

## Referências

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Base sólida para networking AWS com Terraform**
