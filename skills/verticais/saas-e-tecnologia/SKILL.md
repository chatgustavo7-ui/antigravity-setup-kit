---
name: saas-e-tecnologia
description: Gerencie cobrança recorrente, assinaturas, planos, faturas e integrações de pagamentos (Stripe, Iugu).
---

# SaaS e Tecnologia (Cobrança Recorrente & APIs de Pagamento)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill foca na orquestração financeira para modelos de negócios baseados em software como serviço (SaaS), assinaturas e pagamentos recorrentes ou avulsos via cartões, boletos e Pix. Ela fornece diretrizes de integração com APIs de billing e gateways como Stripe, Zuora, Iugu, Asaas e Pagar.me.

Use esta skill quando precisar:
- Implementar fluxos de checkout, upgrade, downgrade e cancelamento de planos de assinatura.
- Integrar webhooks de pagamento para gerenciar o estado da conta do usuário em tempo real (ativo, inadimplente, pausado).
- Tratar processos de recuperação de faturas em atraso (dunning), reprocessando cartões ou enviando e-mails automáticos.
- Rastrear e calcular métricas de negócio como MRR (Monthly Recurring Revenue), LTV (Lifetime Value) e taxa de Churn.

## 2. Stack Tecnológico e Implementação
A infraestrutura de cobrança recorrente deve ser resiliente, auditável e segura:
- **Gateway API Integration**: Uso das SDKs oficiais da Stripe/Iugu para operações seguras de tokenização de cartões (atendendo às regras PCI-DSS).
- **Webhooks com Assinatura**: Validação criptográfica do header das notificações recebidas para evitar fraudes de simulação de pagamentos.
- **Máquina de Estados de Assinatura**: Modelagem clara no banco local sobre os estados da assinatura e regras de carência (grace periods).
- **Idempotência**: Uso de cabeçalhos de idempotência (`Idempotency-Key`) em requisições de cobrança para prevenir duplicações acidentais.

Dicas práticas de uso:
- Nunca armazene dados brutos de cartão de crédito no banco de dados local. Use tokens gerados pelo gateway de pagamento (Stripe/Iugu).
- Crie uma tabela de logs exclusiva para respostas de gateways de pagamento para depurar disputas ou falhas de transação facilmente.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de SaaS e Tecnologia, utilize o seguinte prompt starter:
"Você é um arquiteto especialista em Billing e Gateways de Pagamento de SaaS. Projete o fluxo de integração de assinaturas recorrentes com o Stripe ou Iugu. Desenhe a máquina de estados local para o ciclo de vida das assinaturas (do trial ao churn), implemente a validação e processamento idempotente de webhooks e estruture os jobs de recuperação de cobranças falhas."
