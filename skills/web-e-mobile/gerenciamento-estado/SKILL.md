---
name: gerenciamento-estado
description: Arquitetura e uso de bibliotecas de gerenciamento de estado global como Zustand e Redux.
---

# Gerenciamento de Estado Global

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill orienta a arquitetura e estruturação do fluxo de dados e estado em aplicações complexas de frontend. Ela ajuda a definir quando usar estado local, estado compartilhado via contextos, ou quando recorrer a bibliotecas de estado global robustas, evitando problemas de desempenho, propagação ineficiente de dados (prop drilling) e rerenderizações desnecessárias.

Use esta skill quando:
- A aplicação possuir fluxos de dados complexos que precisam ser acessados por muitos componentes distantes na árvore.
- For necessário persistir estados localmente (ex: carrinho de compras, preferências do usuário, tokens de autenticação).
- Tiver que implementar fluxos de ações assíncronas (side-effects) complexas integradas ao estado global.
- Estiver refatorando código legado com contextos inflados que prejudicam a performance da renderização.

## 2. Stack Tecnológico e Implementação
- **Zustand**: Biblioteca leve, rápida e baseada em hooks. Ideal para a maioria dos projetos modernos pela simplicidade e ausência de boilerplate.
  - Crie stores pequenas e focadas, utilizando seletores (`const user = useUserStore(state => state.user)`) para prevenir renderizações desnecessárias.
- **Redux Toolkit (RTK)**: Solução corporativa opinada e robusta. Indicada para grandes sistemas com fluxos complexos de mutação de dados.
  - Utilize `createSlice` para definir reducers e actions simultaneamente.
  - Gerencie chamadas assíncronas e cache com RTK Query.
- **Dicas Práticas**:
  - Separe estritamente o estado do servidor (gerenciado por React Query ou RTK Query) do estado do cliente (UI, modais, etc.).
  - Mantenha o estado o mais normalizado e plano possível.
  - Implemente middlewares para persistência (`persist` no Zustand) de forma segura.

## 3. Instrução de Inicialização
"Ative a skill de Gerenciamento de Estado Global. Quando for solicitado a criar soluções de fluxo de dados ou persistência, proponha Zustand para casos leves/médios ou Redux Toolkit para aplicações enterprise complexas. Sempre utilize seletores estritos para otimizar as renderizações. Forneça exemplos práticos de stores/slices tipadas com TypeScript, incluindo testes para validar as transições de estado (reducers/actions)."
