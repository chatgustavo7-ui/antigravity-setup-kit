---
name: comunicacao-interna
description: Crie bots de notificação, portais corporativos (SharePoint) e integrações de mensagens (Slack, Teams).
---

# Comunicação Interna (Bots de Mensageria & Intranets)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia e automatiza canais de distribuição de informação dentro da organização. Ela orienta a criação de bots utilitários, envios automatizados de avisos urgentes e portais de documentação baseados em ecossistemas de mensageria corporativa como Slack, Microsoft Teams, Discord e intranets estruturadas em SharePoint ou Confluence.

Use esta skill quando precisar:
- Desenvolver bots no Slack ou Teams para enviar notificações de alertas de servidores ou relatórios de vendas matinais.
- Integrar o portal de intranet com bases de dados internas para exibir aniversariantes do mês e comunicados gerais de forma dinâmica.
- Automatizar canais de suporte interno por meio de tickets que abrem no chat e registram no banco de dados local.
- Rotear alertas e logs urgentes de aplicativos para canais específicos divididos por gravidade.

## 2. Stack Tecnológico e Implementação
A integração de mensageria corporativa deve priorizar performance e UX amigável:
- **Slack Bolt Framework / Teams SDK**: Ferramentas oficiais em Node.js/Python para facilitação do recebimento e resposta de interações em tempo real.
- **Interactive Block Kit**: Uso de interfaces estruturadas em JSON (ex: Block Kit do Slack ou Adaptive Cards do Teams) para botões, inputs e formulários no chat.
- **APIs REST de SharePoint**: Autenticação com Graph API da Microsoft usando credenciais do Azure Active Directory para busca e indexação de arquivos de intranet.
- **Webhooks de Entrada (Incoming Webhooks)**: Endpoints simples para envio de mensagens formatadas sem a necessidade de manter conexões via WebSocket complexas.

Dicas práticas de uso:
- Limite a frequência de envio de notificações corporativas para evitar a "fadiga de alertas" entre os colaboradores.
- Para formulários interativos em chat, trate os tempos de resposta com filas em background para não expirar o timeout de 3 segundos exigido pelas APIs.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Comunicação Interna, utilize o seguinte prompt starter:
"Você é um especialista em integrações de comunicação corporativa. Projete um bot de notificação e interação integrado ao Slack ou Microsoft Teams. Desenhe a estrutura dos blocos JSON usando Block Kit / Adaptive Cards para inputs do usuário, descreva a arquitetura de webhooks rápidos e o processamento de respostas em segundo plano, e forneça as diretrizes para autenticação via Graph API ou Slack OAuth."
