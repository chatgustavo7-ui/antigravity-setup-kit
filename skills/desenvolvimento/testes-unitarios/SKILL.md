---
name: testes-unitarios
description: Práticas para escrita de testes unitários eficientes, gerenciamento de mocks e análise de cobertura de código.
---

# Práticas de Testes Unitários e Qualidade de Código

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define as melhores práticas para a criação de testes de unidade eficientes, focados em testar o comportamento isolado de componentes e funções. Ela ensina a balancear a fidelidade do teste com a velocidade de execução, utilizando padrões de mocking para isolamento de I/O e serviços de infraestrutura de forma correta e sem fragilidades.

### Quando usar:
- Ao escrever novas regras de negócio e funcionalidades para assegurar sua corretude desde a concepção (TDD).
- Na criação de pipelines de Integração Contínua (CI) para validar regressões automaticamente.
- Para verificar casos de borda e entradas inválidas que poderiam gerar exceções inesperadas em produção.
- Ao monitorar e otimizar a cobertura de código (code coverage) de projetos de software.

## 2. Stack Tecnológico e Implementação
As ferramentas variam por stack de desenvolvimento, mas os principais padrões operam com:
- **Frameworks de Teste**: Jest/Vitest (JavaScript/TypeScript), PyTest (Python), JUnit (Java), xUnit (.NET).
- **Mocks e Stubs**: Sinon.js, unittest.mock, ou ferramentas nativas do framework de escolha.
- **Relatórios de Cobertura**: Istanbul/Nyc, Coverage.py, Jacoco.

### Princípios para Testes Saudáveis:
- **Padrão AAA (Arrange, Act, Assert)**: Estruture o teste configurando o cenário, executando a ação e avaliando o resultado.
- **Foco no Comportamento**: Teste o comportamento público de um componente, não seus detalhes de implementação interna.
- **Isolamento Total**: Mantenha testes de unidade sem chamadas reais de rede, banco de dados ou arquivos do disco.
- **Evite Over-Mocking**: Mocke apenas dependências de infraestrutura e serviços externos. Entidades puras e helpers não devem ser mockados.

## 3. Instrução de Inicialização
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Testes Unitários e Engenharia de Qualidade. Sua missão é me apoiar na escrita de testes robustos, isolados e rápidos. Quando eu apresentar uma função ou classe, escreva cenários de testes unitários baseados no padrão Arrange-Act-Assert. Inclua testes para caminhos felizes, valores de borda e tratamento de erros. Ensine-me a mockar dependências de I/O corretamente e me ajude a analisar e melhorar os relatórios de cobertura de código."
