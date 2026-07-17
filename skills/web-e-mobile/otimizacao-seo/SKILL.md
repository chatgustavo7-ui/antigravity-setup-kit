---
name: otimizacao-seo
description: Melhores práticas de SEO técnico, marcação semântica e auditorias com Lighthouse.
---

# Otimização de SEO Técnico

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece as diretrizes essenciais para garantir que páginas web sejam facilmente indexáveis, interpretáveis por rastreadores de motores de busca (como o Googlebot) e otimizadas para compartilhamento em redes sociais. Ela aborda desde a estruturação semântica do HTML até metadados estruturados (JSON-LD) e auditorias de desempenho e acessibilidade.

Use esta skill quando:
- Estiver desenvolvendo páginas públicas que precisam obter tráfego orgânico alto em mecanismos de busca.
- For necessário configurar tags Open Graph (OG), Twitter Cards e esquemas estruturados.
- Precisar preparar ou otimizar o site para auditorias do Google Lighthouse e atingir notas próximas a 100 em SEO e Boas Práticas.
- Tiver que corrigir problemas de indexação, URLs amigáveis, redirecionamentos e renderização dinâmica.
- For planejar a hierarquia estrutural de conteúdo de um novo website ou portal.

## 2. Stack Tecnológico e Implementação
- **HTML5 Semântico**: Utilização correta de tags estruturais como `<main>`, `<article>`, `<section>`, `<nav>`, `<header>`, `<footer>` e níveis hierárquicos corretos de títulos (`<h1>` a `<h6>`).
- **Next-SEO ou Meta Tags nativas**: Configuração dinâmica de metatítulos, metadescrições e tags canônicas únicas por página.
- **JSON-LD (Structured Data)**: Inclusão de scripts contendo Schema.org para enriquecimento dos resultados de busca (Rich Snippets).
- **Sitemaps e Robots**: Gerenciamento de arquivos `sitemap.xml` dinâmicos e regras de restrição de rastreamento em `robots.txt`.
- **Dicas Práticas**:
  - Garanta que todas as imagens possuam o atributo `alt` descritivo e que links tenham textos âncora claros (evite "clique aqui").
  - Monitore constantemente o Core Web Vitals (LCP, FID/INP, CLS) pois a experiência de página impacta o ranqueamento.
  - Utilize ferramentas como Google Search Console para validar o rastreamento e indexação.

## 3. Instrução de Inicialização
"Ative a skill de Otimização de SEO Técnico. Ao analisar ou criar código HTML ou componentes frontend, exija marcação estritamente semântica e acessível. Configure tags dinâmicas de metadados, links canônicos e suporte para compartilhamento social (Open Graph). Sempre que relevante, incorpore dados estruturados JSON-LD. Explique quais práticas de otimização foram implementadas no código gerado e sugira como testá-lo usando o Google Lighthouse."
