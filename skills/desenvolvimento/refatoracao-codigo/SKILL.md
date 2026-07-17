---
name: refatoracao-codigo
description: Estratégias para refatorar código legado de forma segura e incremental sem quebrar funcionalidades existentes.
---

# Estratégias de Refatoração de Código e Correção de Legado

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill consolida metodologias clássicas de refatoração para melhorar o design interno do código (legibilidade, acoplamento e coesão) sem alterar seu comportamento externo observável. É baseada em conceitos consagrados por Martin Fowler e foca no uso de testes automatizados como rede de segurança essencial durante modificações estruturais.

### Quando usar:
- Quando o código se torna difícil de entender e caro para estender com novas funcionalidades.
- Antes de introduzir novas melhorias em uma área específica do sistema (refatoração preparatória).
- Para remover "code smells" (código duplicado, classes gigantes, métodos longos e parâmetros excessivos).
- Ao realizar a transição incremental de código legado não testado para uma estrutura moderna e modular.

## 2. Stack Tecnológico e Implementação
As técnicas de refatoração aplicam-se a qualquer stack de software, mas as ferramentas sugeridas para apoiar o processo são:
- **Ferramentas de Análise Estática**: Linters e analisadores de complexidade ciclomática (ex: SonarQube, ESLint, Pylint).
- **Rede de Segurança**: Frameworks de testes unitários rápidos e mock de dependências (ex: Jest, PyTest, JUnit).
- **IDE Integrada**: Suporte a refatorações automáticas seguras (ex: renomeação, extração de métodos).

### Padrões e Passos Práticos:
- **Refatoração por Passos de Bebê**: Faça pequenas alterações, rode os testes após cada modificação simples.
- **Extração de Método (Extract Method)**: Divida funções longas em funções menores com responsabilidade única.
- **Substituição de Algoritmo**: Simplifique blocos complexos reescrevendo-os de forma mais limpa após isolá-los.
- **Branch por Abstração**: Crie uma interface temporária para substituir componentes grandes de forma paralela.

## 3. Instrução de Inicialização
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Refatoração de Código e modernização de sistemas legados. Sua missão é me guiar na melhoria da qualidade interna de códigos sem alterar seu comportamento externo. Ao analisar meu código, identifique 'code smells' específicos (como complexidade ciclomática alta ou acoplamento excessivo) e sugira refatorações passo a passo. Priorize soluções seguras que mantenham o código testável. Sempre sugira como proteger a alteração por meio de testes unitários antes de realizar a modificação."
