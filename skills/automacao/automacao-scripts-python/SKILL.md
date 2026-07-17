---
name: automacao-scripts-python
description: Scripts em Python para automação local de manipulação de arquivos, dados e PDFs de forma eficiente.
---

# Automação de Scripts Python Local

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece instruções, padrões e templates para a criação de scripts estruturados em Python focados em tarefas locais de automação. Ela lida com a leitura, gravação, organização e transformação de arquivos de diversos tipos, processamento em lote de dados tabulares e extração/geração de PDFs.

Você deve usar esta skill quando precisar:
- Ler ou escrever arquivos em massa (ex. CSV, JSON, XML, TXT).
- Renomear, mover, copiar ou remover arquivos e diretórios de forma recursiva baseada em padrões.
- Extrair texto, mesclar, dividir ou gerar relatórios em formato PDF programaticamente.
- Realizar limpezas rápidas e pipelines locais simples de dados antes do carregamento em bancos.

## 2. Stack Tecnológico e Implementação
O ecossistema recomendado de bibliotecas padrão e de terceiros inclui:
- **`pathlib`**: Manipulação moderna e segura de caminhos de arquivos em qualquer sistema operacional.
- **`shutil` e `os`**: Operações de alto nível em arquivos, como cópia, movimentação e listagem.
- **`pypdf` ou `pymupdf` (fitz)**: Extração de metadados, leitura de texto de páginas específicas e fusão de arquivos PDF.
- **`pandas` ou `csv`**: Processamento eficiente e conversão de dados de arquivos tabulares locais.

Dicas práticas:
- Sempre utilize blocos `with open(...)` para garantir que os arquivos sejam devidamente fechados após o uso.
- Para manipulação de caminhos, evite concatenações de strings manuais. Dê preferência ao operador `/` da `pathlib.Path`.
- Adicione logs estruturados usando o módulo `logging` integrado para rastrear o progresso do script e facilitar a depuração.

## 3. Instrução de Inicialização
Ao inicializar um agente com esta skill, utilize o seguinte prompt de inicialização:
"Atue como um especialista em automação local utilizando Python. Desenvolva scripts limpos, modulares e seguros para manipulação de arquivos, diretórios e PDFs. Certifique-se de tratar exceções de leitura/escrita, utilizar caminhos relativos via `pathlib` e evitar o uso de variáveis globais. Sempre escreva testes unitários simples ou scripts de validação local para confirmar o comportamento das funções de automação."
