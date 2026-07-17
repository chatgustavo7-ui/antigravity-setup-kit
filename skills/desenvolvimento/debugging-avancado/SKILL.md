---
name: debugging-avancado
description: Técnicas de depuração, análise de logs estruturados e isolamento de problemas complexos no sistema.
---

# Técnicas de Depuração Avançada e Isolamento de Erros

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill consolida técnicas avançadas de diagnóstico para isolar, reproduzir e corrigir defeitos difíceis e intermitentes no software (como vazamentos de memória, race conditions ou erros de integração). Ensina como depurar metodicamente por meio de instrumentação, análise de rastreamentos de pilha (stack traces) e reprodução de cenários de falha.

### Quando usar:
- Quando o sistema falha em produção de forma intermitente e sem causa óbvia evidente nos logs básicos.
- Durante a depuração de condições de corrida (race conditions) em sistemas concorrentes ou assíncronos.
- Para rastrear gargalos ou corrupção de estado que ocorrem em fluxos complexos de chamadas.
- Ao investigar vazamento de recursos (sockets, memória, handles de arquivos abertos).

## 2. Stack Tecnológico e Implementação
Para uma depuração assertiva, recomenda-se dominar as ferramentas e metodologias:
- **Depuradores Interativos (IDEs)**: Breakpoints condicionais e watchpoints no VS Code, IntelliJ, ou ferramentas nativas CLI (ex: `gdb`, `pdb`, `node --inspect`).
- **Análise de Performance/Memória**: Profilers de CPU e heap dumps (ex: Chrome DevTools, Python cProfile, pprof).
- **Log Estruturado e Rastreabilidade**: OpenTelemetry, Grafana Tempo, Datadog ou ferramentas locais de agregação de logs.

### Abordagem Metódica para Isolamento de Bugs:
- **Reprodução Mínima Viável**: Crie um script simplificado ou teste unitário isolado que force a falha a ocorrer de forma consistente.
- **Divisão Binária**: Reduza pela metade as variáveis ou o escopo do código investigado para localizar a origem exata do erro.
- **Logs de Auditoria Temporários**: Instrumente o código suspeito com logs detalhados do estado interno em momentos-chave da execução.

## 3. Instrução de Inicialização
Configure o assistente com o seguinte direcionamento:
"Você é o especialista em Depuração Avançada e Isolamento de Defeitos Complexos. Sua missão é me guiar de forma metódica na resolução de erros e falhas difíceis. Ao analisar os stack traces ou logs que eu fornecer, identifique os padrões de falha e me sugira uma lista prioritária de hipóteses de causa raiz. Ensine-me a depurar usando breakpoints condicionais, profilers de performance ou dumps de memória adequados à stack tecnológica."
