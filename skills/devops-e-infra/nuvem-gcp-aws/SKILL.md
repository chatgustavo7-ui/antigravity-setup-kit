---
name: nuvem-gcp-aws
description: Arquitetura, boas práticas e deploy de serviços gerenciados na nuvem do Google Cloud e AWS.
---

# Arquitetura e Deploy na Nuvem (Google Cloud e AWS)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece diretrizes arquiteturais e operacionais para implantação, gerenciamento e consumo seguro de serviços em nuvem pública, focando nos dois principais provedores do mercado: Amazon Web Services (AWS) e Google Cloud Platform (GCP). O foco está em projetar arquiteturas resilientes, escaláveis, econômicas e seguras.

### Quando usar:
- Ao migrar workloads locais (on-premises) para serviços gerenciados da nuvem (IaaS, PaaS ou Serverless).
- Na configuração de segurança de rede na nuvem usando VPCs, Subnets, Firewalls e Grupos de Segurança.
- Para gerenciar permissões refinadas e identidades utilizando IAM (Identity and Access Management) de forma segura.
- Na arquitetura de bancos de dados gerenciados altamente disponíveis (Cloud SQL, RDS, DynamoDB, Spanner).
- Ao definir estratégias de redução de custo com instâncias Spot/Preemptivas e autoescalonamento automático de recursos.

## 2. Stack Tecnológico e Implementação (Stack recomendado e dicas práticas de uso)
Os serviços equivalentes e complementares mais utilizados nos dois ecossistemas incluem:
- **Computação e Containerização**: AWS EC2, AWS ECS/EKS, AWS Lambda vs. GCP Compute Engine, GCP GKE, GCP Cloud Run / Cloud Functions.
- **Armazenamento e Bancos**: AWS S3, RDS, DynamoDB vs. GCP Cloud Storage, Cloud SQL, BigQuery, Cloud Spanner.
- **Rede e Segurança**: AWS VPC, IAM, Security Groups vs. GCP VPC, IAM, Firewall Rules.

### Boas Práticas e Dicas Práticas:
- **Princípio do Menor Privilégio no IAM**: Nunca dê permissões de administrador genéricas a usuários ou roles de serviço. Restrinja o acesso dos recursos apenas ao que eles precisam estritamente para operar (ex: conceder apenas leitura a um bucket específico).
- **Segurança de Rede**: Mantenha servidores de banco de dados e aplicações principais em subnets privadas sem IP público. Utilize instâncias NAT Gateway ou Cloud NAT para acesso controlado à internet.
- **Monitoramento de Custos**: Crie alertas de orçamento (Budgets) e aplique tags consistentes em todos os recursos para acompanhar detalhadamente os gastos e desativar recursos ociosos.
- **Serverless para Workloads Intermitentes**: Use AWS Lambda ou GCP Cloud Run para aplicações com tráfego flutuante, reduzindo o custo fixo de servidores ligados ininterruptamente.
- **Uso de CDN e Cache**: Coloque distribuições CloudFront (AWS) ou Cloud CDN (GCP) à frente de arquivos estáticos e sites estáticos para acelerar o acesso e diminuir o tráfego nos servidores de origem.

## 3. Instrução de Inicialização (Prompt Starter / Prompt de inicialização detalhado)
Configure o assistente com o seguinte direcionamento:
"Você é o arquiteto de soluções cloud especialista em AWS e Google Cloud. Sua missão é me guiar no desenho de arquiteturas robustas, seguras e com otimização de custo na nuvem. Ao analisar meus requisitos de deploy ou topologias de rede, recomende serviços adequados de computação e banco de dados, regras de firewalls e VPCs seguras, políticas de IAM bem restritas e estratégias de automação do ciclo de vida dos recursos."
