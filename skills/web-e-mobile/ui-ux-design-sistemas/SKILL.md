---
name: ui-ux-design-sistemas
description: Padrões de design de interfaces, criação de Design Systems e componentes acessíveis.
---

# UI/UX e Design Systems

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece as diretrizes para a criação de interfaces de usuário consistentes, esteticamente agradáveis e, acima de tudo, acessíveis (em conformidade com WCAG). Ela foca no desenvolvimento de Design Systems escaláveis, estruturação de tokens de design e componentes modulares reutilizáveis.

Use esta skill quando:
- For projetar ou codificar componentes reutilizáveis de interface (como botões, modais, inputs e dropdowns).
- Precisar implementar acessibilidade (a11y) rigorosa, incluindo suporte para leitores de tela e navegação por teclado completa.
- Estiver estruturando ou integrando bibliotecas de design headless com estilos utilitários.
- Precisar padronizar cores, tipografia, espaçamento e sombras em um projeto (design tokens).

## 2. Stack Tecnológico e Implementação
- **Componentes Headless**: Radix UI, Headless UI ou React Aria. Eles fornecem a lógica de comportamento e acessibilidade sem estilização predefinida.
- **Estilização e Tokens**: Tailwind CSS para aplicação de estilos utilitários acoplados aos design tokens definidos no arquivo `tailwind.config.js`.
- **Acessibilidade (WCAG)**:
  - Use atributos `aria-*` apropriados, como `aria-expanded`, `aria-haspopup` e `aria-controls`.
  - Garanta contraste de cor adequado (mínimo de 4.5:1 para texto normal) e marcação semântica correta.
  - Teste a focabilidade e o fluxo de tabulação (gerenciamento de foco ao abrir modais).
- **Dicas Práticas**:
  - Centralize tokens de design em variáveis CSS ou configurações do Tailwind para facilitar mudanças globais de tema (ex: modo escuro).
  - Use ferramentas de linting como `eslint-plugin-jsx-a11y` para pegar erros comuns de acessibilidade em tempo de desenvolvimento.

## 3. Instrução de Inicialização
"Ative a skill de UI/UX e Design Systems. Ao criar componentes de interface, use componentes headless (ex: Radix UI) como base para assegurar conformidade com as especificações WAI-ARIA. Aplique estilos de forma modular e baseada em design tokens definidos via Tailwind CSS. Escreva componentes totalmente operáveis por teclado e com bom contraste visual. Explique as considerações de acessibilidade incorporadas ao componente proposto."
