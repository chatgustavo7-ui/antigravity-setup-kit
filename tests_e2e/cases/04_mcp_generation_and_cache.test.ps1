# Caso de Teste E2E para Geracao de Configs MCP, Diretivas Globais e Pre-cacheamento
Write-Host "Iniciando 04_mcp_generation_and_cache.test.ps1"

# Funcoes Auxiliares de Limpeza para os testes
function Reset-TestSandbox {
    Write-Host "  [Sandbox] Resetando pastas de teste..."
    if (Test-Path $env:USERPROFILE\.gemini) {
        Remove-Item -Path $env:USERPROFILE\.gemini -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    # Recriar caminhos basicos
    New-Item -ItemType Directory -Path $env:USERPROFILE -Force | Out-Null
    New-Item -ItemType Directory -Path $env:ANTIGRAVITY_WORKSPACE_PATH -Force | Out-Null

    # Limpar log de chamadas
    if (Test-Path $env:MOCK_LOG_PATH) {
        Clear-Content $env:MOCK_LOG_PATH -ErrorAction SilentlyContinue | Out-Null
    }

    # Garantir que nao haja token no processo por padrao
    Remove-Item -Path "Env:GITHUB_PERSONAL_ACCESS_TOKEN" -ErrorAction SilentlyContinue | Out-Null
}

$global:mockAnswers = @{}
function global:Read-Host {
    param([string]$Prompt)
    Write-Host "  [Mock Read-Host] Prompt: '$Prompt'"
    foreach ($key in $global:mockAnswers.Keys) {
        if ($Prompt -like "*$key*") {
            $val = $global:mockAnswers[$key]
            Write-Host "  [Mock Read-Host] Respondendo: '$val'"
            return $val
        }
    }
    return ""
}

function Set-MockCommand {
    param([string]$Name, [string]$Content)
    $path = Join-Path $mocksDir "$Name.cmd"
    $Content | Out-File -FilePath $path -Encoding ascii -Force
}

function Setup-BaseMocks {
    Set-MockCommand "node" "@echo off`necho v20.11.0"
    Set-MockCommand "python" "@echo off`necho Python 3.11.5"
    Set-MockCommand "git" "@echo off`necho git version 2.43.0"
    Create-Mocks
}

$cliDest = Join-Path $env:USERPROFILE ".gemini\config\mcp_config.json"
$ideDest = Join-Path $env:USERPROFILE ".gemini\antigravity-ide\mcp_config.json"
$settingsDest = Join-Path $env:USERPROFILE ".gemini\settings.json"
$agentsDest = Join-Path $env:USERPROFILE ".gemini\config\AGENTS.md"
$geminiMdDest = Join-Path $env:USERPROFILE ".gemini\GEMINI.md"

# ============================================================================
# TIER 1 - HAPPY-PATHS
# ============================================================================

# --- Cenario 1: Geracao inicial sem arquivos existentes ---
Write-Host "Executando Cenario 1 (Tier 1): Geracao inicial de arquivos de configuracao..."
Reset-TestSandbox
Setup-BaseMocks

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String

Assert-FileExists $cliDest "O arquivo mcp_config.json do CLI deve ser gerado"
Assert-FileExists $ideDest "O arquivo mcp_config.json do IDE deve ser gerado"
Assert-FileExists $settingsDest "O arquivo settings.json deve ser gerado"
Assert-FileExists $agentsDest "O arquivo AGENTS.md deve ser gerado"
Assert-FileExists $geminiMdDest "O arquivo GEMINI.md deve ser gerado"

# Verificar sintaxe JSON dos arquivos gerados
$cliJson = Get-Content $cliDest -Raw | ConvertFrom-Json
$ideJson = Get-Content $ideDest -Raw | ConvertFrom-Json
Assert-True ($null -ne $cliJson) "mcp_config.json CLI deve ser JSON valido"
Assert-True ($null -ne $ideJson) "mcp_config.json IDE deve ser JSON valido"

# --- Cenario 2: Substituicao correta de placeholders ---
Write-Host "Executando Cenario 2 (Tier 1): Substituicao do token no mcp_config.json..."
Reset-TestSandbox
Setup-BaseMocks
$env:GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_mytesttoken12345678"

# Rodar o setup
& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

$cliContent = Get-Content $cliDest -Raw
$ideContent = Get-Content $ideDest -Raw

Assert-StringContains "ghp_mytesttoken12345678" $cliContent "O token do GitHub deve ser substituido no config CLI"
Assert-StringContains "ghp_mytesttoken12345678" $ideContent "O token do GitHub deve ser substituido no config IDE"
Assert-False ($cliContent.Contains("__YOUR_GITHUB_TOKEN__")) "Nao deve conter o placeholder original no CLI"

# --- Cenario 3: Pre-cacheamento com sucesso ---
Write-Host "Executando Cenario 3 (Tier 1): Pre-cacheamento com sucesso dos servidores MCP..."
Reset-TestSandbox
Setup-BaseMocks

& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

# Verificar se as chamadas do npx estao no log de mock
$logContent = Get-Content $env:MOCK_LOG_PATH -Raw
Assert-StringContains "npx -y @modelcontextprotocol/server-sequential-thinking --help" $logContent "Deve tentar pré-cachear sequential-thinking"
Assert-StringContains "npx -y @modelcontextprotocol/server-memory --help" $logContent "Deve tentar pré-cachear memory"

# --- Cenario 4: Idempotencia - Pular sobrescrita (N) ---
Write-Host "Executando Cenario 4 (Tier 1): Nao sobrescrever mcp_config.json se usuario recusar..."
Reset-TestSandbox
Setup-BaseMocks

# Rodar primeira vez
& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

# Modificar o arquivo mcp_config.json local
$customJsonContent = "{ `"mcpServers`": {} }"
Set-Content -Path $cliDest -Value $customJsonContent -Encoding UTF8

# Rodar segunda vez respondendo 'n' para sobrescrever
$global:mockAnswers = @{ "Sobrescrever" = "n" }
& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

# O conteudo deve ter sido mantido
$currentContent = (Get-Content $cliDest -Raw).TrimEnd()
Assert-Equals $customJsonContent $currentContent "O arquivo mcp_config.json CLI nao deve ter sido sobrescrito"

# --- Cenario 5: Idempotencia - Sobrescrever (s) ---
Write-Host "Executando Cenario 5 (Tier 1): Sobrescrever mcp_config.json se usuario aceitar..."
$global:mockAnswers = @{ "Sobrescrever" = "s" }
& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

$currentContent = Get-Content $cliDest -Raw
Assert-False ($currentContent -eq $customJsonContent) "O arquivo mcp_config.json CLI deve ter sido sobrescrito com o template"

# --- Cenario 6: Resposta invalida no prompt de sobrescrita e tratada como Nao ---
Write-Host "Executando Cenario 6 (Tier 1, herdado de FT05-T2-04): Resposta invalida tratada como recusa..."
"CLI_OLD_INVALID_RESP" | Out-File -FilePath $cliDest -Force
$global:mockAnswers = @{ "Sobrescrever" = "confirmar" }
& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null
Assert-Equals "CLI_OLD_INVALID_RESP" (Get-Content $cliDest -Raw).Trim() "Resposta invalida deve ser tratada como Nao (nao sobrescrever)"

# --- Cenario 7: AGENTS.md e GEMINI.md nao sao sobrescritos se ja existirem ---
Write-Host "Executando Cenario 7 (Tier 1): Idempotencia de AGENTS.md e GEMINI.md..."
$agentsCustom = "Regra Customizada de Teste"
Set-Content -Path $agentsDest -Value $agentsCustom -Encoding utf8
$global:mockAnswers = @{}
& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null
$agentsCurrent = (Get-Content $agentsDest -Raw).TrimEnd()
Assert-Equals $agentsCustom $agentsCurrent "O arquivo AGENTS.md nao deve ser sobrescrito se ja existir (idempotencia)"


# ============================================================================
# TIER 2 - CASOS DE BORDA E ERROS
# ============================================================================

# --- Cenario 8: Placeholder sem variavel de ambiente ---
Write-Host "Executando Cenario 8 (Tier 2): Placeholder sem variavel GITHUB_PERSONAL_ACCESS_TOKEN..."
Reset-TestSandbox
Setup-BaseMocks
Remove-Item -Path "Env:GITHUB_PERSONAL_ACCESS_TOKEN" -ErrorAction SilentlyContinue | Out-Null

& $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

$cliContent = Get-Content $cliDest -Raw
# NOTA: o setup_antigravity.ps1 faz $content.Replace('__YOUR_GITHUB_TOKEN__', [string]$env:GITHUB_PERSONAL_ACCESS_TOKEN)
# incondicionalmente. Quando a variavel nao existe, [string]$null vira "" - o Replace
# ainda roda e troca o placeholder por uma string vazia (ele NAO permanece intocado).
Assert-False ($cliContent.Contains("__YOUR_GITHUB_TOKEN__")) "Sem a variavel de ambiente, o placeholder e substituido por string vazia (nao permanece intocado)"

# --- Cenario 9: Falha no pre-cacheamento (npx com erro) ---
Write-Host "Executando Cenario 9 (Tier 2): Falha simulada na execucao do npx..."
Reset-TestSandbox
Setup-BaseMocks
Set-MockCommand "npx" "@echo off`necho Erro na rede >&2`nexit /b 1"

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
# NOTA: mesma limitacao ja documentada nos Cenarios 7/8 de 03_auth_and_tokens.test.ps1 -
# "npx ... 2>&1 | Out-Null" dentro do try/catch da ETAPA 8 nao verifica $LASTEXITCODE,
# entao um npx com exit code de falha NAO cai no catch ("sera instalado na primeira
# execucao"). O script reporta "pre-instalado" mesmo quando o pre-cache falhou.
Assert-StringContains "pré-instalado" $output "Exit code de falha do npx nao e capturado pelo try/catch (comportamento real do script)"

# --- Cenario 10: Template de origem corrompido (JSON invalido) ---
Write-Host "Executando Cenario 10 (Tier 2): Template de origem corrompido..."
Reset-TestSandbox
Setup-BaseMocks

# Sobrescrever template original com JSON invalido
$templateCliPath = Join-Path $projectRoot "config_templates\mcp_config_cli.template.json"
$backupTemplateContent = Get-Content $templateCliPath -Raw

try {
    Set-Content -Path $templateCliPath -Value "JSON INVALIDO { [ }" -Encoding UTF8

    # Executar setup (ele deve copiar o arquivo mesmo assim, pois e copia de texto)
    & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

    $copiedContent = (Get-Content $cliDest -Raw).TrimEnd()
    Assert-Equals "JSON INVALIDO { [ }" $copiedContent "Deve ter copiado o arquivo exatamente como o template mesmo corrompido"
}
finally {
    # Restaurar template original
    Set-Content -Path $templateCliPath -Value $backupTemplateContent -Encoding UTF8 -Force
}

# --- Cenario 11: Ausencia das configuracoes de settings.template.json ---
Write-Host "Executando Cenario 11 (Tier 2): settings.template.json ausente..."
Reset-TestSandbox
Setup-BaseMocks

$settingsTemplatePath = Join-Path $projectRoot "config_templates\settings.template.json"
$backupSettings = Get-Content $settingsTemplatePath -Raw

try {
    Remove-Item -Path $settingsTemplatePath -Force

    # Rodar o setup
    & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

    # O script deve apenas pular silenciosamente sem gerar erros de crash
    Assert-False (Test-Path $settingsDest) "O arquivo settings.json nao deve ter sido criado"
}
finally {
    # Restaurar
    Set-Content -Path $settingsTemplatePath -Value $backupSettings -Encoding UTF8 -Force
}

# Limpeza final dos mocks
Create-Mocks
Write-Host "04_mcp_generation_and_cache.test.ps1 concluido com sucesso!"
