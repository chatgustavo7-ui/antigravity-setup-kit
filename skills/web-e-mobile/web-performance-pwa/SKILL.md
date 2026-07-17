---
name: web-performance-pwa
description: Otimização de carregamento de páginas web, service workers e Progressive Web Apps.
---

# Web Performance e PWA

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill visa acelerar o carregamento de aplicações web e transformá-las em Progressive Web Apps (PWAs) de alta qualidade. Ela estabelece regras de caching avançado, estratégias de carregamento de ativos (assets) críticos, divisão de código (code-splitting) e instalação offline para garantir uma experiência de usuário fluida e responsiva sob qualquer condição de rede.

Use esta skill quando:
- For necessário reduzir métricas de tempo de carregamento como First Contentful Paint (FCP) e Largest Contentful Paint (LCP).
- Precisar habilitar suporte offline ou funcionalidade de instalação local de um site em dispositivos móveis e desktops.
- Quiser implementar estratégias de Service Workers (como Cache-First, Network-First ou Stale-While-Revalidate).
- Estiver otimizando bundles de script grandes para evitar bloqueios na thread principal.

## 2. Stack Tecnológico e Implementação
- **Service Workers & Workbox**: Biblioteca de referência do Google para escrita simplificada de rotas de cache e suporte offline.
- **Web App Manifest (`manifest.json`)**: Configuração necessária para tornar a aplicação instalável, definindo ícones, cores de tema, orientação e escopo.
- **Técnicas de Performance**:
  - **Code-Splitting / Dynamic Imports**: Carregamento sob demanda de componentes secundários (usando `React.lazy` ou imports dinâmicos do Next.js).
  - **Otimização de Imagens**: Uso de formatos modernos (WebP/AVIF), dimensionamento correto (`srcset`) e lazy-loading nativo (`loading="lazy"`).
  - **Pre-fetching e Pre-rendering**: Carregamento antecipado de páginas e recursos essenciais.
- **Dicas Práticas**:
  - Monitore o peso total do bundle com pacotes como `webpack-bundle-analyzer` ou ferramentas do Vite.
  - Certifique-se de configurar cabeçalhos Cache-Control adequados nas respostas da CDN.

## 3. Instrução de Inicialização
"Ative a skill de Web Performance e PWA. Ao projetar ou otimizar sites, priorize a redução do tamanho de scripts e imagens. Implemente estratégias de code-splitting e use a biblioteca Workbox para configurar Service Workers focados em resiliência offline e carregamento instantâneo de recursos frequentes. Garanta que o manifest.json esteja corretamente estruturado para que a aplicação seja considerada instalável."
