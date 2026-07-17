---
name: web-scraping
description: Extração robusta de dados públicos de portais web usando frameworks como BeautifulSoup, Selenium ou Playwright.
---

# Extração de Dados Web (Web Scraping)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece metodologias, boas práticas e estratégias para a extração robusta de informações de páginas e portais web. Ela abrange desde páginas estáticas simples até aplicações web complexas, dinâmicas e baseadas em JavaScript de página única (SPAs).

Você deve usar esta skill quando precisar:
- Coletar informações públicas e dados estruturados para análise ou relatórios.
- Interagir com formulários web, realizar login automatizado e navegar por catálogos.
- Monitorar mudanças de preços, disponibilidade de produtos ou atualizações em páginas governamentais.
- Fazer download em lote de documentos, mídias ou relatórios publicados online.

## 2. Stack Tecnológico e Implementação
Os frameworks e ferramentas recomendados variam de acordo com a complexidade do site:
- **BeautifulSoup4 & requests**: Recomendado para páginas estáticas, onde a velocidade e a economia de recursos são essenciais.
- **Playwright (Python/Node.js)**: Ideal para SPAs dinâmicas que requerem renderização de JavaScript, execução paralela rápida e modo headless robusto.
- **Selenium**: Alternativa madura para simular cliques complexos, arrastar elementos e interações com browsers legados.

Dicas práticas:
- Respeite as políticas e termos de uso do site alvo. Verifique sempre o arquivo `/robots.txt` para entender os limites de varredura.
- Utilize cabeçalhos HTTP adequados (como `User-Agent` realista) e introduza atrasos aleatórios entre as requisições para evitar bloqueios de IP e sobrecarga no servidor de destino.
- Estruture a lógica de busca usando seletores CSS ou XPath resilientes que não quebrem facilmente com pequenas alterações estruturais do HTML.

## 3. Instrução de Inicialização
Ao inicializar um agente com esta skill, utilize o seguinte prompt de inicialização:
"Atue como um engenheiro de dados especializado em Web Scraping. Projete soluções limpas e resilientes para extração de dados públicos da internet. Use BeautifulSoup para sites estáticos e rápidos, ou Playwright para páginas ricas em JavaScript. Implemente estratégias defensivas como tratamento de falhas de rede, detecção de carregamento lento de seletores, simulação de comportamento humano e exportação organizada de dados em JSON ou CSV."
