---
name: banco-dados-vetoriais
description: Implementação de busca semântica, embeddings e gerenciamento de bancos vetoriais.
---
# Bancos de Dados Vetoriais e Busca Semântica

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define as melhores práticas para a criação de pipelines de busca semântica usando representações vetoriais de dados (embeddings) e armazenamento em bancos de dados vetoriais dedicados. Ela é essencial para habilitar sistemas de busca inteligente, recomendação, deduplicação de conteúdo e suporte a arquiteturas de Geração Aumentada de Recuperação (RAG).

Use esta skill quando:
- Construir sistemas de RAG para enriquecer o contexto de LLMs com documentos externos relevantes.
- Desenvolver motores de busca que dependem da semântica (significado) da pesquisa do usuário, e não apenas de palavras-chave exatas.
- Gerenciar grandes conjuntos de vetores de alta dimensionalidade em produção que requerem busca por vizinhos mais próximos rápida (ANN).
- Implementar recomendação de produtos ou textos com base na similaridade de seus embeddings.

## 2. Stack Tecnológico e Implementação
- **Modelos de Embedding Recomendados:** text-embedding-3 (OpenAI), Cohere Embed, BGE-large, Hugging Face SentenceTransformers (para execução local).
- **Motores de Busca Vetorial:** Pinecone (gerenciado), ChromaDB (local e leve), Qdrant (robusto e de alta performance), pgvector (extensão PostgreSQL), Milvus (escala de grandes volumes).
- **Métricas de Similaridade Comuns:**
  1. *Cosine Similarity (Similaridade de Cosseno):* Ideal para normalização automática de tamanho do texto.
  2. *Dot Product (Produto Escalar):* Recomendado se os vetores já forem unitários/normalizados (mais rápido).
  3. *Euclidean Distance (Distância Euclidiana / L2):* Mede a distância espacial física absoluta.
- **Dicas Práticas:**
  - Escolha o tamanho do Chunk (ex: 500 tokens) e Overlap (ex: 50 tokens) de forma equilibrada para não perder o contexto semântico.
  - Mantenha metadados (metadata filtering) estruturados associados a cada vetor para filtrar os resultados da busca vetorial antes ou depois do cálculo de similaridade (ex: filtragem por data ou categoria).

## 3. Instrução de Inicialização
Ao inicializar uma tarefa relacionada a bancos de dados vetoriais ou busca semântica, utilize o seguinte prompt do sistema:
"""
Você é um Arquiteto de Sistemas de IA especialista em Busca Semântica e Bancos de Dados Vetoriais. Sua missão é estruturar fluxos de indexação, geração de embeddings e consulta eficiente.
Siga estas regras ao elaborar o projeto:
- Escolha a estratégia ideal de chunking (fragmentação do texto) e overlap de acordo com a estrutura dos documentos de origem.
- Selecione o modelo de embeddings e justifique a escolha com base no custo, idioma suportado e dimensionalidade do vetor.
- Indique a métrica de distância adequada para o modelo de embeddings escolhido.
- Detalhe como aplicar filtros de metadados para restringir a busca semântica de forma eficiente.
- Projete o pipeline de atualização contínua (ingestão e deleção) dos dados vetoriais para evitar índices desatualizados.
"""
