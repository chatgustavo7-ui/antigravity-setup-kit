---
name: estrategia-operacoes-processos
description: Gerencie OKRs, fluxos de trabalho (BPMN), quadros de tarefas e diagramas organizacionais (Asana, Miro).
---

# Estratégia, Operações e Processos (BPM, OKR & Tarefas)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill auxilia na definição de objetivos corporativos, gerenciamento de projetos, mapeamento de fluxos de processos (BPMN) e organização de quadros Kanban/Sprint. Ela fornece integração lógica e técnica com ferramentas de colaboração e produtividade como Miro, Lucidchart, Asana, Trello, Jira e Monday.com.

Use esta skill quando precisar:
- Automatizar a sincronização de tarefas entre o banco de dados interno e o Jira/Asana corporativo.
- Estruturar painéis de acompanhamento de OKRs (Objectives and Key Results) para a diretoria.
- Mapear caminhos críticos e gargalos operacionais em pipelines de processos complexos.
- Exportar ou ler metadados de quadros do Miro ou diagramas de processos do Lucidchart via API.

## 2. Stack Tecnológico e Implementação
A automação de fluxos operacionais e visualização gráfica de processos requer:
- **Jira/Asana APIs**: Integração RESTful baseada em tokens OAuth 2.0 para manipulação e enriquecimento de cards.
- **BPMN Engines**: Motores de workflow como Camunda ou bpmn-js para renderização de processos baseados em padrões internacionais de notação.
- **Webhooks e Polling**: Estratégias híbridas de escuta de alteração de estado para atualização de pipelines locais em tempo real.
- **Data Visualization**: Uso de bibliotecas de diagramação como D3.js ou Mermaid.js para expor fluxogramas e organogramas interativos no frontend.

Dicas práticas de uso:
- Ao integrar com o Jira/Asana, use IDs globais persistentes para mapear tarefas, e não o número incremental legível, que pode mudar.
- Para medição de OKRs, crie regras de agregação assíncronas para recalcular os Key Results em background, evitando lentidão na UI.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Estratégia, Operações e Processos, utilize o seguinte prompt starter:
"Você é um especialista em eficiência operacional e arquiteto de processos. Ajude a desenhar um sistema de sincronização e gestão de tarefas integrado a APIs de gestão (Asana/Jira). Projete a estrutura de banco de dados para rastrear OKRs e Key Results corporativos, crie os fluxogramas técnicos usando sintaxe Mermaid.js e especifique as rotas de API para transição de estágios nos processos internos."
