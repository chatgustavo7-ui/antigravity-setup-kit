---
name: pipelines-ci-cd
description: Desenvolvimento de fluxos automatizados de testes, build e entrega contínua com GitHub Actions.
---

# Fluxos de Integração e Entrega Contínua (CI/CD)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill estabelece diretrizes e práticas estruturadas para o desenvolvimento de pipelines de Integração Contínua (CI) e Entrega Contínua (CD) usando o GitHub Actions. O objetivo é garantir que toda alteração de código passe por validações automáticas de sintaxe, testes unitários, testes de integração e análise de segurança (linters) antes de ser integrada e disponibilizada em produção.

### Quando usar:
- Ao automatizar a execução de suítes de testes unitários e de integração em pull requests.
- Na automação de builds de imagens Docker e deploy automático em plataformas como Vercel, Heroku, AWS ou Google Cloud.
- Ao implementar verificações estáticas de código (linters, formatadores e segurança de dependências) no ciclo de desenvolvimento.
- Para gerenciar as estratégias de versionamento automático de pacotes e lançamentos (releases).
- Ao definir fluxos de aprovação obrigatórios ou gates de qualidade para mesclar código em branches protegidas.

## 2. Stack Tecnológico e Implementação (Stack recomendado e dicas práticas de uso)
A stack e as integrações recomendadas para automação incluem:
- **Plataformas de CI/CD**: GitHub Actions (foco principal), GitLab CI/CD, Jenkins.
- **Segurança e Qualidade**: SonarQube, Trivy (varredura de imagens), Dependabot / Snyk.
- **Deploy**: Vercel CLI, AWS CLI, gcloud SDK.

### Boas Práticas e Dicas Práticas:
- **Uso de Caching**: Utilize etapas de cache no GitHub Actions (como `actions/cache`) para dependências de pacotes (npm, pip, cargo) e para o cache do gerenciador de pacotes para acelerar as execuções dos jobs.
- **Tratamento de Segredos**: Armazene tokens de acesso, chaves de API e credenciais de nuvem em GitHub Secrets. Nunca exponha valores em texto puro nos arquivos YAML do workflow.
- **Segurança de Menor Privilégio**: Configure as permissões dos jobs explicitamente usando o bloco `permissions` no arquivo YAML (ex: `contents: read`, `packages: write`), evitando dar permissão total de gravação sem necessidade.
- **Estratégia de Matrix**: Utilize a funcionalidade `matrix` para testar sua aplicação em diferentes versões de runtime (ex: Node.js 18, 20 e 22) e diferentes sistemas operacionais de runner.
- **Deploy Seguro com OIDC**: Em nuvens como AWS ou GCP, dê preferência ao OpenID Connect (OIDC) em vez de persistir chaves de acesso de longo prazo como secrets do GitHub.

## 3. Instrução de Inicialização (Prompt Starter / Prompt de inicialização detalhado)
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em pipelines de CI/CD com GitHub Actions. Sua missão é me apoiar na automação dos meus processos de testes, validação e deploy. Ao analisar meus arquivos de workflow (.github/workflows/*.yml), sugira otimizações de cache para acelerar os pipelines, estratégias seguras para tratamento de segredos, modularização através de actions reutilizáveis e parametrização correta de jobs. Me ajude a depurar erros de CI/CD e a desenhar esteiras robustas."
