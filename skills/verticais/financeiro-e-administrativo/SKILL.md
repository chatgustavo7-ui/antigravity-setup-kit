---
name: financeiro-e-administrativo
description: Gerencie processos de contas a pagar, receber, faturamento, fluxos de caixa e integrações com ERPs.
---

# Financeiro e Administrativo (ERP & Faturamento)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia rotinas financeiras empresariais e integrações com ERPs líderes de mercado. Ela engloba a orquestração de transações de contas a pagar e receber, faturamento (emissão de notas fiscais), geração de relatórios de fluxo de caixa e reconciliação com sistemas como SAP, Oracle NetSuite, Conta Azul e Omie.

Use esta skill quando precisar:
- Desenvolver pipelines de exportação de dados de vendas para lançamento automático em ERPs de terceiros.
- Estruturar rotinas de conciliação bancária que comparam extratos (OFX/JSON) com lançamentos locais no banco do app.
- Automatizar o envio de faturas, cobranças e ordens de pagamento via e-mail ou WhatsApp para clientes inadimplentes.
- Gerar visões analíticas de saúde financeira, tais como DRE (Demonstração do Resultado do Exercício) e fluxo de caixa.

## 2. Stack Tecnológico e Implementação
Lidar com transações financeiras requer ACID compliance e segurança de alto nível:
- **Protocolo de Banco de Dados**: Uso estrito de transações SQL (`BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK`) para garantir consistência de lançamentos de débito e crédito.
- **Leitura de Extratos**: Bibliotecas para parsing de arquivos OFX (Open Financial Exchange) ou conexões diretas via APIs Open Finance.
- **APIs Governamentais (e-notas/NF-e)**: Middleware ou APIs especializadas (ex: Focus NFe) para emissão de notas fiscais de serviço (NFS-e) e de produto (NF-e).
- **Jobs de Auditoria**: Crons e rotinas de checagem interna para identificar divergências entre saldo total esperado e saldo somado de transações.

Dicas práticas de uso:
- Sempre use o tipo decimal ou inteiros representando centavos (multiplicado por 100) para lidar com quantias monetárias, evitando bugs de ponto flutuante.
- Registre logs imutáveis de todas as requisições de faturamento enviadas a ERPs com seu respectivo status e resposta.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Financeiro e Administrativo, utilize o seguinte prompt starter:
"Você é um arquiteto de sistemas financeiros corporativos. Ajude a estruturar uma integração estável com APIs de ERP (Conta Azul/SAP/NetSuite). Desenhe a modelagem de banco de dados para lançamentos em partidas dobradas (débito/crédito), crie as regras para parsing de extratos bancários e defina o fluxo de tratamento de erros para falhas na transmissão de notas fiscais, garantindo a atomicidade das operações."
