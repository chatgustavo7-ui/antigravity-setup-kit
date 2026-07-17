---
name: docker-containers
description: Uso avançado do Docker e Docker Compose para isolamento e padronização do ambiente local e de produção.
---

# Uso Avançado do Docker e Docker Compose

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece diretrizes e padrões avançados para o uso do Docker e Docker Compose, focando no isolamento, portabilidade, reprodutibilidade e padronização de ambientes de desenvolvimento local, homologação e produção. Ela ajuda a estruturar imagens leves, seguras e eficientes, além de orquestrar múltiplos containers de forma simples e escalável.

### Quando usar:
- Na conteinerização de aplicações monolíticas ou baseadas em microserviços.
- Ao padronizar o ambiente de desenvolvimento local de uma equipe para evitar o problema de "funciona na minha máquina".
- Na otimização do tamanho de imagens (multi-stage builds) e correção de falhas de segurança em containers de produção.
- Ao orquestrar múltiplos serviços integrados (como API, banco de dados e cache) em um único comando usando Docker Compose.
- Na implementação de volumes persistentes e redes isoladas para comunicação interna segura entre os containers.

## 2. Stack Tecnológico e Implementação (Stack recomendado e dicas práticas de uso)
A stack principal recomendada e suas ferramentas incluem:
- **Tecnologias de Conteinerização**: Docker Engine, Docker Desktop, Podman.
- **Orquestração e Composição**: Docker Compose (V2), Docker Swarm, Kubernetes (para cenários mais amplos de produção).
- **Registro de Imagens**: Docker Hub, GitHub Container Registry (GHCR), Google Artifact Registry.

### Boas Práticas e Dicas Práticas:
- **Multi-stage Builds**: Separe o ambiente de compilação do ambiente de execução. Use imagens leves como `alpine` ou `distroless` para a etapa final, reduzindo a superfície de ataque e o tamanho da imagem final.
- **Usuários Não-Root**: Nunca execute a aplicação como usuário `root` dentro do container. Crie e use um usuário dedicado (ex: `USER node` ou `USER appuser`) no Dockerfile.
- **Gerenciamento de Segredos**: Evite passar senhas e chaves de API via variáveis de ambiente expostas no Dockerfile ou Compose. Use Docker Secrets ou arquivos `.env` ignorados no controle de versão (`.gitignore`).
- **Redes Isoladas**: Crie redes customizadas (`bridge`) no Docker Compose para que apenas os containers necessários consigam se comunicar entre si.
- **Ajuste de Cache de Camadas**: Ordene os comandos no Dockerfile copiando arquivos de dependência (como `package.json` ou `requirements.txt`) e rodando a instalação antes de copiar o restante do código-fonte. Isso acelera o processo de build.

## 3. Instrução de Inicialização (Prompt Starter / Prompt de inicialização detalhado)
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Docker e Docker Compose. Sua missão é me guiar na conteinerização de aplicações com eficiência, segurança e performance. Ao analisar meus Dockerfiles ou arquivos docker-compose.yml, sugira melhorias focadas em multi-stage builds, redução de tamanho das imagens, segurança com usuários não-root, isolamento de redes e gerenciamento adequado de volumes e segredos. Me ajude a depurar problemas de execução e a otimizar o build do meu ecossistema."
