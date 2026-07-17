# 📋 Catálogo Completo de Servidores MCP

> Este documento lista todos os servidores MCP (Model Context Protocol) disponíveis para o Google Antigravity, organizados por categoria.

---

## ☁️ Google Cloud (Autenticação Automática)

> **Como funciona:** Após rodar `gcloud auth login`, todos estes servidores ficam ativos automaticamente. Nenhum token adicional é necessário.

| # | Servidor | O que faz | URL do Servidor |
|---|----------|-----------|-----------------|
| 1 | **BigQuery** | Consultas SQL em petabytes de dados. Ideal para analytics e data warehousing. | `bigquery.googleapis.com/mcp` |
| 2 | **Cloud Spanner** | Banco relacional distribuído globalmente com consistência forte. | `spanner.googleapis.com/mcp` |
| 3 | **Firestore** | Banco NoSQL de documentos em tempo real. Perfeito para apps mobile e web. | `firestore.googleapis.com/mcp` |
| 4 | **Cloud SQL** | MySQL, PostgreSQL e SQL Server gerenciados pelo Google. | `sqladmin.googleapis.com/mcp` |
| 5 | **AlloyDB** | PostgreSQL turbinado pelo Google com engine columnar para analytics. | `alloydb.REGION.rep.googleapis.com/mcp` |
| 6 | **Pub/Sub** | Sistema de mensageria assíncrona para microsserviços. | `pubsub.googleapis.com/mcp` |
| 7 | **Cloud Logging** | Logs centralizados de toda a infraestrutura GCP. | `logging.googleapis.com/mcp` |
| 8 | **Cloud Monitoring** | Métricas, alertas e dashboards de performance. | `monitoring.googleapis.com/mcp` |
| 9 | **Compute Engine** | Criar, gerenciar e monitorar máquinas virtuais. | `compute.googleapis.com/mcp` |
| 10 | **Cloud Run** | Deploy de containers serverless sem gerenciar infra. | Via npm: `@google-cloud/cloud-run-mcp` |
| 11 | **GKE** | Kubernetes gerenciado pelo Google. | Via Go: `github.com/GoogleCloudPlatform/gke-mcp` |
| 12 | **Vertex AI Search** | Busca inteligente com IA sobre seus dados. | `discoveryengine.googleapis.com/mcp` |
| 13 | **Resource Manager** | Gerenciamento de projetos, pastas e organizações GCP. | `cloudresourcemanager.googleapis.com/mcp` |
| 14 | **Bigtable Admin** | Banco wide-column para IoT e séries temporais massivas. | `bigtableadmin.googleapis.com/mcp` |
| 15 | **Knowledge Catalog** | Catálogo de dados unificado (Dataplex). | `dataplex.googleapis.com/mcp` |
| 16 | **Managed Kafka** | Apache Kafka gerenciado pelo Google. | `managedkafka.googleapis.com/mcp` |
| 17 | **Dataproc** | Apache Spark e Hadoop gerenciados. | `dataproc-REGION.googleapis.com/mcp` |
| 18 | **Google Developer Knowledge** | Busca na documentação oficial do Google. | `developerknowledge.googleapis.com/mcp` |
| 19 | **Google Maps Code Assist** | Assistente de código para Google Maps Platform. | `mapscodeassist.googleapis.com/mcp` |

---

## 🛠️ Ferramentas de Desenvolvimento (Instalação via npm)

> **Como funciona:** Estes servidores são instalados automaticamente na primeira execução via `npx`. Nenhuma configuração manual necessária.

| # | Servidor | O que faz | Pacote npm |
|---|----------|-----------|------------|
| 20 | **GitHub** | Acesso a repositórios, issues, PRs e busca de código. | `@modelcontextprotocol/server-github` |
| 21 | **GitLab Orbit** | Integração com projetos GitLab. | Via mcp-remote: `gitlab.com/api/v4/orbit/mcp` |
| 22 | **Sequential Thinking** | Raciocínio estruturado passo-a-passo para problemas complexos. | `@modelcontextprotocol/server-sequential-thinking` |
| 23 | **Memory** | Memória persistente entre sessões do agente. | `@modelcontextprotocol/server-memory` |
| 24 | **Filesystem** | Leitura/escrita controlada de arquivos locais. | `@modelcontextprotocol/server-filesystem` |
| 25 | **Git** | Operações Git (log, diff, blame, status). | `@modelcontextprotocol/server-git` |
| 26 | **SQLite** | Operações em bancos SQLite locais. | `@modelcontextprotocol/server-sqlite` |
| 27 | **Chrome DevTools** | Controle do navegador Chrome (navegar, clicar, screenshots). | `chrome-devtools-mcp` |
| 28 | **Cloud Run (npm)** | Deploy rápido na nuvem Google. | `@google-cloud/cloud-run-mcp` |

---

## 🌐 Serviços Externos (Precisam de Token ou Login)

> **Como funciona:** Estes servidores conectam a plataformas externas e precisam de um token de acesso. O script `setup_antigravity.ps1` pede cada token opcionalmente.

| # | Servidor | O que faz | Variável de Ambiente | Como obter |
|---|----------|-----------|---------------------|------------|
| 29 | **Supabase** | Backend-as-a-Service com PostgreSQL, Auth e Storage. | `SUPABASE_ACCESS_TOKEN` | [supabase.com/dashboard](https://supabase.com/dashboard) → Settings → API |
| 30 | **ClickHouse** | Banco analítico columnar ultra-rápido. | Login via browser | [clickhouse.cloud](https://clickhouse.cloud) |
| 31 | **Figma Dev Mode** | Acesso ao design e tokens de componentes Figma. | `FIGMA_ACCESS_TOKEN` | [figma.com/developers](https://www.figma.com/developers) |
| 32 | **Arize Tracing** | Observabilidade e tracing para aplicações de IA. | - | Instalado via `uvx arize-tracing-assistant` |
| 33 | **Stripe** | Pagamentos, assinaturas e faturamento. | `STRIPE_SECRET_KEY` | [dashboard.stripe.com/apikeys](https://dashboard.stripe.com/apikeys) |
| 34 | **Slack** | Mensageria corporativa e automação de canais. | `SLACK_BOT_TOKEN` | [api.slack.com/apps](https://api.slack.com/apps) |
| 35 | **Notion** | Documentação e bases de conhecimento. | `NOTION_API_KEY` | [notion.so/my-integrations](https://www.notion.so/my-integrations) |
| 36 | **Linear** | Gestão ágil de projetos e issues. | `LINEAR_API_KEY` | [linear.app/settings/api](https://linear.app/settings/api) |

---

## 🔌 Claude-Mem (Memória Persistente)

| # | Servidor | O que faz | Instalação |
|---|----------|-----------|------------|
| 37 | **claude-mem** | Memória de longo prazo que persiste entre sessões. Injeta contexto automaticamente. | Configurado via `settings.json` hooks |

---

## 📊 Resumo

| Categoria | Quantidade | Autenticação |
|-----------|-----------|--------------|
| ☁️ Google Cloud | 19 servidores | Automática (gcloud auth) |
| 🛠️ Desenvolvimento | 9 servidores | Automática (npm) |
| 🌐 Serviços Externos | 8 servidores | Token manual |
| 🧠 Memória | 1 servidor | Automática |
| **Total** | **37 servidores** | - |
