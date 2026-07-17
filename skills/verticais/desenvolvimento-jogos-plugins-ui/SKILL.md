---
name: desenvolvimento-jogos-plugins-ui
description: Gerencie assets 2D/3D, lógica de jogos, plugins de design (Figma API) e desenvolvimento em motores (Unity, Unreal).
---

# Desenvolvimento de Jogos, Plugins e UI (GameDev & Figma)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill orienta na criação de mecânicas de jogos, automação de fluxos de design de UI/UX e desenvolvimento de plugins interativos. Ela conecta engenharia de software aos ecossistemas criativos de Figma, Unity, Unreal Engine, Blender e Godot.

Use esta skill quando precisar:
- Automatizar a exportação de assets gráficos (vetores, ícones) do Figma via API diretamente para o repositório do jogo ou web app.
- Estruturar backends de servidores de jogos (matchmaking, autenticação de jogadores, inventários online).
- Desenvolver plugins para o Figma que gerem código frontend (React/HTML) de forma automatizada ou preencham dados reais de teste.
- Implementar interações de interface de usuário (UI) avançadas em motores de jogos para HUDs ou menus complexos.

## 2. Stack Tecnológico e Implementação
O ambiente de gamedev e design de UI requer computação de alta performance e manipulação de árvores de nós:
- **C# (Unity) / C++ (Unreal)**: Linguagens nativas para desenvolvimento de lógica principal de gameplay e gerenciamento de recursos na memória.
- **Figma REST & Plugin API**: Uso de Javascript/Typescript para ler a árvore de nós de um arquivo do Figma (`FrameNode`, `TextNode`) e manipulá-los.
- **WebSockets / gRPC**: Comunicação de baixíssima latência para sincronização de jogos multiplayer em tempo real ou transmissão de updates de assets.
- **Asset Pipeline Automation**: Scripts (Python/Shell) que otimizam resoluções de texturas, comprimem áudios e geram atlas de sprites.

Dicas práticas de uso:
- Sempre limpe referências circulares e faça o descarte (`Dispose`) de materiais e texturas em tempo de execução para evitar vazamentos de memória (memory leaks) na GPU.
- Ao processar dados do Figma, utilize cache de tokens de estilo (design tokens) locais para acelerar a renderização do plugin.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Desenvolvimento de Jogos, Plugins e UI, utilize o seguinte prompt starter:
"Você é um programador de jogos e engenheiro de ferramentas criativas sênior. Ajude a estruturar um plugin para o Figma ou pipeline de assets para Unity/Unreal. Desenhe a arquitetura do servidor de jogo (matchmaking/inventário) de baixa latência, elabore o parser para extrair Design Tokens da árvore de nós da API do Figma e forneça práticas de otimização de memória em C#/C++."
