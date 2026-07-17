<div align="center">

# 🚀 Antigravity Setup Kit

### Kit de Configuração Automatizada para Google Antigravity (CLI + IDE)

[![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-0078D6?logo=windows)](https://www.microsoft.com/windows)
[![Node.js](https://img.shields.io/badge/Node.js-%3E%3D20-339933?logo=node.js)](https://nodejs.org)
[![Python](https://img.shields.io/badge/Python-%3E%3D3.10-3776AB?logo=python)](https://python.org)
[![License](https://img.shields.io/badge/Licença-MIT-green)](LICENSE)

**Clone → Rode → Pronto!** Configure seu ecossistema Antigravity completo em menos de 5 minutos.

</div>

---

## 🤔 O que é isso?

Este kit automatiza a configuração completa do **Google Antigravity** (tanto a versão CLI quanto a IDE) no Windows. Ele instala e configura:

- 🔌 **28+ Servidores MCP** (Google Cloud, GitHub, DevTools, e mais)
- 🧠 **52+ Skills** em Português (PT-BR) com nomes intuitivos
- 🏢 **13 Verticais de Negócio** com arquiteturas de referência
- 🔐 **Autenticação Google-First** — faça login pelo Google e 20+ serviços ficam prontos automaticamente
- 📋 **Regras Globais** para padronização de projetos

## ✅ Pré-requisitos

Antes de rodar o instalador, certifique-se de ter instalado:

- [ ] **Node.js** >= 20 → [Baixar aqui](https://nodejs.org)
- [ ] **Python** >= 3.10 → [Baixar aqui](https://python.org)
- [ ] **Git** → [Baixar aqui](https://git-scm.com)
- [ ] **GitHub CLI** → `winget install GitHub.cli`
- [ ] **Google Cloud CLI** → [Baixar aqui](https://cloud.google.com/sdk/docs/install) *(para os 20+ servidores GCP)*

**Opcionais:**
- [ ] **Bun** → `irm bun.sh/install.ps1 | iex`
- [ ] **uv** (gerenciador Python) → `pip install uv`

## 🚀 Instalação em 3 Passos

### Passo 1: Clone o repositório
```powershell
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
```

### Passo 2: Rode o instalador
```powershell
powershell -ExecutionPolicy Bypass -File .\setup_antigravity.ps1
```

### Passo 3: Pronto! 🎉
Abra o **Antigravity IDE** ou rode `agy` no terminal. Todos os servidores MCP e skills estarão configurados.

## 📂 Estrutura de Pastas

```
AntigravitySetupKit/
├── 📄 setup_antigravity.ps1          # Instalador principal
├── 📄 security_check.ps1             # Scanner de segredos
├── 📄 README.md                      # Este arquivo
├── 📄 .gitignore                     # Proteção de arquivos sensíveis
├── 📁 config_templates/              # Templates de configuração
│   ├── mcp_config_cli.template.json  # MCP para Antigravity CLI
│   ├── mcp_config_ide.template.json  # MCP para Antigravity IDE
│   ├── settings.template.json        # Hooks (memória persistente)
│   ├── AGENTS.md                     # Regras globais do agente
│   └── GEMINI.md                     # Diretivas raiz
├── 📁 skills/                        # 52+ Skills em PT-BR
│   ├── verticais/         (13)       # Verticais de negócio
│   ├── desenvolvimento/   (10)       # Programação & Arquitetura
│   ├── ia-e-dados/        (6)        # IA, ML & Dados
│   ├── web-e-mobile/      (7)        # Frontend & Mobile
│   ├── devops-e-infra/    (5)        # DevOps & Cloud
│   ├── negocios/          (6)        # Negócios & Produtividade
│   └── automacao/         (5)        # Automação & Scraping
├── 📁 workspace_template/            # Template para novos projetos
└── 📁 docs/                          # Documentação completa
    ├── CATALOGO_MCP.md               # Catálogo de servidores MCP
    ├── GUIA_DE_SKILLS.md             # Como usar e criar skills
    └── SOLUCAO_DE_PROBLEMAS.md       # Troubleshooting
```

## 🧠 Skills Incluídas

### 🏢 Verticais de Negócio (13 skills)

| Skill | Descrição |
|-------|-----------|
| `rh-e-pessoas` | Gestão de RH, recrutamento e hierarquias (ref: Workday, BambooHR) |
| `juridico-e-compliance` | LegalTech, LGPD, trilhas de auditoria (ref: Clio, DocuSign) |
| `financeiro-e-administrativo` | Faturamento e fluxo de caixa (ref: QuickBooks, Stripe) |
| `estrategia-operacoes-processos` | Gestão de projetos e Kanban (ref: Jira, Linear, Notion) |
| `comunicacao-interna` | Chat em tempo real e WebSockets (ref: Slack, Discord) |
| `educacao` | LMS e e-learning (ref: Moodle, Canvas, Coursera) |
| `contabilidade` | Partidas dobradas e razão contábil (ref: Ledger) |
| `saas-e-tecnologia` | Multi-tenant, CMS headless (ref: Strapi, Odoo) |
| `industria-franquias-distribuicao` | ERP industrial e estoque (ref: SAP, ERPNext) |
| `agro-e-agronegocio` | IoT, sensores e georreferenciamento (ref: Climate FieldView) |
| `construcao-civil-imobiliario` | Gestão de obras e BIM (ref: Procore) |
| `financas-consultoria-servicos-locais` | Agendamentos e CRM (ref: Calendly, Salesforce) |
| `desenvolvimento-jogos-plugins-ui` | Design Systems e ECS (ref: Unity, Radix UI) |

### 💻 Desenvolvimento (10 skills)

| Skill | Descrição |
|-------|-----------|
| `apis-restful` | Criação de APIs REST e GraphQL com FastAPI |
| `arquitetura-limpa` | Padrões de arquitetura (Clean, Hexagonal, DDD) |
| `banco-dados-sql` | Modelagem de bancos relacionais e consultas SQL |
| `debugging-avancado` | Técnicas profissionais de debugging |
| `testes-unitarios` | Testes unitários, integração e E2E |
| `otimizacao-performance` | Performance e profiling de código |
| `revisao-codigo` | Revisão de código com boas práticas |
| `refatoracao-codigo` | Refatoração segura e contínua |
| `seguranca-aplicacoes` | Segurança de aplicações (OWASP) |
| `documentacao-tecnica` | Documentação técnica clara e completa |

### 🤖 IA & Dados (6 skills)

| Skill | Descrição |
|-------|-----------|
| `engenharia-prompts` | Engenharia de prompts para LLMs |
| `modelagem-preditiva` | Machine Learning e modelos preditivos |
| `analise-exploratoria-dados` | Análise de dados com Python/Pandas |
| `llm-agents` | Construção de sistemas multiagentes |
| `pipelines-dados-etl` | Pipelines de dados e ETL |
| `banco-dados-vetoriais` | Bancos vetoriais e RAG |

### 🌐 Web & Mobile (7 skills) · ⚙️ DevOps (5 skills) · 💼 Negócios (6 skills) · 🤖 Automação (5 skills)

*Veja o [Guia de Skills](docs/GUIA_DE_SKILLS.md) completo para detalhes.*

## 🔌 Servidores MCP

### Google Cloud (autenticação automática via `gcloud auth`)

| Servidor | O que faz |
|----------|-----------|
| BigQuery | Consultas SQL em dados massivos |
| Spanner | Banco distribuído global |
| Firestore | Banco NoSQL de documentos |
| Cloud SQL | MySQL/PostgreSQL gerenciado |
| Pub/Sub | Mensageria assíncrona |
| Cloud Logging | Logs centralizados |
| Cloud Monitoring | Métricas e alertas |
| Compute Engine | Máquinas virtuais |
| Cloud Run | Containers serverless |
| Vertex AI Search | Busca com IA |
| Resource Manager | Gestão de projetos GCP |
| Bigtable Admin | Banco wide-column |
| Knowledge Catalog | Catálogo de dados |
| Managed Kafka | Streaming de eventos |

### Ferramentas de Desenvolvimento (instalação automática via npm)

| Servidor | O que faz |
|----------|-----------|
| GitHub | Repositórios, issues, PRs |
| Sequential Thinking | Raciocínio passo-a-passo |
| Memory | Memória persistente entre sessões |
| Chrome DevTools | Controle do navegador |
| SQLite | Banco de dados local |

### Serviços Externos (precisam de token)

| Servidor | O que faz | Token |
|----------|-----------|-------|
| Supabase | Backend-as-a-Service | `SUPABASE_ACCESS_TOKEN` |
| ClickHouse | Banco analítico columnar | Login via browser |
| Figma | Design e prototipação | `FIGMA_ACCESS_TOKEN` |

## 🔒 Segurança

O kit **nunca expõe senhas** nos arquivos de configuração. Todos os tokens são:
1. Salvos como **variáveis de ambiente do Windows** (nível de usuário)
2. Referenciados nos configs via `$env:NOME_DA_VARIAVEL`

Para verificar se algum segredo vazou acidentalmente:
```powershell
powershell -File .\security_check.ps1 -ScanPath "C:\Users\SEU_USUARIO\.gemini"
```

## ❓ Perguntas Frequentes

**P: Preciso pagar algo?**
R: Não! O Antigravity e todos os servidores MCP do Google Cloud são gratuitos com uma conta Google.

**P: Funciona em Mac/Linux?**
R: Este kit é específico para Windows. Para Mac/Linux, adapte o script `.ps1` para `.sh`.

**P: E se eu não tiver o Google Cloud CLI?**
R: O script funciona sem ele, mas você perde acesso aos 20+ servidores MCP do Google Cloud. Recomendamos instalar.

**P: Posso adicionar minhas próprias skills?**
R: Sim! Veja o [Guia de Skills](docs/GUIA_DE_SKILLS.md) para instruções detalhadas.

**P: O script é seguro para rodar múltiplas vezes?**
R: Sim! Ele é **idempotente** — detecta o que já existe e pula automaticamente.

## 📖 Documentação Adicional

- 📋 [Catálogo de Servidores MCP](docs/CATALOGO_MCP.md) — Lista completa com instruções
- 🧠 [Guia de Skills](docs/GUIA_DE_SKILLS.md) — Como usar e criar suas próprias skills
- 🔧 [Solução de Problemas](docs/SOLUCAO_DE_PROBLEMAS.md) — Erros comuns e soluções

---

<div align="center">

Feito com ❤️ para a comunidade Antigravity

</div>
