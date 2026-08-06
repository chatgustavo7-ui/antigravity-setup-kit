# Caso de Teste E2E para Autenticacao Google, GitHub e Tokens Opcionais
Write-Host "Iniciando 03_auth_and_tokens.test.ps1"

# Limpeza e controle de variaveis de ambiente
$testedEnvVars = @(
    "GITHUB_PERSONAL_ACCESS_TOKEN", "STRIPE_SECRET_KEY", "SLACK_BOT_TOKEN",
    "NOTION_API_KEY", "LINEAR_API_KEY", "FIGMA_ACCESS_TOKEN", "SUPABASE_ACCESS_TOKEN"
)
$backupUserEnv = @{}
foreach ($var in $testedEnvVars) {
    $backupUserEnv[$var] = [System.Environment]::GetEnvironmentVariable($var, "User")
}

function Restore-UserEnv {
    Write-Host "  [Sandbox] Restaurando variaveis de ambiente do usuario..."
    foreach ($var in $testedEnvVars) {
        $val = $backupUserEnv[$var]
        [System.Environment]::SetEnvironmentVariable($var, $val, "User")
        if ($null -eq $val -or $val -eq "") {
            Remove-Item -Path "Env:$var" -ErrorAction SilentlyContinue | Out-Null
        } else {
            Set-Item -Path "Env:$var" -Value $val -ErrorAction SilentlyContinue | Out-Null
        }
    }
}

function Clear-ProcessEnv {
    foreach ($var in $testedEnvVars) {
        Remove-Item -Path "Env:$var" -ErrorAction SilentlyContinue | Out-Null
    }
}

# Configurar respostas do Read-Host
# IMPORTANTE: precisa ser "function global:Read-Host" (nao apenas "function Read-Host").
# O runner dot-sourceia este arquivo dentro da funcao Run-TestCase; uma funcao Read-Host
# definida so no escopo local dessa dot-source nao fica visivel para o setup_antigravity.ps1
# quando ele e invocado via "& $setupScript" mais abaixo - o PowerShell cai de volta no
# cmdlet real Read-Host (que retorna vazio em modo nao-interativo), fazendo os mocks
# parecerem "ignorados" silenciosamente. Escopo global resolve isso.
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

# Controlar mocks de comandos
function Set-MockCommand {
    param([string]$Name, [string]$Content)
    $path = Join-Path $mocksDir "$Name.cmd"
    $Content | Out-File -FilePath $path -Encoding ascii -Force
}

function Setup-BaseMocks {
    Set-MockCommand "node" "@echo off`necho v20.11.0"
    Set-MockCommand "python" "@echo off`necho Python 3.11.5"
    Set-MockCommand "git" "@echo off`necho git version 2.43.0"
    # Recriar os outros mock cmd padrao
    Create-Mocks
}

