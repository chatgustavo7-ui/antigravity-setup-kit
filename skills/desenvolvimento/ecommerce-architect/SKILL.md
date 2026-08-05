---
name: ecommerce-architect
description: Especialista em Arquitetura de E-commerce (Headless, Modular, Monolítico). Fornece referências e prompts de inicialização para projetos de e-commerce.
---

# Diretiva de E-Commerce e Referências de Arquitetura

Sempre que iniciar um projeto de e-commerce ou arquitetura complexa, utilize as referências abaixo para guiar o design do sistema, a estrutura do banco de dados e as integrações.

## 1. Referências de Arquitetura Moderna (Headless & Modular)
*Estes sistemas separam o Front-end do Back-end, sendo ideais para projetos escaláveis.*

### MedusaJS
- **Foco:** Alternativa open-source ao Shopify (Node.js/TypeScript).
- **Ação da IA (Prompt de Estudo):** Ao modelar integrações de pagamento e gestão de pedidos, analise a estrutura de Plugins e o Motor de Checkout do MedusaJS e compare com a arquitetura atual do projeto.

### Saleor
- **Foco:** E-commerce de altíssima potência construído em Python (Django/GraphQL).
- **Ação da IA (Prompt de Estudo):** Analise a estrutura de dados (Schema) do Saleor para produtos e variantes. Eles são referência em como gerenciar variantes complexas de produtos (ex: tamanho, tipo, cor).

### Vendure
- **Foco:** Performance extrema e arquitetura modular, também em TypeScript.
- **Ação da IA (Prompt de Estudo):** Explique e baseie-se em como o Vendure lida com "Administração de Permissões" (RBAC - Role Based Access Control), vital para a segurança e arquitetura do painel de gestão.

## 2. Referências de Ecossistema (Monolíticos & Plugins)
*Estes são os "gigantes" que possuem as integrações com Mercado Pago e ERPs mais testadas do mundo. A lógica de como conectam com APIs externas é ouro, mesmo para soluções customizadas.*

### WooCommerce
- **Foco:** O padrão da indústria (PHP/WordPress). O ecossistema de plugins de pagamento (Mercado Pago, Vindi, Pagar.me) é imbatível.
- **Ação da IA (Prompt de Estudo):** Analise como o WooCommerce estruturou os Webhooks para notificar o sistema quando um pagamento é aprovado no Mercado Pago.

### PrestaShop
- **Foco:** Muito popular na Europa e América Latina, focado exclusivamente em e-commerce tradicional.
- **Ação da IA (Prompt de Estudo):** Analise como o PrestaShop gerencia Regras de Frete e Promoções (ex: frete grátis acima de X reais).

## 3. Instrução de Inicialização (Prompt Starter)
Sempre que o usuário solicitar o início ou a modelagem de um projeto de E-Commerce, siga este fluxo:
1. **Analise o Domínio:** Identifique se o foco atual é modelagem de produto (recorrer ao Saleor), checkout/pagamento (MedusaJS/WooCommerce), permissões (Vendure) ou promoções (PrestaShop).
2. **Proponha a Arquitetura:** Apresente um plano (via `create-plan`) demonstrando como os conceitos dessas referências serão implementados no stack local.
3. **Execute:** Construa os schemas e integre os webhooks de acordo com as melhores práticas extraídas dessas plataformas.
