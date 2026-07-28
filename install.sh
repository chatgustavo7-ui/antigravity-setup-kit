#!/bin/bash
# ============================================================================
# Bootstrap de instalacao remota do Antigravity Setup Kit
# Uso: curl -fsSL https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.sh | bash
# ============================================================================
set -e
set -o pipefail

REPO_TARBALL_URL="https://github.com/chatgustavo7-ui/antigravity-setup-kit/archive/refs/heads/master.tar.gz"
INSTALL_DIR="$HOME/antigravity-setup-kit"
TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/antigravity-setup-kit.XXXXXX")"
ENV_BACKUP="/tmp/antigravity-setup-kit.env.bak"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "Baixando Antigravity Setup Kit..."

curl -fsSL "$REPO_TARBALL_URL" | tar -xz -C "$TEMP_DIR" --strip-components=1

if [ -d "$INSTALL_DIR" ]; then
    echo "Pasta $INSTALL_DIR ja existe, atualizando conteudo..."
    if [ -f "$INSTALL_DIR/.env" ]; then
        cp "$INSTALL_DIR/.env" "$ENV_BACKUP"
    fi
    rm -rf "$INSTALL_DIR"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
mv "$TEMP_DIR" "$INSTALL_DIR"

if [ -f "$ENV_BACKUP" ]; then
    mv "$ENV_BACKUP" "$INSTALL_DIR/.env"
fi

echo "Instalado em $INSTALL_DIR. Rodando o setup..."
cd "$INSTALL_DIR"
chmod +x setup_linux.sh
if (: < /dev/tty) 2>/dev/null; then bash setup_linux.sh < /dev/tty; else bash setup_linux.sh; fi
