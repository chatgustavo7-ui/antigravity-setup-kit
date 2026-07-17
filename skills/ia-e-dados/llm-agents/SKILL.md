---
name: llm-agents
description: Design e orquestração de agentes autônomos baseados em LLM com ferramentas e memória de trabalho.
---
# Agentes Autônomos Baseados em LLM

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill estabelece diretrizes para o design, arquitetura e orquestração de sistemas de agentes autônomos alimentados por Modelos de Linguagem (LLMs). Ela abrange a definição de papéis específicos (personas), chamadas de ferramentas (tool calling/function calling), ciclos de planejamento (ex: ReAct - Reason and Act) e o gerenciamento de memória persistente e de curto prazo (working memory).

Use esta skill quando:
- Construir aplicativos complexos que exigem execução de tarefas em múltiplos passos de forma autônoma.
- Permitir que a LLM interaja com o mundo real através de APIs (bancos de dados, sistemas externos, arquivos locais).
- Necessitar de cooperação e conversas estruturadas entre múltiplos agentes especializados (sistemas multiagentes).
- Gerenciar estados de conversação complexos que dependem de histórico de curto prazo e recuperação de memória de longo prazo.

## 2. Stack Tecnológico e Implementação
- **Frameworks de Orquestração:** LangChain/LangGraph (altamente flexível para grafos cíclicos de agentes), AutoGen, CrewAI (focado em processos de equipe).
- **Componentes Principais do Agente:**
  1. **Planejamento:** ReAct (Ciclo de Pensamento -> Ação -> Observação), Reflection (Agente avalia o próprio output antes de finalizar).
  2. **Ferramentas (Tools):** Funções bem descritas com assinaturas de tipos e descrições textuais que a LLM lê para decidir quando e como chamar.
  3. **Memória de Trabalho:** Histórico de conversa imediato (short-term) compactado por janelas deslizantes ou resumos semânticos.
  4. **Memória de Longo Prazo:** Resumos arquivados em banco vetorial para recuperação semântica no futuro.
- **Práticas Recomendadas:**
  - Defina limites de loops rígidos (max iterations) para evitar loops infinitos caros causados por erros de interpretação da LLM.
  - Valide todas as entradas fornecidas pela LLM para as ferramentas antes de executá-las (sandboxing seguro de código/comandos).

## 3. Instrução de Inicialização
Ao inicializar um projeto de desenvolvimento de agentes autônomos, utilize o seguinte prompt do sistema:
"""
Você é um Arquiteto de Software especialista em Agentes Autônomos baseados em LLM. Sua missão é projetar e implementar sistemas multiagentes resilientes com ferramentas e memória de trabalho.
Siga estas diretrizes de arquitetura:
- Modele o ciclo de raciocínio usando o padrão ReAct (Pensar -> Agir -> Observar).
- Desenhe ferramentas com descrições semânticas precisas e tipagens de argumentos restritas.
- Estabeleça limites operacionais claros (ex: timeout de chamadas, limite máximo de iterações de loop) para garantir controle de custos e tempo.
- Especifique como o agente reterá informações relevantes na memória de trabalho e como integrará memória de longo prazo baseada em banco vetorial.
- Defina políticas rígidas de segurança para validação e execução de ações externas (tools).
"""
