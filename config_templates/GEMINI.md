# Diretrizes do Ecossistema Gemini no Servidor Windows

Este documento serve como guia prático e operacional para o desenvolvimento de software e execução de tarefas no ecossistema Windows do servidor, focando em compatibilidade de terminal, execução de scripts, ambientes virtuais e boas práticas.

## 1. Ambiente do Servidor e Shell Padrão
- **Sistema Operacional:** Microsoft Windows.
- **Shell de Execução:** O terminal padrão a ser utilizado é o **PowerShell 7+ (pwsh)**.
- **Comandos Unix Proibidos:** 
  - Nunca tente utilizar comandos Unix nativos diretamente no shell do Windows (ex: `ls`, `rm`, `cp`, `mv`, `grep`, `mkdir`), pois eles não são nativos do Windows ou podem comportar-se de maneira inesperada dependendo de aliases.
  - **Alternativas recomendadas no PowerShell:**
    - Listar arquivos: `Get-ChildItem` (ou usar as ferramentas específicas da API de arquivos do Agente).
    - Deletar arquivos: `Remove-Item`.
    - Copiar arquivos: `Copy-Item`.
    - Mover arquivos: `Move-Item`.
    - Criar diretórios: `New-Item -ItemType Directory`.
    - Busca de texto: Usar ripgrep (`rg`) ou as APIs nativas do Agente (`grep_search`), evitando `grep` manual em linha de comando.
- **Comandos CD:** Nunca envie o comando `cd` isolado para mudar o estado de diretório do terminal caso o Agente possua ferramentas específicas de terminal que requerem definição explícita do diretório de trabalho via parâmetro `Cwd`.

## 2. Gerenciamento e Execução de Python
- **Ambientes Virtuais (.venv):**
  - Todo projeto Python deve utilizar um ambiente virtual isolado para suas dependências.
  - Para garantir que a versão correta do interpretador e as dependências isoladas sejam executadas, **nunca execute comandos python de forma global** (como `python script.py` ou `pip install package`).
  - **Sempre utilize os caminhos explícitos** para os binários do ambiente virtual localizado no diretório do projeto:
    - Execução do Interpretador: `.venv\Scripts\python.exe` (ex: `.venv\Scripts\python.exe meu_script.py`)
    - Instalação de Pacotes: `.venv\Scripts\pip.exe` (ex: `.venv\Scripts\pip.exe install -r requirements.txt`)
  - No Windows, a pasta de scripts do ambiente virtual chama-se `Scripts` (com "S" maiúsculo) e não `bin` (como no Linux/MacOS).

## 3. Tratamento de Caminhos e Aspas no PowerShell (pwsh)
- **Caminhos com Espaços:**
  - O Windows frequentemente possui caminhos com espaços (ex: `C:\Meus Projetos\apps`).
  - Para executar comandos ou passar argumentos com caminhos contendo espaços, sempre envolva o caminho em aspas duplas ou simples.
- **Operador de Chamada (`&`):**
  - Se você precisar executar um executável cujo caminho absoluto ou relativo contém espaços, use o operador de chamada do PowerShell (`&`).
  - Exemplo: `& "C:\Caminho Com Espaco\meu_programa.exe" --arg1`
- **Escape de Aspas:**
  - Ao aninhar comandos ou passar strings complexas em argumentos, preste muita atenção ao comportamento de interpolação e escape de aspas no PowerShell. Use a crase (`` ` ``) para fazer o escape de caracteres especiais ou aspas se necessário, ou prefira o uso de arquivos de script intermediários para simplificar execuções complexas.
