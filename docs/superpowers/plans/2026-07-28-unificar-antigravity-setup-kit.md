# Unificação e Conclusão do antigravity-setup-kit — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fechar as lacunas reais do `antigravity-setup-kit` (Obsidian ambíguo e não instalado, Stripe/Slack documentados mas não implementados, sem suporte macOS, bug de arquivo ausente, sem instalação remota de um comando) e apagar o `Enterprise_Agentic_Workspace`, que não tem nada que o kit já não tenha (e pior).

**Architecture:** Edições cirúrgicas nos arquivos existentes (scripts de setup, templates JSON, docs) seguindo os padrões já estabelecidos no repo (ex: o idioma de substituição de placeholder `__YOUR_X__` já usado para o token do GitHub). Dois arquivos novos de bootstrap (`install.ps1`, `install.sh`) na raiz.

**Tech Stack:** PowerShell 5.1+ (Windows), Bash (Linux/macOS), JSON (templates MCP), Markdown (docs).

## Global Constraints

- Todo texto voltado ao usuário (mensagens de script, docs) é em PT-BR, seguindo o tom já usado no repo (emojis nos cabeçalhos de etapa, `Write-Ok`/`ok`/`skip`/`fail` como padrão de log).
- Scripts continuam idempotentes: rodar de novo não deve duplicar nem quebrar nada (padrão já seguido em todo o repo com `Test-Path`/`[ -f ... ]` antes de criar).
- Sem macOS real disponível para teste nesta sessão — a Task 6 é escrita corretamente mas só pode ser validada por leitura/`bash -n`, não por execução end-to-end em Darwin real.
- Placeholders de token seguem o padrão existente: `__YOUR_X__` no template JSON, substituído em runtime pelo script de setup a partir de uma variável de ambiente.

---

### Task 1: Criar `.env.example` (corrige bug de arquivo ausente)

**Contexto:** `setup_linux.sh:78-80` e `README.md:47` fazem `cp .env.example .env`, mas esse arquivo não existe no repo — hoje isso quebra o script Linux (`set -e` ativo) e o passo do README. `docker-compose.yml` espera `OPENAI_API_BASE`, `OPENAI_API_KEY`, `GEMINI_API_KEY`; o setup do Windows já coleta `STRIPE_SECRET_KEY`, `SLACK_BOT_TOKEN`, `NOTION_API_KEY`, `LINEAR_API_KEY`, `FIGMA_ACCESS_TOKEN`, `SUPABASE_ACCESS_TOKEN`, `GITHUB_PERSONAL_ACCESS_TOKEN`.

**Files:**
- Create: `.env.example`

**Interfaces:**
- Produces: arquivo que `setup_linux.sh` e `install.sh` (Task 8) esperam encontrar na raiz do repo.

- [ ] **Step 1: Criar o arquivo**

```
# Copie este arquivo para .env e preencha o que for usar.
# Nada aqui é obrigatório — cada variável vazia é só pulada pelos scripts.

# OpenRouter / modelos de IA (usado pelo docker-compose.yml)
OPENAI_API_BASE=https://openrouter.ai/api/v1
OPENAI_API_KEY=
GEMINI_API_KEY=

# GitHub (autenticado automaticamente via `gh auth login` nos scripts de setup;
# preencha aqui só se estiver rodando via Docker sem gh CLI disponível)
GITHUB_PERSONAL_ACCESS_TOKEN=

# Serviços externos opcionais (ver docs/CATALOGO_MCP.md)
STRIPE_SECRET_KEY=
SLACK_BOT_TOKEN=
NOTION_API_KEY=
LINEAR_API_KEY=
FIGMA_ACCESS_TOKEN=
SUPABASE_ACCESS_TOKEN=
```

- [ ] **Step 2: Verificar que o bug do setup_linux.sh está corrigido**

Run: `test -f "/c/Servidor Gustavo/apps/antigravity-setup-kit/.env.example" && echo OK`
Expected: `OK`

- [ ] **Step 3: Commit**

```bash
git add .env.example
git commit -m "fix: adiciona .env.example (setup_linux.sh e README referenciavam arquivo inexistente)"
```

---

### Task 2: Adicionar Stripe e Slack aos templates MCP

