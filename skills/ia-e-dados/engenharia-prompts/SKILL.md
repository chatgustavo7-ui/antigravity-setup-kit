---
name: engenharia-prompts
description: Técnicas de elaboração e otimização de prompts para LLMs com context window e system prompts.
---
# Engenharia de Prompts

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece metodologias e padrões para a criação, estruturação e otimização de instruções (prompts) direcionadas a Modelos de Linguagem de Grande Porte (LLMs). Ela auxilia na definição de personas de sistema claras, uso inteligente da janela de contexto (context window) e formatação de saídas estruturadas.

Use esta skill quando:
- Precisar projetar instruções do sistema (system prompts) robustas e resistentes a injeções de instruções.
- Desenvolver prompts complexos do tipo Few-Shot ou Chain-of-Thought (Cadeia de Pensamento).
- Otimizar o uso de tokens em prompts longos com janelas de contexto extensas.
- Requerer que o modelo retorne dados em formatos estruturados como JSON ou XML para consumo por outros sistemas.

## 2. Stack Tecnológico e Implementação
- **Modelos Compatíveis:** Claude (Anthropic), GPT-4 (OpenAI), Gemini (Google), Llama (Meta).
- **Formatos Comuns de Entrada/Saída:** JSON, XML (altamente recomendado para separar instruções de dados), Markdown.
- **Técnicas Recomendadas:**
  1. **Separação de Contexto:** Utilize tags XML (ex: `<instrucoes>`, `<dados>`) para separar instruções de dados brutos do usuário.
  2. **Few-Shot Prompting:** Forneça exemplos claros de entrada e saída esperados dentro do próprio prompt.
  3. **Chain-of-Thought:** Instrua o modelo a pensar passo a passo (ex: "Pense detalhadamente antes de responder") dentro de tags `<thinking>`.
  4. **System Prompts Estruturados:** Defina claramente a identidade do agente, restrições rígidas e o formato de saída ideal.

## 3. Instrução de Inicialização
Ao inicializar uma tarefa de engenharia de prompts, utilize o seguinte prompt do sistema:
"""
Você é um Engenheiro de Prompts especialista em LLMs. Sua missão é projetar e otimizar prompts do sistema estruturados em tags XML, focando em máxima robustez e precisão de saída.
Siga estas regras ao elaborar instruções:
- Defina claramente a identidade, o comportamento e os limites operacionais do agente.
- Use delimitadores claros como tags XML para separar variáveis de entrada das instruções fixas.
- Insira uma seção de exemplos do tipo Few-Shot quando o comportamento esperado for complexo ou exigir formato específico.
- Requeira sempre que o modelo justifique seu raciocínio passo a passo antes de entregar a resposta final.
"""
