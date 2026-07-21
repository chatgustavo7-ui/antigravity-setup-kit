# Regras e Configurações Globais dos Agentes (Antigravity)

Este arquivo define como os agentes do Google Antigravity e sub-agentes (como `teamwork_preview`, `research`, etc) devem operar no seu ambiente.

> [!IMPORTANT]
> **Modelo Padrão e OpenRouter**
> O ecossistema está configurado para consumir modelos via OpenRouter.
> Ao delegar tarefas para sub-agentes ou rodar scripts automatizados via CLI, sempre priorize modelos de alta eficiência e baixo custo.
> 
> *Modelos de Raciocínio Profundo:* `anthropic/claude-3.5-sonnet`, `google/gemini-1.5-pro`, `meta-llama/llama-3-70b-instruct`
> *Modelos Rápidos (Flash/Haiku):* `anthropic/claude-3-haiku`, `google/gemini-1.5-flash`

## 1. Persistência de Memória

Os agentes NUNCA devem perder a memória. O ambiente utiliza Docker volumes e MCP servers de memória para armazenar o contexto longo.
- Ao rodar localmente no Docker, o volume `antigravity_memory` preserva a pasta `.gemini`.
- O login e as credenciais (`gcloud`, `gh`, tokens em `.env`) não devem expirar e não exigirão recadastramento por parte do usuário.

## 2. Automação Zero-Touch

Nenhum agente deve solicitar senhas ou tokens manualmente ao usuário durante a execução de tarefas.
Se um token faltar, o agente deve orientar o usuário a adicioná-lo no arquivo `.env` e reiniciar o container, mas nunca pedir a senha no chat para o usuário digitar.

## 3. Isolamento Linux / WSL

O agente deve ter ciência de que está rodando em um ambiente Linux (dentro do WSL ou Docker).
- **Paths:** Utilize `/workspace/apps` ao invés de `C:\...`
- **Comandos:** Utilize `ls`, `grep`, `cat` (no contexto de análise), e comandos bash nativos, em vez de comandos PowerShell.
- **Node/Python:** Utilize as versões nativas globais configuradas na imagem Docker.

## 4. Diretrizes de Idioma

- Todos os logs, prompts, análises e interações geradas pelos agentes devem ser **estritamente em Português (PT-BR)**.
- O código e variáveis de sistema mantêm-se em Inglês por padrão de mercado, mas os `prints`, comentários de código e explicações devem ser em PT-BR.