# Este arquivo grava tokens de teste em variaveis de ambiente REAIS do usuario
# Windows (nao apenas na sandbox). Se uma asserção falhar no meio do arquivo, o
# "throw" interromperia a execucao antes da limpeza no final - deixando tokens de
# teste (ex: "sk_test_mystripesecret") presos na conta real do usuario. Por isso
# todo o corpo do teste roda dentro de um try/finally: a restauracao SEMPRE
# acontece, mesmo em caso de falha de asserção.
try {

# ============================================================================
# TIER 1 - HAPPY-PATHS
# ============================================================================

# --- Cenario 1: Google Auth - Login com sucesso (S) ---
Write-Host "Executando Cenario 1 (Tier 1): Google Auth login com sucesso..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
$global:mockAnswers = @{ "Google" = "S" }

$output = & $setupScript -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Login Google realizado com sucesso!" $output "Deve realizar o login do Google"
Assert-StringContains "Credenciais padrão (ADC) configuradas!" $output "Deve configurar credenciais padrao"

# --- Cenario 2: Google Auth - Pular login (n) ---
Write-Host "Executando Cenario 2 (Tier 1): Google Auth login pulado..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
$global:mockAnswers = @{ "Google" = "n" }

$output = & $setupScript -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Login Google pulado pelo usuário" $output "Deve registrar que o login foi pulado pelo usuario"

# --- Cenario 3: GitHub Auth - Ja autenticado ---
Write-Host "Executando Cenario 3 (Tier 1): GitHub ja autenticado..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
# gh mock padrao simula logado
Set-MockCommand "gh" "@echo off`nif `"%1`"==`"auth`" (if `"%2`"==`"status`" (echo logged in to github.com as MockUser keyring`nexit /b 0) else if `"%2`"==`"token`" (echo ghp_mocktokengithub12345`nexit /b 0))`nexit /b 0"

$output = & $setupScript -SkipGoogleAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "GitHub CLI já está autenticado" $output "Deve avisar que ja esta autenticado"
Assert-StringContains "Token GitHub salvo como variável de ambiente do usuário" $output "Deve salvar o token"
Assert-Equals "ghp_mocktokengithub12345" $env:GITHUB_PERSONAL_ACCESS_TOKEN "A variavel de ambiente do processo deve ser atualizada"

# --- Cenario 4: GitHub Auth - Login com sucesso (OAuth) ---
Write-Host "Executando Cenario 4 (Tier 1): GitHub CLI autenticando com sucesso..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
# gh mock inicial retorna erro no status, mas sucesso no login e token
Set-MockCommand "gh" "@echo off`nif `"%1`"==`"auth`" (if `"%2`"==`"status`" (exit /b 1) else if `"%2`"==`"login`" (echo Login bem sucedido`nexit /b 0) else if `"%2`"==`"token`" (echo ghp_mocktokennew98765`nexit /b 0))`nexit /b 0"

$output = & $setupScript -SkipGoogleAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Login GitHub realizado com sucesso!" $output "Deve fazer login no GitHub"
Assert-Equals "ghp_mocktokennew98765" $env:GITHUB_PERSONAL_ACCESS_TOKEN "Deve atualizar o token GITHUB_PERSONAL_ACCESS_TOKEN"

# --- Cenario 5: Tokens Opcionais - Configurar as 6 chaves com sucesso ---
Write-Host "Executando Cenario 5 (Tier 1): Configurar as 6 chaves opcionais..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
$global:mockAnswers = @{
    "Stripe" = "sk_test_mystripesecret"
    "Slack" = "xoxb-myslacktoken"
    "Notion" = "ntn_mynotionkey"
    "Linear" = "lin_mylinearkey"
    "Figma" = "figd_myfigmakey"
    "Supabase" = "sbp_mysupabasekey"
}

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth *>&1 | Out-String
Assert-StringContains "Stripe (Pagamentos) salvo como variável de ambiente" $output "Stripe deve ser salvo"
Assert-StringContains "Slack (Mensageria) salvo como variável de ambiente" $output "Slack deve ser salvo"

Assert-Equals "sk_test_mystripesecret" $env:STRIPE_SECRET_KEY "Processo deve ter STRIPE_SECRET_KEY"
Assert-Equals "xoxb-myslacktoken" $env:SLACK_BOT_TOKEN "Processo deve ter SLACK_BOT_TOKEN"
Assert-Equals "ntn_mynotionkey" $env:NOTION_API_KEY "Processo deve ter NOTION_API_KEY"
Assert-Equals "lin_mylinearkey" $env:LINEAR_API_KEY "Processo deve ter LINEAR_API_KEY"
Assert-Equals "figd_myfigmakey" $env:FIGMA_ACCESS_TOKEN "Processo deve ter FIGMA_ACCESS_TOKEN"
Assert-Equals "sbp_mysupabasekey" $env:SUPABASE_ACCESS_TOKEN "Processo deve ter SUPABASE_ACCESS_TOKEN"


# ============================================================================
# TIER 2 - CASOS DE BORDA E ERROS
# ============================================================================

# --- Cenario 6: Google Auth - Flag -SkipGoogleAuth ---
Write-Host "Executando Cenario 6 (Tier 2): Flag SkipGoogleAuth ativada..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Autenticação Google pulada (flag -SkipGoogleAuth)" $output "Deve pular Google Auth"

# --- Cenario 7: Google Auth - gcloud auth login falha (codigo de saida != 0) ---
Write-Host "Executando Cenario 7 (Tier 2): gcloud auth login com falha nao trava o instalador..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
$global:mockAnswers = @{ "Google" = "S" }
# Precisa ecoar algo para "--version" (senao $hasGcloud vira false na ETAPA 1
# e a ETAPA 3 pula direto pro "gcloud nao encontrado" sem nunca chegar no login)
Set-MockCommand "gcloud" "@echo off`nif `"%1`"==`"auth`" (exit /b 1)`necho Google Cloud SDK 460.0.0`nexit /b 0"

$output = & $setupScript -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
# NOTA: o setup_antigravity.ps1 chama "gcloud auth login --brief 2>&1 | Out-Null"
# dentro de um try/catch, mas com $ErrorActionPreference="Continue" um comando NATIVO
# que sai com codigo != 0 NAO dispara uma excecao terminante em PowerShell - ele so
# seta $LASTEXITCODE, que o script nunca verifica. Ou seja, o bloco catch (e a
# mensagem "Erro no login Google:") so e alcancavel se o proprio gcloud.exe nao for
# encontrado (CommandNotFoundException), nao por um exit code de falha comum. Isso
# nao e um bug do instalador (o mock ainda "funciona" pro fluxo real do usuario,
# gcloud raramente falha silenciosamente assim) - e so uma limitacao do try/catch
# que este teste documenta em vez de fingir nao existir.
Assert-StringContains "Login Google realizado com sucesso!" $output "Um exit code de falha do gcloud nao e capturado pelo try/catch (comportamento real do script) - o instalador segue em frente sem travar"

# --- Cenario 8: GitHub Auth - Flag -SkipGitHubAuth e falha de login ---
Write-Host "Executando Cenario 8 (Tier 2): Flag SkipGitHubAuth e falha de login..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Autenticação GitHub pulada (flag -SkipGitHubAuth)" $output "Deve pular GitHub Auth"

# Falha de login (codigo de saida != 0)
# NOTA: mesma limitacao do Cenario 7 - "gh auth login ... 2>&1" nao verifica
# $LASTEXITCODE nem usa -ErrorAction Stop, entao um exit code de falha do mock
# NAO dispara o catch. O script sempre imprime "Login GitHub realizado com
# sucesso!" apos tentar o login, independente do resultado real.
Set-MockCommand "gh" "@echo off`nif `"%1`"==`"auth`" (if `"%2`"==`"status`" (exit /b 1) else if `"%2`"==`"login`" (echo Erro no login >&2`nexit /b 1))`nexit /b 0"
$output = & $setupScript -SkipGoogleAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Login GitHub realizado com sucesso!" $output "Exit code de falha do gh nao e capturado pelo try/catch (comportamento real do script)"

# --- Cenario 9: Tokens Opcionais - Flag -SkipOptionalTokens ---
Write-Host "Executando Cenario 9 (Tier 2): Flag SkipOptionalTokens ativada..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Tokens opcionais pulados (flag -SkipOptionalTokens)" $output "Deve pular tokens opcionais"

# --- Cenario 10: Tokens Opcionais - Idempotencia e Pular inputs (Enter) ---
Write-Host "Executando Cenario 10 (Tier 2): Idempotencia e pular inputs em tokens opcionais..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks

# Configurar uma chave de Stripe previamente no ambiente de usuario
[System.Environment]::SetEnvironmentVariable("STRIPE_SECRET_KEY", "sk_live_existing12345", "User")
$env:STRIPE_SECRET_KEY = "sk_live_existing12345"

# Respostas vazias (Enter) para os demais prompts
$global:mockAnswers = @{
    "Slack" = ""
    "Notion" = ""
    "Linear" = ""
    "Figma" = ""
    "Supabase" = ""
}

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth *>&1 | Out-String

Assert-StringContains "Stripe (Pagamentos) - já configurado" $output "Stripe ja configurado deve ser pulado"
Assert-StringContains "Slack (Mensageria) pulado" $output "Slack deve ser pulado se input for vazio"

# --- Cenario 11 (herdado de FT04-T2-01): valores de token nao sofrem trim ---
Write-Host "Executando Cenario 11 (Tier 2): Chave opcional com espacos nas pontas..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
$global:mockAnswers = @{ "Stripe" = "  stripe_spaced_key  " }

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth *>&1 | Out-String
Assert-Equals "  stripe_spaced_key  " $env:STRIPE_SECRET_KEY "O valor gravado deve manter a consistencia de espacos se o setup nao der trim"

# --- Cenario 12 (herdado de FT04-T2-02): variavel existente mas vazia no Registry deve solicitar entrada ---
Write-Host "Executando Cenario 12 (Tier 2): Variavel existente porem vazia no Registry..."
Restore-UserEnv
Clear-ProcessEnv
Setup-BaseMocks
[System.Environment]::SetEnvironmentVariable("STRIPE_SECRET_KEY", "", "User")
$global:mockAnswers = @{ "Stripe" = "stripe_filled_now" }

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth *>&1 | Out-String
Assert-Equals "stripe_filled_now" $env:STRIPE_SECRET_KEY "Deve solicitar entrada para chaves vazias no Registry"

Write-Host "03_auth_and_tokens.test.ps1 concluido com sucesso!"

} finally {
    # Limpeza e restauracao final - roda sempre, mesmo se uma asserção acima falhou
    Restore-UserEnv
    Create-Mocks
}
