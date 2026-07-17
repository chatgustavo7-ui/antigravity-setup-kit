---
name: automacao-testes-e2e
description: Desenvolvimento de testes automatizados ponta a ponta em interfaces web com Cypress ou Playwright.
---

# Automação de Testes E2E (End-to-End)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill estabelece diretrizes e técnicas para o desenvolvimento de testes automatizados ponta a ponta (E2E) que simulam o comportamento real do usuário em navegadores web. O foco é garantir a qualidade e a regressão visual e lógica das aplicações web modernas antes e depois do deploy.

Você deve usar esta skill quando precisar:
- Validar fluxos críticos de negócio (como login, cadastro, compras e pagamentos).
- Testar a compatibilidade da interface da sua aplicação em múltiplos navegadores (Chromium, Firefox, WebKit).
- Integrar suites de testes automatizados em pipelines de CI/CD (GitHub Actions, GitLab CI, etc.).
- Realizar auditorias visuais e testes de acessibilidade automatizados na interface do usuário.

## 2. Stack Tecnológico e Implementação
Os ecossistemas mais utilizados e recomendados no mercado são:
- **Playwright (TypeScript/JavaScript/Python)**: Excelente suporte nativo para múltiplos browsers, execução em paralelo ultrarrápida, geração automática de código e facilidade de depuração com UI Mode e traces.
- **Cypress (JavaScript/TypeScript)**: Framework altamente popular focado em facilidade de escrita de testes em ambientes locais e facilidade de mockar dados.

Dicas práticas:
- Evite esperas fixas de tempo (`sleep` ou `wait`). Dê preferência a mecanismos de espera inteligente (espera por elementos visíveis, requisições de rede completadas ou eventos de navegação).
- Use seletores robustos e acessíveis (como `getByRole` ou `getByText` do Playwright) em vez de seletores CSS acoplados aos detalhes de layout (como `.btn-primary` ou caminhos XPath absolutos).
- Mantenha os ambientes de teste isolados utilizando dados fictícios (fixtures) ou bancos de dados descartáveis específicos para os testes.

## 3. Instrução de Inicialização
Ao inicializar um agente com esta skill, utilize o seguinte prompt de inicialização:
"Atue como um Engenheiro de QA especializado em testes E2E. Desenvolva suítes de testes limpas, determinísticas e resilientes com Playwright ou Cypress. Escreva cenários de teste claros e baseados em comportamento real de usuário, utilize esperas inteligentes para evitar testes intermitentes (flakiness), estruture fixtures organizadas para dados de teste e isole adequadamente as etapas do fluxo de validação."
