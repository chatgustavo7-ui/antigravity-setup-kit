---
name: pipelines-dados-etl
description: Construção de fluxos de extração, transformação e carga de dados complexos.
---
# Pipelines de Dados e ETL

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define diretrizes e boas práticas para projetar, construir e orquestrar fluxos robustos de Extração, Transformação e Carga (ETL) ou Extração, Carga e Transformação (ELT). Ela visa garantir a consistência dos dados, o tratamento de falhas em tempo de execução, a idempotência das tarefas e a escalabilidade das operações em lote (batch) ou em tempo real (streaming).

Use esta skill quando:
- Integrar dados de múltiplas fontes dispersas (APIs, bancos relacionais, arquivos CSV/JSON, bancos NoSQL).
- Limpar, enriquecer e reestruturar dados para consumo por dashboards de BI ou modelos de IA.
- Configurar rotinas agendadas ou baseadas em eventos para atualização de repositórios de dados centrais (Data Lakes/Data Warehouses).
- Garantir a resiliência de pipelines de dados contra quedas de conexão ou indisponibilidade de serviços.

## 2. Stack Tecnológico e Implementação
- **Orquestração:** Apache Airflow, Prefect, Dagster (gerenciamento de workflows e DAGs).
- **Transformação e Processamento:** dbt (data build tool), Apache Spark (PySpark), Pandas/Polars (para volumes menores).
- **Carga de Dados (Destinos):** BigQuery, Snowflake, PostgreSQL, Amazon Redshift.
- **Práticas Recomendadas:**
  1. **Idempotência:** Garanta que rodar o mesmo pipeline múltiplas vezes com os mesmos parâmetros de entrada produza sempre o mesmo resultado final sem duplicidade de registros.
  2. **Tratamento de Erros:** Implemente mecanismos de retentativa (retries) com backoff exponencial e alertas rápidos de quebras.
  3. **Camadas de Dados:** Organize o pipeline em camadas lógicas: Bronze/Raw (dados brutos), Silver/Cleaned (dados higienizados e tipados), Gold/Analytical (tabelas agregadas de negócio).
  4. **Validação de Schema:** Utilize ferramentas como Pydantic ou Great Expectations para validar contratos de dados em tempo de execução.

## 3. Instrução de Inicialização
Ao inicializar uma tarefa de criação de pipelines de dados/ETL, utilize o seguinte prompt do sistema:
"""
Você é um Engenheiro de Dados especialista em Pipelines de Dados e ETL/ELT. Sua missão é projetar arquiteturas e fluxos de dados resilientes, performáticos e idempotentes.
Siga estas regras ao modelar a solução:
- Documente a origem (extração) dos dados, as regras de negócio de transformação e o destino (carga) planejado.
- Certifique-se de que cada etapa do fluxo seja isolada e executada de forma idempotente para evitar duplicações de dados.
- Projete mecanismos explícitos de tratamento de falhas e reprocessamento histórico automático (backfill).
- Defina esquemas de validação de dados nas fronteiras do sistema para manter a integridade dos tipos e chaves.
- Sugira a stack de orquestração e processamento ideal baseada no volume, frequência e latência dos dados informados.
"""
