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

# Caminhos (Linux)
USER_HOME=$HOME
GEMINI_DIR="$USER_HOME/.gemini"
GEMINI_CONFIG="$GEMINI_DIR/config"
ANTIGRAVITY_DIR="$GEMINI_DIR/antigravity"
WORKSPACE_DIR="$USER_HOME/Antigravity_Workspace"

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

command_exists() { command -v "$1" >/dev/null 2>&1; }

if command_exists node; then ok "Node.js $(node -v)"; else fail "Node.js não encontrado."; exit 1; fi
if command_exists python3; then ok "Python $(python3 --version)"; else fail "Python3 não encontrado."; exit 1; fi
if command_exists git; then ok "Git $(git --version)"; else fail "Git não encontrado."; exit 1; fi
if command_exists gh; then ok "GitHub CLI instalado"; else skip "GitHub CLI não encontrado."; fi
if command_exists gcloud; then ok "Google Cloud CLI instalado"; else skip "Google Cloud CLI não encontrado."; fi

# ============================================================================
step "ETAPA 2/7: Criando Estrutura de Diretórios e Segundo Cérebro"

mkdir -p "$GEMINI_CONFIG/skills" "$GEMINI_CONFIG/plugins" "$ANTIGRAVITY_DIR" "$WORKSPACE_DIR"
mkdir -p "obsidian_vault"
ok "Diretórios base e Cofre Obsidian (obsidian_vault) criados."

# ============================================================================
step "ETAPA 3/7: Autenticação Google"

if command_exists gcloud; then
    info "A autenticação no gcloud desbloqueia 20+ servidores MCP."
    read -p "  Deseja fazer login no Google Cloud agora? (S/n) " resp
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

# ============================================================================
step "ETAPA 5/7: Instalando Configurações MCP (Linux)"

if [ -f "config_templates/mcp_config_cli.template.json" ]; then
    # Substituir tokens de variáveis no template
    cat config_templates/mcp_config_cli.template.json > "$GEMINI_CONFIG/mcp_config.json"
    ok "MCP config instalado em $GEMINI_CONFIG/mcp_config.json"
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
for server in "obsidian-mcp-server" "@oomkapwn/enquire-mcp" "@modelcontextprotocol/server-sequential-thinking" "@modelcontextprotocol/server-memory" "@modelcontextprotocol/server-github" "@modelcontextprotocol/server-filesystem" "@modelcontextprotocol/server-git" "@modelcontextprotocol/server-sqlite"; do
    npx -y "$server" --help >/dev/null 2>&1 || true
done
ok "Servidores principais e Obsidian (Second Brain) pré-instalados (cache npm)."

# ============================================================================
echo -e "\n${GREEN}  🎉 CONFIGURAÇÃO LINUX CONCLUÍDA!${NC}\n"
echo -e "  Edite o arquivo ${YELLOW}.env${NC} para adicionar seus tokens (como OpenRouter)."
echo -e "  Para rodar o agente em background isolado, utilize:"
echo -e "  ${CYAN}docker-compose up -d${NC}\n"
