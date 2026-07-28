# Unificação e conclusão do antigravity-setup-kit

Data: 2026-07-28

## Contexto

O usuário mantinha dois repositórios GitHub com conteúdo sobreposto:

- **antigravity-setup-kit** — kit de configuração automatizada do Google Antigravity: instalador `.exe` (Inno Setup) para Windows, script para Linux, 52 skills PT-BR organizadas em verticais de mercado, catálogo de MCP servers, e um docker-compose com um conceito de "Second Brain" via Obsidian.
- **Enterprise_Agentic_Workspace** — as mesmas 13 verticais de skills, porém como esqueleto genérico (`SKILL.md` com corpo tipo "Skill de automação corporativa para a área de X"), sem o restante da infraestrutura (instalador, MCP, Obsidian).

Comparação direta (ex: skill de RH) confirmou que o `antigravity-setup-kit` tem o conteúdo mais maduro e específico (referências reais a Workday, BambooHR, Gupy) enquanto o `Enterprise_Agentic_Workspace` é um rascunho anterior do mesmo material.

Levantamento adicional encontrou lacunas reais no `antigravity-setup-kit`:

- A integração com Obsidian existe **só como template de config MCP**, com duas opções concorrentes (`obsidian-advanced` = `@oomkapwn/enquire-mcp`, `obsidian-light` = `obsidian-mcp-server`), nenhuma documentada no catálogo (`docs/CATALOGO_MCP.md`), nenhuma usada pelos scripts de setup, e o caminho do vault (`/workspace/obsidian`) só faz sentido dentro do container Docker — não existe em uma instalação nativa.
- Não existe suporte a macOS: só há `setup_antigravity.ps1` (Windows) e `setup_linux.sh` (sem nenhuma detecção de Darwin).
- `Enterprise_Agentic_Workspace/.agents/mcp_config.json` tem entradas de MCP (Stripe, Slack) que não existem no catálogo do `antigravity-setup-kit`.

## Objetivo

Um único repositório (`antigravity-setup-kit`) que instala e configura automaticamente, num único comando por plataforma, um ambiente Antigravity completo: skills, MCP servers (incluindo Stripe/Slack) e Obsidian como memória persistente real — com o app do Obsidian instalado de verdade, não só uma referência de config.

## Não-objetivos

- Não é objetivo desta rodada construir instaladores nativos empacotados para Linux/Mac (`.deb`, `.pkg`) — scripts shell/PowerShell bem escritos são suficientes, na linha do que já existe pro Windows via Inno Setup.
- Não é objetivo migrar ou testar em uma máquina macOS real (ver limitação abaixo).

## Decisões de arquitetura

### 1. Repositório único
`antigravity-setup-kit` permanece como está (nome e identidade corretos). Antes de apagar o `Enterprise_Agentic_Workspace`, as entradas MCP de Stripe e Slack são portadas para `config_templates/mcp_config_ide.template.json` e `config_templates/mcp_config_cli.template.json`. O resto do `Enterprise_Agentic_Workspace` (skills genéricas, `.venv`, plugins placeholder, `repos_externos/ruflo`) não tem conteúdo que valha preservar. O repositório é apagado do GitHub ao final.

### 2. Obsidian: servidor MCP único
Entre as duas opções do template, `@oomkapwn/enquire-mcp` (`obsidian-advanced`) é escolhido como único servidor Obsidian: é o mais atualizado (25/jul/2026 vs 30/jun/2026 do `obsidian-mcp-server`) e foi construído especificamente para memória de longo prazo de agentes de IA sobre um vault Obsidian (busca híbrida BM25 + embeddings), que é exatamente o caso de uso descrito no README ("Second Brain"). A entrada `obsidian-light` é removida dos templates.

### 3. Obsidian: instalação real do app, por plataforma
Os scripts de setup passam a:
- Criar uma pasta de vault local real (fora de qualquer contexto Docker), com uma estrutura inicial mínima.
- Instalar o aplicativo Obsidian: `winget install Obsidian.Obsidian` no Windows, `brew install --cask obsidian` no macOS, `apt`/pacote correspondente ou fallback para o AppImage oficial no Linux.
- Escrever a entrada MCP do Obsidian no `mcp_config` real do usuário apontando para o caminho real do vault (não `/workspace/obsidian`).

### 4. Suporte macOS
`setup_linux.sh` permanece com esse nome (evita quebrar links/documentação existente) mas passa a detectar `$(uname)` logo no início e ramificar internamente: em `Darwin`, usa `brew` no lugar de `apt-get`/`dnf` para as instalações de pacote, e ajusta os caminhos de configuração do Antigravity CLI/IDE para as convenções do macOS (`~/Library/Application Support/...` onde aplicável, em vez dos caminhos Linux). Um único script com detecção interna, em vez de duplicar lógica em dois arquivos.

### 5. Documentação
`docs/CATALOGO_MCP.md` passa a listar o Obsidian (com a explicação do porquê da escolha) e as entradas novas (Stripe, Slack). README atualizado para não prometer nada que o kit não entrega de fato.

## Testes e limitação conhecida

- **Windows**: testado de ponta a ponta nesta máquina (ambiente real de desenvolvimento do usuário).
- **Linux**: validado via WSL2 Ubuntu. Não é idêntico a um Ubuntu bare-metal, mas cobre a grande maioria dos caminhos de código (mesmo kernel Linux, mesmos gerenciadores de pacote).
- **macOS**: **não há máquina Mac disponível para teste real.** O script é escrito seguindo as convenções corretas do macOS (Homebrew, estrutura de diretórios), mas não pode ser executado de ponta a ponta neste ambiente. Recomenda-se validação manual numa máquina Mac real antes de considerar o suporte macOS como definitivamente funcional.
