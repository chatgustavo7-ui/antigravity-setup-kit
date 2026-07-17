---
name: automacao-shell-powershell
description: Comandos e scripts PowerShell e Bash para configuração de máquinas e rotinas do sistema operacional.
---

# Automação via Shell e PowerShell

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define as melhores práticas, comandos e estruturas para criar e gerenciar scripts em PowerShell (Windows) e Bash (Linux/macOS). Ela permite automatizar tarefas administrativas do sistema operacional, configurar ambientes de desenvolvimento e servidores, gerenciar processos e executar rotinas agendadas.

Você deve usar esta skill quando precisar:
- Configurar e instalar ferramentas no sistema operacional programaticamente.
- Gerenciar variáveis de ambiente e caminhos de sistema (PATH).
- Monitorar a saúde de serviços locais, consumo de memória ou espaço em disco.
- Criar scripts de inicialização, backups automáticos de diretórios do sistema e deploy local.
- Integrar chamadas CLI de diferentes ferramentas instaladas na máquina.

## 2. Stack Tecnológico e Implementação
As principais tecnologias e conceitos recomendados incluem:
- **PowerShell 7+ (ou Windows PowerShell 5.1)**: Utilizando cmdlets padrão (`Get-Service`, `Copy-Item`, `New-Item`, etc.) e manipulação direta de objetos .NET.
- **Bash (Bourne Again Shell)**: Utilitários padrão do UNIX (`grep`, `awk`, `sed`, `find`, `tar`).
- **Agendadores de Tarefas**: Integração com Windows Task Scheduler (via `Register-ScheduledTask`) ou Cron Jobs no Linux.

Dicas práticas:
- Em PowerShell, sempre ative `Set-StrictMode -Version Latest` e declare `$ErrorActionPreference = 'Stop'` no início do script para falhar rapidamente em caso de erros não tratados.
- Em Bash, use `set -euo pipefail` para garantir segurança na execução do script.
- Sempre documente os requisitos de privilégios elevados (administrador/sudo) que o script exige para rodar sem interrupções.

## 3. Instrução de Inicialização
Ao inicializar um agente com esta skill, utilize o seguinte prompt de inicialização:
"Atue como um administrador de sistemas especializado em automação de sistemas operacionais via PowerShell e Bash. Escreva scripts modulares, defensivos e bem documentados. Garanta que o script manipule erros com clareza, verifique a presença de dependências externas antes de executar comandos e forneça feedback detalhado das operações realizadas no terminal."
