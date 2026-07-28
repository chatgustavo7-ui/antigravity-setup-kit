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
