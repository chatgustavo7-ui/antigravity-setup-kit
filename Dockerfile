# Usa uma imagem base oficial do Ubuntu
FROM ubuntu:24.04

# Define variáveis de ambiente para evitar prompts interativos durante a instalação
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV PATH="/root/.cargo/bin:/root/.local/bin:/root/.bun/bin:${PATH}"

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    jq \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Instala o Node.js 22 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Instala Python 3.12 e pip
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && apt-get install -y python3.12 python3.12-venv python3.12-dev python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Instala Bun
RUN curl -fsSL https://bun.sh/install | bash

# Instala uv (gerenciador rápido de pacotes Python)
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/root/.cargo/bin" sh

# Instala GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y

# Instala Google Cloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-cli

# Define o diretório de trabalho principal
WORKDIR /workspace

# Copia os arquivos de setup do kit para dentro da imagem (opcional, mas útil se quiser rodar o setup dentro)
COPY . /antigravity-setup-kit

# Permissão de execução para os scripts shell
RUN chmod +x /antigravity-setup-kit/setup_linux.sh /antigravity-setup-kit/security_check.sh

# Mantém o container rodando para que possa ser acessado ou para orquestradores rodarem em background
CMD ["tail", "-f", "/dev/null"]
