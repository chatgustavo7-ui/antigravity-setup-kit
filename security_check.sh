#!/bin/bash
# ============================================================================
# 🔒 Antigravity Setup Kit - Verificador de Segurança (Linux/WSL)
# ============================================================================
# Este script escaneia o diretório atual em busca de possíveis credenciais ou 
# informações sensíveis que possam ter sido incluídas acidentalmente.
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Iniciando verificação de segurança...${NC}\n"

# Padrões Regex a procurar (inspirado em Gitleaks)
declare -A PATTERNS
PATTERNS["GitHub Personal Access Token"]="ghp_[a-zA-Z0-9]{36}"
PATTERNS["Google Cloud Service Account"]="\"type\":\s*\"service_account\""
PATTERNS["Google API Key"]="AIza[0-9A-Za-z\\-_]{35}"
PATTERNS["Anthropic API Key"]="sk-ant-[a-zA-Z0-9]{85}"
PATTERNS["OpenAI API Key"]="sk-[a-zA-Z0-9]{48}"
PATTERNS["OpenRouter API Key"]="sk-or-v1-[a-zA-Z0-9]{64}"
PATTERNS["Stripe Secret Key"]="sk_live_[0-9a-zA-Z]{24}"
PATTERNS["Slack Bot Token"]="xoxb-[0-9]{11}-[0-9]{11}-[a-zA-Z0-9]{24}"
PATTERNS["AWS Access Key ID"]="AKIA[0-9A-Z]{16}"
PATTERNS["Caminhos Locais Windows"]="C:\\\\Users\\\\|C:\\\\Antigravity"

FILES_TO_CHECK=$(find . -type f -not -path "*/\.*" -not -name "setup_linux.sh" -not -name "security_check.sh" -not -name "docker-compose.yml" -not -name "Dockerfile" -not -name "*.example" -not -path "*/node_modules/*")

FOUND_ISSUES=0

for file in $FILES_TO_CHECK; do
    for pattern_name in "${!PATTERNS[@]}"; do
        regex="${PATTERNS[$pattern_name]}"
        if grep -q -E "$regex" "$file"; then
            echo -e "${RED}[ALERTA] Possível $pattern_name encontrado em: $file${NC}"
            FOUND_ISSUES=$((FOUND_ISSUES+1))
        fi
    done
done

echo -e "\n${CYAN}================================================================${NC}"
if [ $FOUND_ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ Nenhuma credencial sensível detectada! O repositório está limpo.${NC}"
else
    echo -e "${RED}❌ ATENÇÃO: $FOUND_ISSUES possível(is) vazamento(s) de credencial detectado(s)!${NC}"
    echo -e "Por favor, revise os arquivos acima ANTES de fazer um git push."
    exit 1
fi
echo -e "${CYAN}================================================================${NC}"
