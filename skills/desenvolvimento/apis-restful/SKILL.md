---
name: apis-restful
description: Padrões de design de APIs RESTful, versionamento, status HTTP, HATEOAS e tratamento padronizado de erros.
---

# Padrões de Design e Implementação de APIs RESTful

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece diretrizes estruturadas para o design e desenvolvimento de APIs baseadas no modelo REST (Representational State Transfer). Focamos nos níveis do Modelo de Maturidade de Richardson (Richardson Maturity Model), garantindo que as interfaces de integração sejam intuitivas, escaláveis, fáceis de documentar e seguras para consumo por múltiplos clients.

### Quando usar:
- Ao projetar novos endpoints ou desenhar a arquitetura de comunicação entre serviços e microserviços.
- Na definição de estratégias de versionamento de rotas e migração de versões antigas sem quebra de contrato.
- Ao estruturar uma camada global e padronizada de captura e tratamento de erros no backend.
- Para orientar a equipe sobre a especificação correta de recursos técnicos utilizando o formato OpenAPI.

## 2. Stack Tecnológico e Implementação
Embora o protocolo HTTP seja a base comum para APIs RESTful, a implementação e validação utilizam:
- **Frameworks Web**: Express/NestJS (Node.js), FastAPI/Flask (Python), Spring Boot (Java), ASP.NET Core (.NET).
- **Especificação e Testes**: OpenAPI Spec (Swagger), Postman, Insomnia.
- **Segurança de APIs**: OAuth2, JWT (JSON Web Tokens), middlewares de CORS e Rate Limiting.

### Padrões Práticos de Design:
- **Modelagem de Recursos**: Utilize substantivos no plural para rotas (ex: `/api/v1/fornecedores`) e verbos HTTP adequados (GET para ler, POST para criar, PUT/PATCH para atualizar, DELETE para remover).
- **Status HTTP Semânticos**: Use códigos padrão do protocolo (200 OK, 201 Created, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 422 Unprocessable Entity, 500 Internal Server Error).
- **Tratamento de Erros Padronizado**: Retorne respostas de erro consistentes no formato JSON contendo campos como timestamp, message, error e status code (ex. baseado na RFC 7807 - Problem Details).
- **Versionamento Claro**: Prefira versionar na URL (ex: `/v1/`) ou via Headers HTTP customizados para garantir previsibilidade.

## 3. Instrução de Inicialização
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Design e Arquitetura de APIs RESTful. Sua missão é me guiar na criação de endpoints limpos, padronizados e aderentes ao protocolo HTTP. Ao analisar minhas rotas ou propostas de integração, sugira nomes de recursos semânticos, códigos de status HTTP corretos e um tratamento adequado de erros e paginação. Me ajude a documentar os endpoints no padrão OpenAPI/Swagger."
