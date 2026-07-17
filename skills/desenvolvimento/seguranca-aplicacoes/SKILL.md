---
name: seguranca-aplicacoes
description: Melhores práticas de desenvolvimento seguro em aplicações baseadas no OWASP Top 10 e criptografia básica.
---

# Melhores Práticas de Desenvolvimento Seguro de Aplicações

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece diretrizes essenciais para projetar e codificar aplicações seguras, defendendo o ecossistema contra as ameaças de segurança mais comuns. Baseia-se no padrão OWASP Top 10 (Open Worldwide Application Security Project) para ajudar no desenvolvimento de código resiliente a injeções, vazamento de credenciais e quebras de controle de acesso.

### Quando usar:
- Durante a fase de design de arquitetura de software para aplicar os princípios de "Secure by Design".
- Ao codificar sistemas de autenticação, controle de acessos (RBAC/ABAC) e rotinas de criptografia.
- Ao configurar a sanitização de entradas de usuários para prevenir ataques como SQL Injection e XSS.
- Em auditorias de segurança internas e preparação de testes de intrusão (Pentests).

## 2. Stack Tecnológico e Implementação
Embora a segurança dependa do comportamento de codificação, as ferramentas abaixo automatizam a prevenção:
- **Análise Estática de Segurança (SAST)**: SonarQube, Snyk, Semgrep (verificam vulnerabilidades no código).
- **Análise Dinâmica (DAST)**: OWASP ZAP (testa a aplicação em execução).
- **Gestão de Dependências (SCA)**: npm audit, pip-audit (identificam bibliotecas vulneráveis instaladas).
- **Criptografia e Segredos**: HashiCorp Vault, AWS Secrets Manager, uso de bibliotecas seguras como bcrypt e argon2.

### Medidas Práticas de Prevenção:
- **Sanitização e Validação**: Trate toda entrada vinda de fora da aplicação como não confiável. Use validadores fortes.
- **Consultas Parametrizadas**: Nunca concatene strings para montar queries SQL. Use ORMs ou Prepared Statements.
- **Menor Privilégio**: Conceda o nível mínimo de acesso necessário para usuários, serviços e processos.
- **Proteção de Segredos**: Nunca exponha chaves de API, senhas ou tokens no código-fonte. Utilize variáveis de ambiente.

## 3. Instrução de Inicialização
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Segurança de Aplicações e Práticas OWASP. Sua missão é me guiar na escrita de código seguro e livre de vulnerabilidades. Quando eu apresentar códigos ou arquiteturas de endpoints, avalie riscos de segurança como injeção de dados, falhas de autenticação, vazamento de segredos e controles de acesso quebrados. Sugira correções imediatas baseadas nas melhores práticas de mercado e padrões de criptografia modernos."
