---
name: desenvolvimento-backend-node
description: Criação de APIs backend performáticas com Node.js, Express e NestJS.
---

# Desenvolvimento Backend com Node.js

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define as melhores práticas para a criação de APIs RESTful e servidores backend performáticos, escaláveis e seguros usando Node.js. Ela aborda padrões de arquitetura corporativa (como Clean Architecture e MVC), modularização e integração segura com bancos de dados.

Use esta skill quando:
- Estiver desenvolvendo APIs backend, microsserviços ou sistemas de processamento assíncrono em JavaScript/TypeScript.
- For necessário configurar servidores web usando roteamento leve (Express) ou arquitetura modular estruturada (NestJS).
- Precisar implementar segurança básica (CORS, Helmet, Rate Limiting), autenticação (JWT) e autorização (RBAC).
- For integrar ORMs ou query builders para persistência e modelagem de dados.

## 2. Stack Tecnológico e Implementação
- **Runtime e Linguagem**: Node.js v18+ configurado com TypeScript estrito.
- **Frameworks**:
  - **NestJS**: Recomendado para aplicações de médio a grande porte que exigem injeção de dependência nativa e modularidade opinada.
  - **Express / Fastify**: Recomendado para microsserviços e APIs leves focadas em desempenho puro de I/O.
- **Segurança e Validação**:
  - Use Zod ou class-validator para validação rigorosa de payloads de entrada no nível de request.
  - Adote o middleware Helmet para proteção de headers HTTP e limite requisições com rate-limiters.
- **Banco de Dados & ORM**: Prisma ORM ou Kysely (para query builder tipado).
- **Dicas Práticas**:
  - Nunca deixe de tratar promessas rejeitadas (`unhandledRejection`). Utilize blocos try/catch ou middlewares globais de tratamento de erro.
  - Implemente logs estruturados (ex: Pino ou Winston) em vez de usar `console.log`.

## 3. Instrução de Inicialização
"Ative a skill de Desenvolvimento Backend com Node.js. Ao propor códigos de servidor ou APIs, use TypeScript estrito e prefira a arquitetura modular do NestJS ou a simplicidade limpa do Express/Fastify com rotas bem segmentadas. Implemente validação de entrada estrita via Zod e garanta tratamento global de erros. Todos os endpoints devem retornar códigos de status HTTP corretos e estruturar respostas padronizadas."
