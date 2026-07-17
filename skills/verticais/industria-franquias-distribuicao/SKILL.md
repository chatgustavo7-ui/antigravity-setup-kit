---
name: industria-franquias-distribuicao
description: Gerencie cadeia de suprimentos (SCM), logística, gestão de franquias, estoques e ERPs de manufatura e distribuição.
---

# Indústria, Franquias e Distribuição (SCM & Logística)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill orienta a orquestração logística, controle de cadeias de suprimentos (Supply Chain Management - SCM), supervisão de canais de franquias e gestão integrada de estoques. Ela atende a fluxos típicos de grandes ERPs industriais e de distribuição, tais como TOTVS Protheus, SAP Business One e Senior.

Use esta skill quando precisar:
- Sincronizar níveis de inventário local e multi-depósitos com ERPs centrais industriais.
- Automatizar o processamento de pedidos de compra de franqueados e roteamento de remessa para centros de distribuição.
- Mapear fluxos de ordens de produção (OP), consumo de matérias-primas e cálculo de custo médio.
- Rastrear rotas logísticas, integrando com APIs de transportadoras ou correios para acompanhamento de frete.

## 2. Stack Tecnológico e Implementação
Operações físicas dependem de precisão em tempo real e resiliência em ambientes de conectividade intermitente:
- **Protocolo SOAP / REST de ERPs**: Conexão com Web Services SOAP clássicos do TOTVS Protheus ou REST API do SAP B1 para tráfego de dados.
- **Bancos de Dados para Inventário**: Controle rigoroso de estoque usando bloqueio pessimista (`SELECT FOR UPDATE`) para evitar concorrência de pedidos que zerem o estoque.
- **Leitura de Código de Barras / RFID**: Integrações de leitores de mão no frontend para entrada e saída rápida de mercadorias no galpão.
- **Jobs de Sincronização em Lote (ETL)**: Pipelines que consolidam movimentações diárias do estoque físico local e atualizam o ERP durante a noite.

Dicas práticas de uso:
- Sempre armazene as chaves de nota fiscal e códigos XML de transporte (CT-e) para cruzamento de dados com a contabilidade central.
- Crie uma fila local de contingência offline para registro de produção, transmitindo os dados assim que a rede se restabelecer.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Indústria, Franquias e Distribuição, utilize o seguinte prompt starter:
"Você é um arquiteto especialista em SCM e integrações industriais (TOTVS/SAP B1). Desenhe o fluxo técnico de pedidos de compra multi-depósito e faturamento integrado. Projete a modelagem de banco de dados para concorrência de estoque físico, descreva o fluxo de retentativas para integração com o ERP legado e crie as especificações de conciliação diária de estoques."
