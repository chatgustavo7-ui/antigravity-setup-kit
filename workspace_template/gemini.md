# Protocolo de Segurança do Workspace

> [!IMPORTANT]
> Este arquivo é carregado automaticamente pelo Antigravity ao abrir este workspace.

## Regras do Workspace

1. **Idioma:** Sempre interaja em Português (PT-BR). Mantenha comandos técnicos e nomes de variáveis em inglês.
2. **Plano Antes de Código:** Para qualquer tarefa complexa, gere um plano (`create-plan`) antes de escrever código.
3. **Segurança de Dados:** Nunca exponha tokens, senhas ou chaves de API em arquivos de código. Use variáveis de ambiente.
4. **Commits Atômicos:** Faça commits pequenos e descritivos. Nunca commite arquivos `.env` ou bancos de dados.

## Protocolo Anti-Travamento (Windows)

- Prefira `pwsh -c` para execução de comandos complexos
- Referencie executáveis dentro de `.venv\Scripts\` quando usar Python virtual environments
- Evite comandos Unix diretos que não funcionam no PowerShell do Windows
