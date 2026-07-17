---
name: financas-consultoria-servicos-locais
description: Gerencie funil de vendas (CRM), agendamento de serviços locais, atendimento e relacionamento com clientes (Salesforce, HubSpot).
---

# Finanças, Consultoria e Serviços Locais (CRM & Agendas)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia o ciclo de relacionamento com clientes, automação de força de vendas (SFA) e agendamento de atendimento de prestadores locais ou consultores. Ela simplifica integrações com CRMs dominantes de mercado como Salesforce e HubSpot CRM, bem como sistemas locais de calendário.

Use esta skill quando precisar:
- Sincronizar leads gerados em landing pages locais diretamente para o funil de vendas do HubSpot/Salesforce.
- Desenvolver agendas online para prestação de serviços locais, evitando conflitos de horários em salas ou consultores.
- Integrar ferramentas de chat ou WhatsApp para gravação de histórico de interações dentro da ficha do cliente no CRM.
- Gerar relatórios de performance comercial, conversão de funil de vendas e velocidade de fechamento de negócios.

## 2. Stack Tecnológico e Implementação
A automação de CRM e gerenciamento de agendas requer alta reatividade e APIs integradas:
- **APIs REST de CRMs**: Uso de endpoints de contatos e negócios do Salesforce (via REST ou Bulk API) e HubSpot (SDK oficial).
- **Motores de Agendamento**: Algoritmos eficientes para verificar disponibilidade em calendários (Google Calendar / Microsoft Outlook APIs) e reservas locais em banco de dados.
- **Webhooks de Transição de Funil**: Gatilhos automáticos executados quando um negócio entra em status "fechado-ganho" para disparar o onboarding no backoffice.
- **Data Sync (Bi-direcional)**: Sincronização lógica de dados contornando limites de rate limit das APIs externas através de filas e cache local.

Dicas práticas de uso:
- Sempre armazene de forma local um mapeamento de IDs (`hubspot_deal_id` correspondente ao `local_deal_id`) para evitar consultas redundantes e lentidão nas listagens.
- Configure mecanismos de bloqueio otimista em tabelas de reservas de horários para evitar que dois clientes agendem a mesma vaga concorrentemente.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Finanças, Consultoria e Serviços Locais, utilize o seguinte prompt starter:
"Você é um engenheiro de soluções especialista em CRM e automação comercial (Salesforce/HubSpot). Projete a sincronização e fluxo de leads do sistema de cadastro local para o CRM. Planeje a modelagem de banco de dados para agendamentos de horários concorrentes de prestadores de serviços, crie a estratégia para lidar com rate limits das APIs de CRM e defina os webhooks para ações automáticas pós-venda."
