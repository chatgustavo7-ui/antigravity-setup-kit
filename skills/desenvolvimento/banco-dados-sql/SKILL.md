---
name: banco-dados-sql
description: Design de esquemas relacionais, indexação, normalização e otimização de queries SQL.
---

# Design de Banco de Dados Relacional e Otimização de SQL

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece diretrizes para projetar modelos relacionais robustos e otimizar a performance de consultas SQL. Ela aborda as regras de normalização de banco de dados, design eficiente de índices (como B-Tree e índices compostos), análise de planos de execução de queries (EXPLAIN) e prevenção de problemas clássicos como N+1 queries.

### Quando usar:
- Ao criar novas tabelas e estruturar o relacionamento de dados de uma nova funcionalidade.
- Quando consultas SQL começam a apresentar lentidão à medida que o volume de registros na tabela cresce.
- Durante o processo de migração ou evolução de esquemas relacionais (Schema Migrations).
- Ao configurar a camada de persistência de dados de ORMs para garantir transações seguras.

## 2. Stack Tecnológico e Implementação
Embora o SQL clássico seja universal, a skill foca nos motores de banco de dados mais comuns:
- **SGBDs Relacionais**: PostgreSQL, MySQL/MariaDB, SQLite (para backend de apps), Microsoft SQL Server.
- **Ferramentas de Migração e Modelagem**: Flyway, Liquibase, Prisma Migrations, pgAdmin, DBeaver.
- **Análise de Performance**: Comandos de inspeção interna como `EXPLAIN ANALYZE` (PostgreSQL/MySQL).

### Boas Práticas de Design e Otimização:
- **Normalização e Desnormalização Consciente**: Desenhe tabelas até a 3ª Forma Normal (3FN). Desnormalize apenas se houver necessidade justificada de performance para relatórios.
- **Estratégia de Índices**: Indexe chaves estrangeiras (Foreign Keys) e colunas usadas frequentemente em cláusulas WHERE, JOIN e ORDER BY. Evite indexar em excesso para não penalizar operações de escrita (INSERT/UPDATE).
- **Evitar N+1 Queries**: Ao carregar dados relacionados em ORMs, utilize cargas antecipadas (Eager Loading/JOINs) em vez de Lazy Loading recursivo.
- **Paginação de Dados**: Prefira paginação baseada em chaves ou cursor (Keyset Pagination) a offsets grandes que forçam scan completo na tabela.

## 3. Instrução de Inicialização
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Bancos de Dados Relacionais e Otimização de SQL. Sua missão é me apoiar na modelagem de tabelas e otimização de consultas. Ao analisar esquemas de banco de dados ou instruções SELECT complexas que eu apresentar, sugira índices eficazes, correções de normalização e analise possíveis problemas de performance com base no EXPLAIN. Dê prioridade a queries parametrizadas e transações seguras com níveis de isolamento adequados."
