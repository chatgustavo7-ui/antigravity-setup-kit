---
name: monitoramento-observabilidade
description: Configuração de coleta de métricas, alertas e rastreamento usando Prometheus e Grafana.
---

# Monitoramento e Observabilidade de Sistemas

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define padrões para a implementação de sistemas de observabilidade focados nos três pilares principais: métricas, logs e rastreamento distribuído (tracing). O objetivo é garantir que a equipe técnica consiga detectar anomalias, diagnosticar a causa raiz de problemas de performance e medir a integridade das aplicações em tempo real de forma proativa.

### Quando usar:
- Ao configurar a coleta de métricas de infraestrutura (CPU, uso de memória, disco) e de negócio (taxa de erro de requisições, latência).
- Na criação de dashboards dinâmicos para visualização do estado do sistema de forma centralizada.
- Para definir regras de alerta baseadas em comportamentos anômalos ou ultrapassagem de limiares críticos.
- Ao monitorar aplicações distribuídas de microserviços e identificar gargalos de rede ou latência em chamadas de banco de dados.
- Na consolidação e pesquisa centralizada de logs em múltiplos servidores.

## 2. Stack Tecnológico e Implementação (Stack recomendado e dicas práticas de uso)
A stack de ferramentas de monitoramento e observabilidade inclui:
- **Métricas e Coleta**: Prometheus, OpenTelemetry Collector, Telegraf.
- **Visualização e Alertas**: Grafana, Prometheus Alertmanager.
- **Rastreamento e Logs**: Jaeger, Zipkin, Grafana Loki, Elasticsearch.

### Boas Práticas e Dicas Práticas:
- **Quatro Sinais de Ouro**: Ao monitorar a experiência do usuário, priorize os quatro sinais de ouro da observabilidade: Latência (tempo das requisições), Tráfego (demanda de rede/requisições), Erros (taxa de falhas) e Saturação (quão cheio está o recurso).
- **Métricas com OpenTelemetry**: Prefira utilizar bibliotecas instrumentadoras do OpenTelemetry nas aplicações. Ele fornece uma API agnóstica de vendor, facilitando trocar o backend de métricas ou tracing no futuro sem alterar o código da app.
- **Alertas Inteligentes**: Evite fadiga de alertas (alert fatigue). Configure regras de alerta com limiares estatísticos baseados em tendências ou na taxa de queima de SLO/SLA (Service Level Objective), em vez de alertas instantâneos de picos de CPU.
- **Rotulação de Métricas**: Use labels (rótulos) no Prometheus com moderação para manter a cardinalidade sob controle. Alta cardinalidade (como salvar o ID do usuário nas labels) causa uso excessivo de memória no banco de séries temporais (TSDB).
- **Padronização de Logs**: Configure suas aplicações para emitirem logs no formato JSON estruturado, facilitando a filtragem e indexação por ferramentas de análise centralizadas.

## 3. Instrução de Inicialização (Prompt Starter / Prompt de inicialização detalhado)
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Monitoramento e Observabilidade usando Prometheus, Grafana e OpenTelemetry. Sua missão é me guiar na implementação de telemetria completa para minhas aplicações e servidores. Ao analisar minhas consultas de métricas (PromQL), configurações de coletores, regras de alertas ou fluxos de logs, sugira otimizações contra alta cardinalidade, estratégias de alertas inteligentes e desenho de dashboards informativos."
