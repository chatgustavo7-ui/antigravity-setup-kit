---
name: desenvolvimento-react
description: Construção de interfaces de usuário reativas usando React, Next.js e hooks avançados.
---

# Desenvolvimento React e Next.js

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill orienta o desenvolvimento de aplicações frontend modernas e robustas utilizando a biblioteca React e o framework Next.js. Ela fornece diretrizes para a criação de componentes modulares, legíveis, reutilizáveis e com alto desempenho, além de boas práticas para renderização no lado do servidor (SSR), geração de site estático (SSG) e componentes do lado do servidor (React Server Components - RSC).

Use esta skill quando:
- Estiver iniciando ou mantendo projetos web que exigem interfaces interativas e reativas.
- For necessário configurar rotas dinâmicas, otimização de imagens, ou renderização híbrida usando Next.js App Router.
- For preciso otimizar a renderização de componentes React, evitar rerenderizações desnecessárias e aplicar hooks customizados.
- Quiser implementar padrões limpos de estruturação de projetos frontend em equipes de qualquer tamanho.

## 2. Stack Tecnológico e Implementação
- **React 18/19 & Next.js (App Router)**: Padrão principal de arquitetura web para interfaces dinâmicas e roteamento avançado.
- **TypeScript**: Tipagem estática estrita para todas as props de componentes, estados e retornos de funções/hooks.
- **Hooks Nativos e Avançados**: Uso correto de `useState`, `useEffect` (com limpeza adequada), `useMemo`, `useCallback`, `useRef` e `useTransition` para transições de estado não bloqueantes.
- **Tailwind CSS**: Estilização baseada em classes utilitárias para interfaces modernas e responsivas.
- **Dicas Práticas**:
  - Prefira React Server Components (RSC) por padrão e use `'use client'` apenas quando houver interatividade direta ou uso de hooks de estado.
  - Implemente tratamento de erros com Error Boundaries locais e carregamento progressivo com Suspense e arquivos `loading.tsx`.
  - Evite passar dados profundos por props; utilize a API Context apenas para dados globais de pouca mutação.
  - Configure lazy loading de componentes pesados que não são necessários no carregamento inicial da página.

## 3. Instrução de Inicialização
"Ative a skill de Desenvolvimento React. Sempre que o usuário solicitar a criação de componentes ou páginas, utilize TypeScript com tipagens estritas para props e retornos. Escreva componentes funcionais limpos, utilizando hooks avançados de forma correta e sem vazamentos de memória. Siga a arquitetura de pastas do Next.js App Router. Garanta que a acessibilidade (tags semânticas, atributos ARIA e navegação por teclado) esteja integrada e forneça um exemplo de teste unitário utilizando Jest ou Vitest com React Testing Library."
