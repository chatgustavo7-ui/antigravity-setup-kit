---
name: infraestrutura-como-codigo
description: Provisionamento e gerenciamento declarativo de infraestrutura usando Terraform e Ansible.
---

# Infraestrutura como Código (IaC) e Gerenciamento de Configuração

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece diretrizes essenciais para provisionar, gerenciar e configurar recursos de infraestrutura de TI de forma declarativa e automatizada. Focamos na separação entre o provisionamento de recursos físicos/virtuais (computação, redes, armazenamento) e a posterior instalação de dependências e configuração de servidores (sistemas operacionais, serviços).

### Quando usar:
- Ao criar, alterar ou destruir recursos de nuvem (máquinas virtuais, bancos de dados gerenciados, VPCs) de forma replicável.
- Para manter a consistência de configuração entre ambientes de desenvolvimento, homologação e produção, evitando o desvio de configuração (configuration drift).
- Na instalação automatizada de servidores web, bancos de dados ou agentes de monitoramento em um conjunto de máquinas virtuais.
- Ao gerenciar o ciclo de vida completo de recursos de TI a partir do controle de versão (GitOps).
- Para manter o rastreamento das modificações de rede e permissões IAM através de auditorias de código.

## 2. Stack Tecnológico e Implementação (Stack recomendado e dicas práticas de uso)
A stack padrão de IaC e gerenciamento recomendada é:
- **Provisionamento de Infraestrutura**: Terraform, OpenTofu.
- **Gerenciamento de Configuração**: Ansible, Puppet ou Chef.
- **Validação de Código IaC**: TFLint, Terraform Docs, Ansible Lint.

### Boas Práticas e Dicas Práticas:
- **Estado Remoto do Terraform**: Nunca guarde o arquivo `terraform.tfstate` localmente em ambientes de equipe. Use backends remotos seguros (como GCS ou AWS S3) e configure o bloqueio de estado (State Locking) usando DynamoDB ou buckets com suporte nativo.
- **Modularização**: Organize seus códigos em módulos reutilizáveis. Separe componentes lógicos comuns (como rede, banco de dados e computação) para evitar arquivos principais (`main.tf`) gigantes e monolíticos.
- **Segurança de Variáveis**: Use variáveis sensíveis marcadas como `sensitive = true` no Terraform para que os valores não apareçam no output do console de execução.
- **Inventários Dinâmicos no Ansible**: Ao trabalhar com nuvem, utilize inventários dinâmicos do Ansible para descobrir novos servidores sob demanda, em vez de manter IPs fixos e estáticos em arquivos de texto.
- **Idempotência**: Garanta que seus playbooks do Ansible sejam idempotentes (possam rodar múltiplas vezes e resultar sempre no mesmo estado final, sem refazer tarefas desnecessárias).

## 3. Instrução de Inicialização (Prompt Starter / Prompt de inicialização detalhado)
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Infraestrutura como Código usando Terraform e Ansible. Sua missão é me guiar no provisionamento declarativo e na configuração de servidores de forma limpa, idempotente e segura. Ao analisar meus arquivos de configuração (.tf, .yaml ou .yml), sugira melhorias na organização de módulos, controle do estado remoto do Terraform, tratamento de variáveis sensíveis e eficiência em tarefas do Ansible. Me ajude a projetar arquiteturas cloud robustas."
