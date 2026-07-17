---
name: contabilidade
description: Gerencie plano de contas, escrituração fiscal, balancetes e exportações para sistemas contábeis (Domínio, Alterdata).
---

# Contabilidade (Escrituração Fiscal & Plano de Contas)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill orienta a modelagem e exportação de dados contábeis corporativos. Ela ajuda a gerenciar planos de contas estruturados, geração de balancetes, livros diários/razão e a formatação de dados fiscais (SPED/XML) para integração com softwares de contabilidade como Domínio Sistemas, Alterdata, QuickBooks, Omie e Contazul.

Use esta skill quando precisar:
- Estruturar ou mapear o plano de contas (ativos, passivos, receitas e despesas) de um sistema local.
- Exportar lotes de transações financeiras em formatos aceitos por softwares de escrituração contábil (como leiautes TXT específicos do Domínio ou Excel/CSV estruturado).
- Automatizar a conciliação entre relatórios gerenciais e relatórios fiscais obrigatórios.
- Rastrear a retenção de impostos (IRRF, PIS, COFINS, CSLL, ISS) em notas fiscais emitidas ou recebidas.

## 2. Stack Tecnológico e Implementação
A precisão matemática e a conformidade regulatória são pilares fundamentais da contabilidade:
- **Geração de Arquivos Fiscais**: Geração de lotes XML de notas fiscais de serviço (NFS-e) e produto (NF-e) para submeter ao fisco ou contabilidade parceira.
- **Parsing de Arquivos XML (SEFAZ)**: Leitura automatizada de XMLs de compras recebidas para dar entrada rápida em estoque e registrar passivos contábeis.
- **Plano de Contas em Árvore**: Armazenamento hierárquico no banco de dados para representar as contas contábeis pai e suas respectivas subcontas.
- **Impostos e Alíquotas**: Tabelas atualizáveis de taxas e impostos baseadas em Classificação Fiscal de Operações e Prestações (CFOP) e Código de Situação Tributária (CST).

Dicas práticas de uso:
- Sempre mantenha o histórico de alterações das regras de tributação (histórico de alíquotas) para garantir que cálculos retroativos possam ser auditados corretamente.
- Para grandes volumes de notas fiscais, armazene os XMLs originais da SEFAZ em buckets de arquivamento frio com compressão gzip para baratear o custo.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Contabilidade, utilize o seguinte prompt starter:
"Você é um arquiteto de sistemas contábeis e engenheiro fiscal. Desenhe a integração e fluxo de dados para exportação contábil para o Domínio Sistemas / Alterdata. Modele o plano de contas local em banco de dados usando estrutura em árvore, defina as fórmulas matemáticas para cálculos de retenção de impostos nacionais (PIS/COFINS/ISS) e especifique a estrutura de exportação CSV/TXT em conformidade com as regras fiscais."
