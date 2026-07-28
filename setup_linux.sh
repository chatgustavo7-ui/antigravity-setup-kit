#!/bin/bash
# ============================================================================
# 🚀 Antigravity Setup Kit - Instalador WSL/Linux
# ============================================================================
# Este script configura o ecossistema Google Antigravity em ambientes Linux.
# Especialmente focado em rodar em WSL, com autenticação Google e OpenRouter.
# ============================================================================

set -e

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

command_exists() { command -v "$1" >/dev/null 2>&1; }

# Detecção de SO: Linux ou macOS (Darwin)
OS_NAME="$(uname -s)"
IS_MACOS=false
if [ "$OS_NAME" = "Darwin" ]; then
    IS_MACOS=true
fi

# Caminhos (Linux)
USER_HOME=$HOME
GEMINI_DIR="$USER_HOME/.gemini"
GEMINI_CONFIG="$GEMINI_DIR/config"
ANTIGRAVITY_DIR="$GEMINI_DIR/antigravity"
WORKSPACE_DIR="$USER_HOME/Antigravity_Workspace"
OBSIDIAN_VAULT="${ANTIGRAVITY_OBSIDIAN_VAULT_PATH:-$WORKSPACE_DIR/_ObsidianVault}"

step() {
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}
ok() { echo -e "  ${GREEN}✅ $1${NC}"; }
skip() { echo -e "  ${YELLOW}⏭️  $1${NC}"; }
fail() { echo -e "  ${RED}❌ $1${NC}"; }
info() { echo -e "  ${NC}ℹ️  $1${NC}"; }

echo -e "\n${GREEN}  ╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}  ║   🚀 ANTIGRAVITY SETUP KIT - LINUX/WSL v2.0    ║${NC}"
echo -e "${GREEN}  ║         Configuração Automática Completa        ║${NC}"
echo -e "${GREEN}  ╚══════════════════════════════════════════════════╝${NC}\n"

# ============================================================================
step "ETAPA 1/7: Verificando Pré-Requisitos"

if command_exists node; then ok "Node.js $(node -v)"; else fail "Node.js não encontrado."; exit 1; fi
if command_exists python3; then ok "Python $(python3 --version)"; else fail "Python3 não encontrado."; exit 1; fi
if command_exists git; then ok "Git $(git --version)"; else fail "Git não encontrado."; exit 1; fi
if command_exists gh; then ok "GitHub CLI instalado"; else skip "GitHub CLI não encontrado."; fi
if command_exists gcloud; then ok "Google Cloud CLI instalado"; else skip "Google Cloud CLI não encontrado."; fi

# ============================================================================
step "ETAPA 2/7: Criando Estrutura de Diretórios e Segundo Cérebro"

mkdir -p "$GEMINI_CONFIG/skills" "$GEMINI_CONFIG/plugins" "$ANTIGRAVITY_DIR" "$WORKSPACE_DIR"
mkdir -p "$OBSIDIAN_VAULT"
ok "Diretórios base e Cofre Obsidian ($OBSIDIAN_VAULT) criados."

# ============================================================================
step "ETAPA 3/7: Autenticação Google"

if command_exists gcloud; then
    info "A autenticação no gcloud desbloqueia 20+ servidores MCP."
    if [ -t 0 ]; then
        read -r -p "  Deseja fazer login no Google Cloud agora? (S/n) " resp || resp=""
    else
        resp="n"
        skip "Sem terminal interativo — login Google pulado (rode 'gcloud auth login' depois, se quiser)."
    fi
    if [[ "$resp" =~ ^[Ss]$ ]] || [[ -z "$resp" ]]; then
        info "Executando login (utilize --no-browser se estiver no Docker)..."
        gcloud auth login --update-adc
        ok "Login no Google Cloud realizado!"
    else
        skip "Login no Google pulado."
    fi
else
    skip "gcloud não está instalado. Pulando auth."
fi