**Contexto:** `docs/CATALOGO_MCP.md` já documenta Stripe (#33) e Slack (#34) como se existissem, mas nenhuma das duas chaves existe em `config_templates/mcp_config_ide.template.json` nem em `mcp_config_cli.template.json` (310 linhas cada, estrutura idêntica). O pacote npm exato de cada um está em `Enterprise_Agentic_Workspace/.agents/mcp_config.json`.

**Files:**
- Modify: `config_templates/mcp_config_ide.template.json`
- Modify: `config_templates/mcp_config_cli.template.json`

**Interfaces:**
- Produces: chaves JSON `"stripe"` e `"slack"` em `mcpServers`, usando os placeholders `__YOUR_STRIPE_KEY__` e `__YOUR_SLACK_TOKEN__` (consumidos pela Task 5, Step 3).

- [ ] **Step 1: Adicionar as entradas em `mcp_config_ide.template.json`**

Localize o bloco `"notebooks"` (por volta da linha 272, logo após onde hoje ficam `obsidian-advanced`/`obsidian-light` — essas duas serão tratadas na Task 3, não mexa nelas ainda) e adicione **antes** dele, mantendo vírgulas corretas entre entradas do objeto `mcpServers`:

```json
    "stripe": {
      "command": "npx",
      "args": [
        "-y",
        "@atharvagupta2003/mcp-stripe"
      ],
      "env": {
        "STRIPE_SECRET_KEY": "__YOUR_STRIPE_KEY__"
      }
    },
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@jtalk22/slack-mcp"
      ],
      "env": {
        "SLACK_BOT_TOKEN": "__YOUR_SLACK_TOKEN__"
      }
    },
```

- [ ] **Step 2: Repetir exatamente o mesmo bloco em `mcp_config_cli.template.json`**

Mesma posição relativa (antes de `"notebooks"`), mesmo conteúdo do Step 1.

- [ ] **Step 3: Verificar que os dois arquivos continuam sendo JSON válido**

Run: `node -e "JSON.parse(require('fs').readFileSync('config_templates/mcp_config_ide.template.json','utf8')); JSON.parse(require('fs').readFileSync('config_templates/mcp_config_cli.template.json','utf8')); console.log('JSON valido nos dois arquivos')"`
Expected: `JSON valido nos dois arquivos`

- [ ] **Step 4: Commit**

```bash
git add config_templates/mcp_config_ide.template.json config_templates/mcp_config_cli.template.json
git commit -m "feat: adiciona stripe e slack aos templates MCP (ja documentados no catalogo, faltava implementar)"
```

---

### Task 3: Resolver a ambiguidade do Obsidian nos templates

**Contexto:** Hoje existem duas entradas concorrentes (`obsidian-advanced` = `@oomkapwn/enquire-mcp`, `obsidian-light` = `obsidian-mcp-server`), nenhuma documentada, ambas com o caminho `/workspace/obsidian` fixo (só existe dentro do container Docker). Decisão já tomada na spec: manter só `@oomkapwn/enquire-mcp` (mais atualizado — `2026-07-25` vs `2026-06-30` — e feito especificamente para memória de agente de IA sobre um vault Obsidian), renomeada para a chave única `"obsidian"`, com o caminho como placeholder `__OBSIDIAN_VAULT_PATH__` a ser preenchido pelos scripts de setup (Task 5 e 6) com o caminho real do vault nativo.

**Files:**
- Modify: `config_templates/mcp_config_ide.template.json`
- Modify: `config_templates/mcp_config_cli.template.json`

**Interfaces:**
- Consumes: nenhuma (edição isolada de JSON).
- Produces: chave `"obsidian"` em `mcpServers`, placeholder `__OBSIDIAN_VAULT_PATH__` consumido pela Task 5 Step 3 e Task 6 Step 5.

- [ ] **Step 1: Em `mcp_config_ide.template.json`, substituir o bloco `obsidian-advanced` + `obsidian-light` por uma única entrada `obsidian`**

Antes (bloco atual, linhas ~252-271):
```json
    "obsidian-advanced": {
      "command": "npx",
      "args": [
        "-y",
        "@oomkapwn/enquire-mcp",
        "--dir",
        "/workspace/obsidian"
      ],
      "env": {}
    },
    "obsidian-light": {
      "command": "npx",
      "args": [
        "-y",
        "obsidian-mcp-server",
        "--dir",
        "/workspace/obsidian"
      ],
      "env": {}
    },
```

Depois:
```json
    "obsidian": {
      "command": "npx",
      "args": [
        "-y",
        "@oomkapwn/enquire-mcp",
        "--dir",
        "__OBSIDIAN_VAULT_PATH__"
      ],
      "env": {}
    },
```

- [ ] **Step 2: Repetir a mesma substituição em `mcp_config_cli.template.json`**

- [ ] **Step 3: Verificar JSON válido e que não sobrou nenhuma referência a `obsidian-light` ou `obsidian-mcp-server`**

Run: `node -e "JSON.parse(require('fs').readFileSync('config_templates/mcp_config_ide.template.json','utf8')); JSON.parse(require('fs').readFileSync('config_templates/mcp_config_cli.template.json','utf8')); console.log('ok')" && grep -riL "obsidian-light\|obsidian-mcp-server" config_templates/mcp_config_ide.template.json config_templates/mcp_config_cli.template.json`
Expected: `ok` seguido dos dois nomes de arquivo (confirma que a string não existe mais neles — `grep -L` lista arquivos SEM a ocorrência)

- [ ] **Step 4: Commit**

```bash
git add config_templates/mcp_config_ide.template.json config_templates/mcp_config_cli.template.json
git commit -m "fix: unifica obsidian-advanced/obsidian-light em uma unica entrada obsidian"
```

---

### Task 4: Atualizar `docs/CATALOGO_MCP.md`

**Contexto:** Documentar o Obsidian (que hoje não aparece em lugar nenhum do catálogo) e ajustar o resumo. Stripe/Slack já estão documentados (linhas 63-64) — não precisam de mudança de conteúdo, só deixam de ser "aspiracionais".

**Files:**
- Modify: `docs/CATALOGO_MCP.md`

- [ ] **Step 1: Adicionar uma nova seção de Obsidian, entre "Serviços Externos" (termina na linha 67) e "Claude-Mem" (linha 70)**

Inserir após a linha `| 36 | **Linear** | ... |` e antes de `---` / `## 🔌 Claude-Mem`:

```markdown

---

## 🧠 Obsidian (Second Brain do Agente)

> **Como funciona:** O agente lê e escreve notas num vault Obsidian local via MCP, com busca híbrida (BM25 + embeddings), formando uma memória de longo prazo que sobrevive entre sessões — complementar ao Claude-Mem. O app do Obsidian também é instalado nativamente pelos scripts de setup, então você pode abrir e navegar o mesmo vault.

| # | Servidor | O que faz | Instalação |
|---|----------|-----------|------------|
| 38 | **Obsidian** (`@oomkapwn/enquire-mcp`) | Memória de longo prazo do agente sobre um vault Obsidian real, com busca semântica. Escolhido entre duas opções por ser o mais atualizado e feito especificamente para esse caso de uso. | App instalado via `winget`/`brew`/Flatpak; vault criado automaticamente pelo script de setup |
```

- [ ] **Step 2: Atualizar a tabela "Resumo" (linhas ~80-85) para incluir a linha de Obsidian e corrigir o total**

Antes:
```markdown
| Categoria | Quantidade | Autenticação |
|-----------|-----------|--------------|
| ☁️ Google Cloud | 19 servidores | Automática (gcloud auth) |
| 🛠️ Desenvolvimento | 9 servidores | Automática (npm) |
| 🌐 Serviços Externos | 8 servidores | Token manual |
| 🧠 Memória | 1 servidor | Automática |
```

Depois:
```markdown
| Categoria | Quantidade | Autenticação |
|-----------|-----------|--------------|
| ☁️ Google Cloud | 19 servidores | Automática (gcloud auth) |
| 🛠️ Desenvolvimento | 9 servidores | Automática (npm) |
| 🌐 Serviços Externos | 8 servidores | Token manual |
| 🧠 Memória (Claude-Mem) | 1 servidor | Automática |
| 🧠 Obsidian (Second Brain) | 1 servidor | Automática (vault local) |
```

- [ ] **Step 3: Conferir visualmente que a tabela renderiza (contagem de colunas `|` bate em cada linha nova)**

Run: `grep -c '|' docs/CATALOGO_MCP.md`
Expected: número maior que antes da edição (qualquer contagem >0 confirma que as linhas de tabela foram inseridas; conferência visual do arquivo completo garante o alinhamento)

- [ ] **Step 4: Commit**

```bash
git add docs/CATALOGO_MCP.md
git commit -m "docs: documenta o Obsidian no catalogo MCP, corrige resumo"
```

---

### Task 5: `setup_antigravity.ps1` — Obsidian real + substituição de placeholders novos

**Contexto:** ETAPA 6 (linhas 218-247) já faz `-replace '__YOUR_GITHUB_TOKEN__', $env:GITHUB_PERSONAL_ACCESS_TOKEN` antes de gravar os templates. Precisa do mesmo tratamento para `__YOUR_STRIPE_KEY__`, `__YOUR_SLACK_TOKEN__` (Task 2) e `__OBSIDIAN_VAULT_PATH__` (Task 3) — este último não vem de um token digitado, é calculado pelo próprio script. ETAPA 5 (linhas 179-213) já pergunta `STRIPE_SECRET_KEY` e `SLACK_BOT_TOKEN` e salva como variável de ambiente do usuário — nada muda lá.

**Files:**
- Modify: `setup_antigravity.ps1`

**Interfaces:**
- Consumes: placeholders `__YOUR_STRIPE_KEY__`, `__YOUR_SLACK_TOKEN__`, `__OBSIDIAN_VAULT_PATH__` (Tasks 2 e 3).
- Produces: `$ObsidianVault` (caminho do vault, usado só dentro deste script).

- [ ] **Step 1: Definir o caminho do vault junto com as outras variáveis globais (após a linha 22, `$EnterpriseWorkspace = ...`)**

```powershell
$ObsidianVault = if ($env:ANTIGRAVITY_OBSIDIAN_VAULT_PATH) { $env:ANTIGRAVITY_OBSIDIAN_VAULT_PATH } else { Join-Path $EnterpriseWorkspace "_ObsidianVault" }
```

- [ ] **Step 2: Criar a pasta do vault na ETAPA 2 (dentro do `$dirs` array existente, linhas 87-91)**

Antes:
```powershell
$dirs = @(
    $GeminiDir, $GeminiConfig, "$GeminiConfig\skills", "$GeminiConfig\plugins",
    $AntigravityDir, $AntigravityIdeDir,
    $EnterpriseWorkspace
)
```

Depois:
```powershell
$dirs = @(
    $GeminiDir, $GeminiConfig, "$GeminiConfig\skills", "$GeminiConfig\plugins",
    $AntigravityDir, $AntigravityIdeDir,
    $EnterpriseWorkspace, $ObsidianVault
)
```

- [ ] **Step 3: Estender as duas substituições de template na ETAPA 6 (linhas 224-228 e 239-242) para incluir os três placeholders novos**

Antes (bloco do template CLI, linhas 224-228 — o bloco do template IDE nas linhas 239-242 é idêntico):
```powershell
    $content = Get-Content $cliTemplateSrc -Raw -Encoding UTF8
    # Substituir placeholders por valores reais das env vars
    if ($env:GITHUB_PERSONAL_ACCESS_TOKEN) {
        $content = $content -replace '__YOUR_GITHUB_TOKEN__', $env:GITHUB_PERSONAL_ACCESS_TOKEN
    }
```

Depois:
```powershell
    $content = Get-Content $cliTemplateSrc -Raw -Encoding UTF8
    # Substituir placeholders por valores reais das env vars
    if ($env:GITHUB_PERSONAL_ACCESS_TOKEN) {
        $content = $content -replace '__YOUR_GITHUB_TOKEN__', $env:GITHUB_PERSONAL_ACCESS_TOKEN
    }
    if ($env:STRIPE_SECRET_KEY) {
        $content = $content -replace '__YOUR_STRIPE_KEY__', $env:STRIPE_SECRET_KEY
    }
    if ($env:SLACK_BOT_TOKEN) {
        $content = $content -replace '__YOUR_SLACK_TOKEN__', $env:SLACK_BOT_TOKEN
    }
    # Caminhos no Windows usam \, que precisa virar \\ dentro de uma string JSON
    $obsidianVaultJson = $ObsidianVault -replace '\\', '\\\\'
    $content = $content -replace '__OBSIDIAN_VAULT_PATH__', $obsidianVaultJson
```

Aplique o mesmo trecho (as 8 linhas novas) logo após o bloco equivalente do template IDE (linhas 239-242 no arquivo original).

- [ ] **Step 4: Instalar o app do Obsidian via winget, como uma nova sub-etapa dentro da ETAPA 6 (após o bloco de "Copiar regras globais", antes da ETAPA 7 — logo após a linha que hoje termina em `Write-Ok "Diretivas globais (GEMINI.md) instaladas"`)**

```powershell
# Instalar o app do Obsidian de verdade (nao so o backend MCP)
$obsidianInstalled = $false
try {
    $obsidianCheck = winget list --id Obsidian.Obsidian 2>$null
    if ($obsidianCheck -match "Obsidian") { $obsidianInstalled = $true }
} catch {}

if ($obsidianInstalled) {
    Write-Skip "Obsidian ja instalado"
} else {
    try {
        winget install -e --id Obsidian.Obsidian --accept-package-agreements --accept-source-agreements 2>&1 | Out-Null
        Write-Ok "Obsidian instalado via winget"
    } catch {
        Write-Fail "Nao foi possivel instalar o Obsidian automaticamente. Baixe manualmente: https://obsidian.md/download"
    }
}
Write-Ok "Vault do Obsidian: $ObsidianVault"
```

- [ ] **Step 5: Verificar sintaxe do script (sem executar de verdade ainda)**

Run: `powershell -NoProfile -Command "$errors = $null; [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw 'C:\Servidor Gustavo\apps\antigravity-setup-kit\setup_antigravity.ps1'), [ref]$errors); if ($errors.Count -eq 0) { 'OK - sem erros de sintaxe' } else { $errors }"`
Expected: `OK - sem erros de sintaxe`

- [ ] **Step 6: Rodar o script de verdade nesta máquina, pulando as etapas interativas de auth, e confirmar que o vault e o mcp_config saíram corretos**

Run:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Servidor Gustavo\apps\antigravity-setup-kit\setup_antigravity.ps1" -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens
Test-Path "$env:USERPROFILE\Antigravity_Workspace\_ObsidianVault"
Select-String -Path "$env:USERPROFILE\.gemini\antigravity-ide\mcp_config.json" -Pattern '"obsidian"'
Select-String -Path "$env:USERPROFILE\.gemini\antigravity-ide\mcp_config.json" -Pattern "__OBSIDIAN_VAULT_PATH__|__YOUR_STRIPE_KEY__|__YOUR_SLACK_TOKEN__"
```
Expected: `Test-Path` retorna `True`; o primeiro `Select-String` encontra a chave `"obsidian"`; o segundo `Select-String` **não retorna nada** (confirma que não sobrou nenhum placeholder sem substituir — como `-SkipOptionalTokens` foi usado, `STRIPE_SECRET_KEY`/`SLACK_BOT_TOKEN` não estarão setados, então o `if ($env:STRIPE_SECRET_KEY)` do Step 3 não substitui nada e o placeholder ficaria lá; para este teste específico, rode sem `-SkipOptionalTokens` ou defina `$env:STRIPE_SECRET_KEY = "test"; $env:SLACK_BOT_TOKEN = "test"` antes de chamar o script, e limpe as variáveis depois)

- [ ] **Step 7: Commit**

```bash
git add setup_antigravity.ps1
git commit -m "feat: instala Obsidian de verdade via winget, cria vault real, substitui placeholders de stripe/slack/obsidian"
```

---

### Task 6: `setup_linux.sh` — detecção de macOS + Obsidian real + limpeza do pré-cache

**Contexto:** Hoje o script assume Linux/apt implicitamente (nenhuma menção a `Darwin`/macOS). A ETAPA 2 cria `obsidian_vault` relativo ao diretório de execução (não a um caminho fixo do usuário — inconsistente com o Windows). A ETAPA 5 só copia o template CLI sem nenhuma substituição de placeholder (diferente do Windows, que já faz `-replace`). A ETAPA 7 (linha 114) ainda pré-cacheia os dois pacotes concorrentes do Obsidian — precisa cair pra um só, conforme a Task 3.

**Files:**
- Modify: `setup_linux.sh`

**Interfaces:**
- Consumes: `.env` gerado a partir do `.env.example` (Task 1) para `STRIPE_SECRET_KEY`/`SLACK_BOT_TOKEN` (o script Linux não pergunta interativamente como o Windows — lê do `.env`).
- Produces: vault Obsidian real em `$WORKSPACE_DIR/_ObsidianVault`.

- [ ] **Step 1: Detectar o SO logo após a definição de cores (após a linha 16, `NC='\033[0m' # No Color`)**

```bash
# Deteccao de SO: Linux ou macOS (Darwin)
OS_NAME="$(uname -s)"
IS_MACOS=false
if [ "$OS_NAME" = "Darwin" ]; then
    IS_MACOS=true
fi

pkg_install() {
    # Uso: pkg_install <pacote-apt> <pacote-brew>
    if [ "$IS_MACOS" = true ]; then
        if command_exists brew; then
            brew install "$2"
        else
            fail "Homebrew nao encontrado. Instale em https://brew.sh antes de continuar."
        fi
    else
        if command_exists apt-get; then
            sudo apt-get install -y "$1"
        elif command_exists dnf; then
            sudo dnf install -y "$1"
        else
            fail "Nenhum gerenciador de pacotes suportado encontrado (apt-get/dnf)."
        fi
    fi
}
```

(`command_exists` já está definida mais abaixo no script original, na ETAPA 1 — mover sua definição, hoje na linha 43, para **antes** deste novo bloco, já que `pkg_install` a usa.)

- [ ] **Step 2: Mover `command_exists` para antes do bloco do Step 1**

Corte a linha `command_exists() { command -v "$1" >/dev/null 2>&1; }` de onde está hoje (linha 43, dentro da ETAPA 1) e cole-a imediatamente antes do bloco `OS_NAME="$(uname -s)"` do Step 1.

- [ ] **Step 3: Definir o caminho do vault junto com os outros caminhos (linha 23, após `WORKSPACE_DIR=...`)**

```bash
OBSIDIAN_VAULT="${ANTIGRAVITY_OBSIDIAN_VAULT_PATH:-$WORKSPACE_DIR/_ObsidianVault}"
```

- [ ] **Step 4: Trocar a criação do vault na ETAPA 2 (linha 55, `mkdir -p "obsidian_vault"`) pelo caminho real**

Antes:
```bash
mkdir -p "obsidian_vault"
ok "Diretórios base e Cofre Obsidian (obsidian_vault) criados."
```

Depois:
```bash
mkdir -p "$OBSIDIAN_VAULT"
ok "Diretórios base e Cofre Obsidian ($OBSIDIAN_VAULT) criados."
```

- [ ] **Step 5: Na ETAPA 5 (linhas 87-93), aplicar as mesmas substituições de placeholder que o Windows já faz**

Antes:
```bash
if [ -f "config_templates/mcp_config_cli.template.json" ]; then
    # Substituir tokens de variáveis no template
    cat config_templates/mcp_config_cli.template.json > "$GEMINI_CONFIG/mcp_config.json"
    ok "MCP config instalado em $GEMINI_CONFIG/mcp_config.json"
fi
```

Depois:
```bash
if [ -f "config_templates/mcp_config_cli.template.json" ]; then
    CONFIG_CONTENT=$(cat config_templates/mcp_config_cli.template.json)
    [ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ] && CONFIG_CONTENT="${CONFIG_CONTENT//__YOUR_GITHUB_TOKEN__/$GITHUB_PERSONAL_ACCESS_TOKEN}"
    [ -n "$STRIPE_SECRET_KEY" ] && CONFIG_CONTENT="${CONFIG_CONTENT//__YOUR_STRIPE_KEY__/$STRIPE_SECRET_KEY}"
    [ -n "$SLACK_BOT_TOKEN" ] && CONFIG_CONTENT="${CONFIG_CONTENT//__YOUR_SLACK_TOKEN__/$SLACK_BOT_TOKEN}"
    CONFIG_CONTENT="${CONFIG_CONTENT//__OBSIDIAN_VAULT_PATH__/$OBSIDIAN_VAULT}"
    echo "$CONFIG_CONTENT" > "$GEMINI_CONFIG/mcp_config.json"
    ok "MCP config instalado em $GEMINI_CONFIG/mcp_config.json"
fi
```

(As variáveis `GITHUB_PERSONAL_ACCESS_TOKEN`, `STRIPE_SECRET_KEY`, `SLACK_BOT_TOKEN` vêm do `.env` carregado — ver Step 7 abaixo.)

- [ ] **Step 6: Instalar o app do Obsidian, como nova sub-etapa dentro da ETAPA 5, logo após o bloco do Step 5**

```bash
# Instalar o app do Obsidian de verdade
if command_exists obsidian; then
    skip "Obsidian ja instalado"
elif [ "$IS_MACOS" = true ] && command_exists brew; then
    brew install --cask obsidian && ok "Obsidian instalado via Homebrew" || fail "Falha ao instalar Obsidian via brew"
elif command_exists flatpak; then
    flatpak install -y flathub md.obsidian.Obsidian && ok "Obsidian instalado via Flatpak" || fail "Falha ao instalar Obsidian via Flatpak"
else
    info "Instale o Obsidian manualmente: https://obsidian.md/download (AppImage para Linux sem Flatpak)"
fi
```

- [ ] **Step 7: Carregar o `.env` no início do script (logo após a linha `set -e`, linha 9) para que `GITHUB_PERSONAL_ACCESS_TOKEN`/`STRIPE_SECRET_KEY`/`SLACK_BOT_TOKEN` estejam disponíveis no Step 5**

```bash
if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi
```

- [ ] **Step 8: Remover `obsidian-mcp-server` do array de pré-cache na ETAPA 7 (linha 114)**

Antes:
```bash
for server in "obsidian-mcp-server" "@oomkapwn/enquire-mcp" "@modelcontextprotocol/server-sequential-thinking" "@modelcontextprotocol/server-memory" "@modelcontextprotocol/server-github" "@modelcontextprotocol/server-filesystem" "@modelcontextprotocol/server-git" "@modelcontextprotocol/server-sqlite"; do
```

Depois:
```bash
for server in "@oomkapwn/enquire-mcp" "@modelcontextprotocol/server-sequential-thinking" "@modelcontextprotocol/server-memory" "@modelcontextprotocol/server-github" "@modelcontextprotocol/server-filesystem" "@modelcontextprotocol/server-git" "@modelcontextprotocol/server-sqlite"; do
```

- [ ] **Step 9: Verificar sintaxe do script**

Run: `bash -n "/c/Servidor Gustavo/apps/antigravity-setup-kit/setup_linux.sh" && echo "OK - sintaxe valida"`
Expected: `OK - sintaxe valida`

- [ ] **Step 10: Rodar de verdade via WSL2 (Linux — cobre a maior parte da lógica; o ramo `IS_MACOS=true` não é exercitado aqui, só revisado por leitura) e confirmar o vault + mcp_config**

Run:
```bash
wsl -- bash -lc 'cd "/mnt/c/Servidor Gustavo/apps/antigravity-setup-kit" && STRIPE_SECRET_KEY=teste SLACK_BOT_TOKEN=teste bash setup_linux.sh; test -d "$HOME/Antigravity_Workspace/_ObsidianVault" && echo "VAULT_OK"; grep -o "\"obsidian\"" "$HOME/.gemini/config/mcp_config.json"; grep -c "__OBSIDIAN_VAULT_PATH__\|__YOUR_STRIPE_KEY__\|__YOUR_SLACK_TOKEN__" "$HOME/.gemini/config/mcp_config.json"'
```
Expected: `VAULT_OK`; a linha `"obsidian"` encontrada; a última contagem de `grep -c` retorna `0` (nenhum placeholder sobrando)

- [ ] **Step 11: Commit**

```bash
git add setup_linux.sh
git commit -m "feat: deteccao de macOS, instala Obsidian real, substitui placeholders, remove pre-cache duplicado"
```

---

### Task 7: `install.ps1` — bootstrap de instalação remota (Windows)

**Contexto:** Ponto de entrada de um comando só (`irm .../install.ps1 | iex`), decidido na spec. Baixa o repositório (zip da branch `master`, sem exigir git instalado) para uma pasta local e chama `setup_antigravity.ps1`.

**Files:**
- Create: `install.ps1`

**Interfaces:**
- Consumes: `setup_antigravity.ps1` (raiz do repo baixado).
- Produces: nenhuma interface consumida por outra task — é o ponto de entrada final.

- [ ] **Step 1: Criar o arquivo**

```powershell
# ============================================================================
# Bootstrap de instalacao remota do Antigravity Setup Kit
# Uso: irm https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.ps1 | iex
# ============================================================================

$ErrorActionPreference = "Stop"

$RepoZipUrl = "https://github.com/chatgustavo7-ui/antigravity-setup-kit/archive/refs/heads/master.zip"
$InstallDir = Join-Path $env:USERPROFILE "antigravity-setup-kit"
$TempZip = Join-Path $env:TEMP "antigravity-setup-kit.zip"
$TempExtract = Join-Path $env:TEMP "antigravity-setup-kit-extract"

Write-Host "Baixando Antigravity Setup Kit..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $RepoZipUrl -OutFile $TempZip -UseBasicParsing

if (Test-Path $TempExtract) { Remove-Item $TempExtract -Recurse -Force }
Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force

$ExtractedFolder = Get-ChildItem -Path $TempExtract -Directory | Select-Object -First 1

if (Test-Path $InstallDir) {
    Write-Host "Pasta $InstallDir ja existe, atualizando conteudo..." -ForegroundColor Yellow
    Remove-Item $InstallDir -Recurse -Force
}
Move-Item -Path $ExtractedFolder.FullName -Destination $InstallDir

Remove-Item $TempZip -Force
Remove-Item $TempExtract -Recurse -Force

Write-Host "Instalado em $InstallDir. Rodando o setup..." -ForegroundColor Cyan
Set-Location $InstallDir
& powershell -ExecutionPolicy Bypass -File "$InstallDir\setup_antigravity.ps1"
```

- [ ] **Step 2: Verificar sintaxe**

Run: `powershell -NoProfile -Command "$errors = $null; [System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw 'C:\Servidor Gustavo\apps\antigravity-setup-kit\install.ps1'), [ref]$errors); if ($errors.Count -eq 0) { 'OK - sem erros de sintaxe' } else { $errors }"`
Expected: `OK - sem erros de sintaxe`

- [ ] **Step 3: Testar de ponta a ponta contra o branch já commitado no GitHub (requer que as Tasks 1-6 já estejam commitadas e pushed)**

Run: `powershell -Command "irm https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.ps1 | iex" -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens` — **nota:** o pipe `iex` não repassa parâmetros nomeados facilmente; para este teste específico, baixe e rode localmente em vez de via `iex`: `Invoke-WebRequest https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.ps1 -OutFile test_install.ps1; .\test_install.ps1` e responda manualmente aos prompts (ou interrompa depois de confirmar que a pasta `$env:USERPROFILE\antigravity-setup-kit` foi criada com o conteúdo do repo).
Expected: pasta `%USERPROFILE%\antigravity-setup-kit` criada com o conteúdo do repositório e `setup_antigravity.ps1` inicia a execução.

- [ ] **Step 4: Commit**

```bash
git add install.ps1
git commit -m "feat: adiciona install.ps1 (bootstrap de instalacao remota via irm | iex)"
```

---

### Task 8: `install.sh` — bootstrap de instalação remota (Linux/macOS)

**Files:**
- Create: `install.sh`

**Interfaces:**
- Consumes: `setup_linux.sh` (raiz do repo baixado).

- [ ] **Step 1: Criar o arquivo**

```bash
#!/bin/bash
# ============================================================================
# Bootstrap de instalacao remota do Antigravity Setup Kit
# Uso: curl -fsSL https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.sh | bash
# ============================================================================
set -e

REPO_TARBALL_URL="https://github.com/chatgustavo7-ui/antigravity-setup-kit/archive/refs/heads/master.tar.gz"
INSTALL_DIR="$HOME/antigravity-setup-kit"

echo "Baixando Antigravity Setup Kit..."

if [ -d "$INSTALL_DIR" ]; then
    echo "Pasta $INSTALL_DIR ja existe, atualizando conteudo..."
    rm -rf "$INSTALL_DIR"
fi
mkdir -p "$INSTALL_DIR"

curl -fsSL "$REPO_TARBALL_URL" | tar -xz -C "$INSTALL_DIR" --strip-components=1

echo "Instalado em $INSTALL_DIR. Rodando o setup..."
cd "$INSTALL_DIR"
chmod +x setup_linux.sh
bash setup_linux.sh
```

- [ ] **Step 2: Verificar sintaxe**

Run: `bash -n "/c/Servidor Gustavo/apps/antigravity-setup-kit/install.sh" && echo "OK - sintaxe valida"`
Expected: `OK - sintaxe valida`

- [ ] **Step 3: Testar de ponta a ponta via WSL2 contra o branch já commitado no GitHub (requer Tasks 1-6 pushed)**

Run: `wsl -- bash -lc 'curl -fsSL https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.sh -o /tmp/test_install.sh && bash -n /tmp/test_install.sh && echo "download e sintaxe OK"'`
Expected: `download e sintaxe OK` (rodar o setup completo de novo aqui duplicaria o teste já feito na Task 6 Step 10 — este passo só confirma que o *download remoto* funciona)

- [ ] **Step 4: Commit**

```bash
git add install.sh
git commit -m "feat: adiciona install.sh (bootstrap de instalacao remota via curl | bash)"
```

---

### Task 9: Atualizar `README.md`

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Substituir a seção "Option B" (linhas 34-49) para destacar o comando de um-passo-só antes do fluxo manual com git clone**

Antes:
```markdown
### Option B: Instalação via PowerShell / Terminal

#### Windows (PowerShell Administrador)
```powershell
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
powershell -ExecutionPolicy Bypass -File .\setup_antigravity.ps1
```

#### Linux / WSL / Docker Container
```bash
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
cp .env.example .env
docker-compose up -d
```
```

Depois:
```markdown
### Option B: Comando Único (Recomendado para quem não usa Git)

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.ps1 | iex
```

#### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.sh | bash
```

Esse comando baixa o kit inteiro e já roda a configuração completa — não precisa clonar nada na mão.

### Option C: Clonar Manualmente (para quem quer revisar o código antes)

#### Windows (PowerShell Administrador)
```powershell
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
powershell -ExecutionPolicy Bypass -File .\setup_antigravity.ps1
```

#### Linux / macOS
```bash
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
cp .env.example .env
bash setup_linux.sh
```

#### Docker (qualquer SO)
```bash
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
cp .env.example .env
docker-compose up -d
```
```

- [ ] **Step 2: Atualizar a tabela de funcionalidades (linha 57) para descrever o Obsidian corretamente (hoje diz "Integração nativa com Obsidian via MCP" sem mencionar que o app também é instalado)**

Antes:
```markdown
| 🧠 **Second Brain Automático** | Integração nativa com **Obsidian via MCP** para memória persistente sem amnésia entre sessões. |
```

Depois:
```markdown
| 🧠 **Second Brain Automático** | App do **Obsidian instalado nativamente** + integração via MCP para memória persistente sem amnésia entre sessões. |
```

- [ ] **Step 3: Nos badges do topo (linha ~8), adicionar um badge de macOS ao lado do badge de Windows já existente**

Antes:
```markdown
[![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
```

Depois:
```markdown
[![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![macOS](https://img.shields.io/badge/macOS-Apple_Silicon%2FIntel-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/Linux-Qualquer_Distro-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org)
```

- [ ] **Step 4: Revisão visual — abrir o README renderizado (ou ler o markdown) e confirmar que não ficou nenhuma referência duplicada/quebrada às seções renomeadas**

Run: `grep -n "^### Option" README.md`
Expected: três linhas — `### Option A: ...`, `### Option B: Comando Único...`, `### Option C: Clonar Manualmente...`

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "docs: destaca instalacao remota de um comando, adiciona badges macOS/Linux, corrige descricao do Obsidian"
```

---

### Task 10: Apagar o repositório Enterprise_Agentic_Workspace

**Contexto:** Todo o conteúdo de valor real (Stripe, Slack) já foi portado nas Tasks 2-4. O restante (13 skills genéricas, `.venv`, plugins placeholder, `repos_externos/ruflo`) não tem nada que valha preservar, confirmado durante o brainstorming.

**Files:** nenhum arquivo local — ação via GitHub CLI.

- [ ] **Step 1: Confirmação final de que nada mais precisa ser portado**

Run: `git -C "/c/Servidor Gustavo/apps/Enterprise_Agentic_Workspace" log --oneline -10`
Expected: revisar rapidamente se há algum commit recente não coberto pela análise do brainstorming (nenhum esperado, já que o repo não teve atividade desde sua criação nesta mesma sessão).

- [ ] **Step 2: Apagar o repositório remoto**

Run: `gh repo delete chatgustavo7-ui/Enterprise_Agentic_Workspace --yes`
Expected: confirmação de exclusão pelo `gh` CLI.

- [ ] **Step 3: Remover a pasta local (fora do controle de versão do antigravity-setup-kit, é um repo Git próprio e independente)**

Run: `rm -rf "/c/Servidor Gustavo/apps/Enterprise_Agentic_Workspace"`
Expected: pasta removida.

- [ ] **Step 4: Atualizar a memória do projeto (fora do escopo de código) anotando que o repo foi consolidado**

Sem commit de código associado a este step — é só uma nota para o operador humano/agente lembrar de atualizar `infra-github-cloudflare-status.md` (memória do Claude Code) removendo a menção ao `Enterprise_Agentic_Workspace` como repositório ativo.

---

## Self-Review

**Cobertura da spec:** decisão 1 (repo único) → Task 10; decisão 2 (Obsidian único) → Task 3; decisão 3 (Obsidian real por plataforma) → Tasks 5 e 6; decisão 4 (macOS) → Task 6 Steps 1-2; decisão 5 (documentação) → Tasks 4 e 9; decisão 6 (instalação remota) → Tasks 7 e 8. Bug do `.env.example` ausente (encontrado durante a exploração, não estava na spec original, mas bloqueia a Task 6/8 de funcionar) → Task 1.

**Placeholders:** nenhum "TBD"/"implementar depois" — todo código é completo. A única ressalva documentada é a limitação real de teste em macOS (não é um placeholder, é uma limitação declarada na spec e repetida aqui nas Global Constraints).

**Consistência de nomes:** `$ObsidianVault` (PS1) / `$OBSIDIAN_VAULT` (sh) usados de forma consistente dentro de cada script; placeholder `__OBSIDIAN_VAULT_PATH__` idêntico nos dois templates JSON e nos dois scripts que o substituem.

**Ordem de execução:** Tasks 1-4 (arquivos de config/docs) não dependem umas das outras e podem rodar em qualquer ordem entre si, mas todas precisam vir **antes** das Tasks 5-6 (que consomem os placeholders definidos nelas) e das Tasks 7-8 (que empacotam os scripts das Tasks 5-6). Task 9 pode rodar a qualquer momento após a Task 7/8 existirem (referencia os arquivos `install.ps1`/`install.sh` nos exemplos). Task 10 é sempre a última.