# ============================================================================
step "ETAPA 4/7: Configurando OpenRouter & Variáveis"

if [ ! -f .env ]; then
    info "Criando arquivo .env a partir de .env.example..."
    cp .env.example .env
    ok ".env criado! Edite este arquivo para adicionar sua chave do OpenRouter."
else
    skip "Arquivo .env já existe."
fi

if [ -f .env ]; then
    set -a
    . ./.env
    set +a
fi

# ============================================================================
step "ETAPA 5/7: Instalando Configurações MCP (Linux)"

if [ -f "config_templates/mcp_config_cli.template.json" ]; then
    CONFIG_CONTENT=$(cat config_templates/mcp_config_cli.template.json)
    CONFIG_CONTENT="${CONFIG_CONTENT//__YOUR_GITHUB_TOKEN__/${GITHUB_PERSONAL_ACCESS_TOKEN:-}}"
    CONFIG_CONTENT="${CONFIG_CONTENT//__YOUR_STRIPE_KEY__/${STRIPE_SECRET_KEY:-}}"
    CONFIG_CONTENT="${CONFIG_CONTENT//__YOUR_SLACK_TOKEN__/${SLACK_BOT_TOKEN:-}}"
    CONFIG_CONTENT="${CONFIG_CONTENT//__OBSIDIAN_VAULT_PATH__/$OBSIDIAN_VAULT}"
    echo "$CONFIG_CONTENT" > "$GEMINI_CONFIG/mcp_config.json"
    ok "MCP config instalado em $GEMINI_CONFIG/mcp_config.json"
fi

# Instalar o app do Obsidian de verdade
if [ "$IS_MACOS" = true ] && [ -d "/Applications/Obsidian.app" ]; then
    skip "Obsidian já instalado"
elif [ "$IS_MACOS" = false ] && command_exists obsidian; then
    skip "Obsidian já instalado"
elif [ "$IS_MACOS" = true ] && command_exists brew; then
    brew install --cask obsidian && ok "Obsidian instalado via Homebrew" || fail "Falha ao instalar Obsidian via brew"
elif command_exists flatpak; then
    flatpak install -y flathub md.obsidian.Obsidian && ok "Obsidian instalado via Flatpak" || fail "Falha ao instalar Obsidian via Flatpak"
else
    info "Instale o Obsidian manualmente: https://obsidian.md/download (AppImage para Linux sem Flatpak)"
fi

if [ -f "config_templates/AGENTS.md" ]; then
    cp config_templates/AGENTS.md "$GEMINI_CONFIG/AGENTS.md"
    ok "Regras globais instaladas."
fi

# ============================================================================
step "ETAPA 6/7: Copiando Skills"

if [ -d "skills" ]; then
    cp -R skills/* "$GEMINI_CONFIG/skills/"
    ok "Skills instaladas em $GEMINI_CONFIG/skills/"
else
    fail "Pasta 'skills' não encontrada."
fi

# ============================================================================
step "ETAPA 7/7: Instalação Automática de MCPs (npm)"

info "Isso pode levar alguns minutos na primeira vez..."
for server in "@oomkapwn/enquire-mcp" "@modelcontextprotocol/server-sequential-thinking" "@modelcontextprotocol/server-memory" "@modelcontextprotocol/server-github" "@modelcontextprotocol/server-filesystem" "@modelcontextprotocol/server-git" "@modelcontextprotocol/server-sqlite"; do
    npx -y "$server" --help >/dev/null 2>&1 || true
done
ok "Servidores principais e Obsidian (Second Brain) pré-instalados (cache npm)."

# ============================================================================
echo -e "\n${GREEN}  🎉 CONFIGURAÇÃO LINUX CONCLUÍDA!${NC}\n"
echo -e "  Edite o arquivo ${YELLOW}.env${NC} para adicionar seus tokens (como OpenRouter)."
echo -e "  Para rodar o agente em background isolado, utilize:"
echo -e "  ${CYAN}docker-compose up -d${NC}\n"
