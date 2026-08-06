<#
.SYNOPSIS
    Runner de Testes E2E - Antigravity Setup Kit
.DESCRIPTION
    Script para executar testes E2E de forma isolada (sandbox),
    com mocks de comandos em PATH e geração de relatórios estruturados.
.NOTES
    Este script foi projetado para rodar no Windows PowerShell e PowerShell Core.
    Execute a partir de qualquer diretório: powershell -File .\tests_e2e\run_tests.ps1
#>

$ErrorActionPreference = "Stop"

# Caminhos do projeto (resolvidos de forma relativa ao proprio script, nao mais fixos em c:\Antigravity)
$testsDir = $PSScriptRoot
$projectRoot = Split-Path -Parent $testsDir
$reportsDir = Join-Path $testsDir "reports"
$sandboxRoot = Join-Path $testsDir "sandbox"
$mocksDir = Join-Path $testsDir "mocks"

# Scripts sob teste - expostos como variaveis de script para os casos de teste (dot-sourced) usarem
# em vez de caminhos absolutos fixos
$script:setupScript = Join-Path $projectRoot "setup_antigravity.ps1"
$script:securityCheckScript = Join-Path $projectRoot "security_check.ps1"

# Definição das variáveis de ambiente da sandbox
$sandboxUserProfile = Join-Path $sandboxRoot "userprofile"
$sandboxAppData = Join-Path $sandboxUserProfile "AppData\Roaming"
$sandboxLocalAppData = Join-Path $sandboxUserProfile "AppData\Local"
$sandboxTemp = Join-Path $sandboxRoot "temp"
$sandboxWorkspace = Join-Path $sandboxRoot "Enterprise_Agentic_Workspace"
$mockLogPath = Join-Path $sandboxRoot "mock_calls.log"

# Cores do console
$colorSuccess = "Green"
$colorFailure = "Red"
$colorWarning = "Yellow"
$colorInfo = "Cyan"

# Função de log formatado
function Write-TestLog {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [ValidateSet("Info", "Success", "Error", "Warning")]
        [string]$Level = "Info"
    )
    $color = "White"
    $prefix = "[INFO]"
    switch ($Level) {
        "Success" { $color = $colorSuccess; $prefix = "[PASS]" }
        "Error"   { $color = $colorFailure;   $prefix = "[FAIL]" }
        "Warning" { $color = $colorWarning;   $prefix = "[WARN]" }
        "Info"    { $color = $colorInfo;      $prefix = "[INFO]" }
    }
    Write-Host "$prefix $(Get-Date -Format 'HH:mm:ss') - $Message" -ForegroundColor $color
}

# Inicialização e limpeza do ambiente sandbox
function Initialize-Environment {
    Write-TestLog "Inicializando pastas da sandbox..." -Level "Info"

    # Criar pastas principais
    New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
    New-Item -ItemType Directory -Path $sandboxRoot -Force | Out-Null
    New-Item -ItemType Directory -Path $mocksDir -Force | Out-Null

    # Limpar sandbox anterior se existir (incluindo mocks para forçar recriação limpa)
    if (Test-Path $sandboxRoot) {
        Get-ChildItem -Path $sandboxRoot -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    if (Test-Path $mocksDir) {
        Get-ChildItem -Path $mocksDir -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }

    # Recriar caminhos
    New-Item -ItemType Directory -Path $mocksDir -Force | Out-Null
    New-Item -ItemType Directory -Path $sandboxUserProfile -Force | Out-Null
    New-Item -ItemType Directory -Path $sandboxAppData -Force | Out-Null
    New-Item -ItemType Directory -Path $sandboxLocalAppData -Force | Out-Null
    New-Item -ItemType Directory -Path $sandboxTemp -Force | Out-Null
    New-Item -ItemType Directory -Path $sandboxWorkspace -Force | Out-Null

    # Criar os arquivos de mock cmd
    Create-Mocks
}

function Create-Mocks {
    $gcloudPath = Join-Path $mocksDir "gcloud.cmd"
    # Sem parênteses em ADC para não bugar o parser do CMD
    $gcloudMock = @"
@echo off
echo [MOCK-gcloud] executado com argumentos: %*
if defined MOCK_LOG_PATH (
    echo gcloud %* >> "%MOCK_LOG_PATH%"
)
if "%1"=="auth" (
    if "%2"=="login" (
        echo [MOCK-gcloud] Simulando fluxo de autenticacao gcloud com sucesso.
        exit /b 0
    )
    if "%2"=="application-default" (
        if "%3"=="login" (
            echo [MOCK-gcloud] Simulando login de Application Default Credentials ADC com sucesso.
            exit /b 0
        )
    )
)
if "%1"=="config" (
    if "%2"=="get-value" (
        if "%3"=="project" (
            echo mock-gcp-project-id
            exit /b 0
        )
    )
)
if "%1"=="info" (
    echo [MOCK-gcloud] gcloud CLI instalada. Versao 999.0.0
    exit /b 0
)
exit /b 0
"@
    $gcloudMock | Out-File -FilePath $gcloudPath -Encoding ascii -Force

    $ghPath = Join-Path $mocksDir "gh.cmd"
    $ghMock = @"
@echo off
echo [MOCK-gh] executado com argumentos: %*
if defined MOCK_LOG_PATH (
    echo gh %* >> "%MOCK_LOG_PATH%"
)
if "%1"=="auth" (
    if "%2"=="login" (
        echo [MOCK-gh] Simulando fluxo de autenticacao GitHub com sucesso.
        exit /b 0
    )
    if "%2"=="status" (
        echo [MOCK-gh] logged in to github.com as MockUser keyring
        exit /b 0
    )
)
exit /b 0
"@
    $ghMock | Out-File -FilePath $ghPath -Encoding ascii -Force

    $npmPath = Join-Path $mocksDir "npm.cmd"
    $npmMock = @"
@echo off
echo [MOCK-npm] executado com argumentos: %*
if defined MOCK_LOG_PATH (
    echo npm %* >> "%MOCK_LOG_PATH%"
)
exit /b 0
"@
    $npmMock | Out-File -FilePath $npmPath -Encoding ascii -Force

    $npxPath = Join-Path $mocksDir "npx.cmd"
    $npxMock = @"
@echo off
echo [MOCK-npx] executado com argumentos: %*
if defined MOCK_LOG_PATH (
    echo npx %* >> "%MOCK_LOG_PATH%"
)
exit /b 0
"@
    $npxMock | Out-File -FilePath $npxPath -Encoding ascii -Force

    # winget precisa ser mockado como "Obsidian ja instalado" - sem isso, o setup_antigravity.ps1
    # tentaria instalar o app de verdade na maquina que roda os testes (feature adicionada
    # depois que esta suite foi originalmente escrita, entao nao tinha mock nenhum para ela).
    $wingetPath = Join-Path $mocksDir "winget.cmd"
    $wingetMock = @"
@echo off
echo [MOCK-winget] executado com argumentos: %*
if defined MOCK_LOG_PATH (
    echo winget %* >> "%MOCK_LOG_PATH%"
)
if "%1"=="list" (
    echo Obsidian.Obsidian Obsidian 1.0.0 winget
    exit /b 0
)
exit /b 0
"@
    $wingetMock | Out-File -FilePath $wingetPath -Encoding ascii -Force
}

# --- FUNÇÕES DE ASSERÇÃO (ASSERTIONS) ---
function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "Falha na assercao: $Message. Esperava verdadeiro, mas obteve falso." }
}

function Assert-False {
    param([bool]$Condition, [string]$Message)
    if ($Condition) { throw "Falha na assercao: $Message. Esperava falso, mas obteve verdadeiro." }
}

function Assert-Equals {
    param($Expected, $Actual, [string]$Message)
    if ($Expected -ne $Actual) { throw "Falha na assercao: $Message. Esperava '$Expected', mas obteve '$Actual'." }
}

function Assert-StringContains {
    param([string]$Substring, [string]$String, [string]$Message)
    if ($null -eq $String -or -not $String.Contains($Substring)) { throw "Falha na assercao: $Message. A string nao contem '$Substring'. Conteudo obtido: `n$String" }
}

function Assert-FileExists {
    param([string]$Path, [string]$Message)
    if (-not (Test-Path $Path)) { throw "Falha na assercao: $Message. O arquivo no caminho '$Path' nao existe." }
}

# Mock local de Read-Host para simular inputs interativos
# Precisa ser global: para ficar visivel dentro de "& $setupScript" chamado
# de dentro da funcao Run-TestCase (ver comentario equivalente nos casos de teste).
function global:Read-Host {
    param([string]$Prompt)
    Write-TestLog "Read-Host interceptado com o prompt: '$Prompt'" -Level "Info"
    if ($Prompt -like "*API*" -or $Prompt -like "*key*" -or $Prompt -like "*chave*") {
        return "mock-api-key-12345"
    }
    return "mock-input"
}

# --- EXECUÇÃO DE TESTE INDIVIDUAL ---
function Run-TestCase {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TestFile
    )

    $testName = [System.IO.Path]::GetFileNameWithoutExtension($TestFile)
    Write-TestLog "Iniciando caso de teste: $testName" -Level "Info"

    # Garantir que a pasta Temp da sandbox esteja limpa e o log do mock resetado antes de cada teste
    if (Test-Path $sandboxTemp) {
        Remove-Item -Path (Join-Path $sandboxTemp "*") -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    New-Item -ItemType File -Path $mockLogPath -Force | Out-Null

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $status = "SUCESSO"
    $errorMessage = ""

    # Salvar estado atual do ambiente
    $oldAppData = $env:APPDATA
    $oldLocalAppData = $env:LOCALAPPDATA
    $oldUserProfile = $env:USERPROFILE
    $oldHomePath = $env:HOMEPATH
    $oldTemp = $env:TEMP
    $oldTmp = $env:TMP
    $oldAntigravityWorkspace = $env:ANTIGRAVITY_WORKSPACE_PATH
    $oldPath = $env:PATH
    $oldMockLogPath = $env:MOCK_LOG_PATH

    $oldCIExists = Test-Path "Env:CI"
    $oldCI = $env:CI
    $oldNonInteractiveExists = Test-Path "Env:ANTIGRAVITY_NON_INTERACTIVE"
    $oldNonInteractive = $env:ANTIGRAVITY_NON_INTERACTIVE

    try {
        # Redirecionar caminhos do ambiente para o sandbox
        $env:USERPROFILE = $sandboxUserProfile
        $env:APPDATA = $sandboxAppData
        $env:LOCALAPPDATA = $sandboxLocalAppData
        $env:TEMP = $sandboxTemp
        $env:TMP = $sandboxTemp
        $env:HOMEPATH = $sandboxUserProfile
        $env:ANTIGRAVITY_WORKSPACE_PATH = $sandboxWorkspace
        $env:MOCK_LOG_PATH = $mockLogPath

        # Variáveis adicionais sugeridas pela especificação
        $env:ANTIGRAVITY_NON_INTERACTIVE = "true"
        $env:CI = "true"

        # Adicionar pasta de mocks ao início do PATH
        $env:PATH = "$mocksDir;$oldPath"

        # Executar caso de teste via dot-sourcing
        . $TestFile

        Write-TestLog "Caso de teste concluido com sucesso: $testName" -Level "Success"
    }
    catch {
        $status = "FALHA"
        $errorMessage = $_.Exception.Message
        Write-TestLog "Falha no caso de teste '$testName': $errorMessage" -Level "Error"
    }
    finally {
        $stopwatch.Stop()

        # Restaurar estado original do ambiente
        $env:APPDATA = $oldAppData
        $env:LOCALAPPDATA = $oldLocalAppData
        $env:USERPROFILE = $oldUserProfile
        $env:HOMEPATH = $oldHomePath
        $env:TEMP = $oldTemp
        $env:TMP = $oldTmp
        $env:ANTIGRAVITY_WORKSPACE_PATH = $oldAntigravityWorkspace
        $env:MOCK_LOG_PATH = $oldMockLogPath
        $env:PATH = $oldPath

        if ($oldCIExists) {
            $env:CI = $oldCI
        } else {
            Remove-Item -Path "Env:CI" -ErrorAction SilentlyContinue | Out-Null
        }
        if ($oldNonInteractiveExists) {
            $env:ANTIGRAVITY_NON_INTERACTIVE = $oldNonInteractive
        } else {
            Remove-Item -Path "Env:ANTIGRAVITY_NON_INTERACTIVE" -ErrorAction SilentlyContinue | Out-Null
        }
    }

    return [PSCustomObject]@{
        Nome = $testName
        Status = $status
        DuracaoMs = $stopwatch.ElapsedMilliseconds
        Erro = $errorMessage
        ExecutadoEm = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }
}

# --- PROCESSAMENTO DOS CASOS DE TESTE ---

Initialize-Environment

$casesDir = Join-Path $testsDir "cases"
if (-not (Test-Path $casesDir)) {
    New-Item -ItemType Directory -Path $casesDir -Force | Out-Null
}

$testFiles = Get-ChildItem -Path $casesDir -Filter "*.test.ps1" | Sort-Object Name
Write-TestLog "Encontrados $($testFiles.Count) casos de teste para execucao." -Level "Info"

$testResults = @()

foreach ($file in $testFiles) {
    $result = Run-TestCase -TestFile $file.FullName
    $testResults += $result
}

# --- GERAR RELATÓRIOS ---

if ($testResults.Count -gt 0) {
    Write-TestLog "Compilando resultados e gerando relatorios..." -Level "Info"

    $totalTests = $testResults.Count
    $passed = @($testResults | Where-Object { $_.Status -eq "SUCESSO" }).Count
    $failed = @($testResults | Where-Object { $_.Status -eq "FALHA" }).Count
    $totalDuration = ($testResults | Measure-Object -Property DuracaoMs -Sum).Sum

    # Determinar status geral textual
    $statusGeral = "APROVADO"
    if ($failed -gt 0) {
        $statusGeral = "REPROVADO"
    }

    # 1. Gerar arquivo JSON estruturado
    $reportJsonPath = Join-Path $reportsDir "test_report.json"
    $reportObject = [PSCustomObject]@{
        Resumo = [PSCustomObject]@{
            Total = $totalTests
            Sucessos = $passed
            Falhas = $failed
            DuracaoTotalMs = $totalDuration
            DataExecucao = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        }
        Detalhes = $testResults
    }
    $reportObject | ConvertTo-Json -Depth 5 | Out-File -FilePath $reportJsonPath -Encoding utf8 -Force
    Write-TestLog "Relatorio JSON gravado em: $reportJsonPath" -Level "Success"

    # 2. Gerar relatório Markdown em Português (PT-BR)
    $reportMdPath = Join-Path $reportsDir "test_report.md"
    $mdHeader = @"
# Relatorio de Testes E2E - Antigravity Setup Kit

**Data de Execucao:** $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
**Duracao Total:** $($totalDuration) ms
**Status Geral:** $statusGeral

## Resumo dos Resultados

| Metrica | Valor |
|---|---|
| **Total de Testes** | $totalTests |
| **Sucessos** | $passed |
| **Falhas** | $failed |

## Detalhamento dos Casos de Teste

| Caso de Teste | Status | Duracao | Detalhes do Erro |
|---|---|---|---|
"@

    $mdRows = @()
    foreach ($r in $testResults) {
        $statusEmoji = "FALHA"
        if ($r.Status -eq "SUCESSO") {
            $statusEmoji = "SUCESSO"
        }
        $mdRows += "| $($r.Nome) | $statusEmoji | $($r.DuracaoMs) ms | $($r.Erro) |"
    }

    $mdContent = $mdHeader + "`n" + ($mdRows -join "`n")
    $mdContent | Out-File -FilePath $reportMdPath -Encoding utf8 -Force
    Write-TestLog "Relatorio Markdown gravado em: $reportMdPath" -Level "Success"

    # --- EXIBIÇÃO DO RESUMO FINAL NO CONSOLE ---
    Write-Host "`n==================================================" -ForegroundColor White
    Write-Host "          RESUMO FINAL DOS TESTES E2E" -ForegroundColor White
    Write-Host "==================================================" -ForegroundColor White
    Write-Host "  Total de Testes: $totalTests"
    Write-Host "  Sucessos:        $passed" -ForegroundColor Green
    Write-Host "  Falhas:          $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Gray" })
    Write-Host "  Tempo Total:     $($totalDuration) ms"
    Write-Host "==================================================" -ForegroundColor White

    if ($failed -gt 0) {
        Write-TestLog "A suite de testes E2E falhou com $failed erro(s)." -Level "Error"
        exit 1
    } else {
        Write-TestLog "Todos os testes foram executados com sucesso!" -Level "Success"
        exit 0
    }
} else {
    Write-TestLog "Nenhum caso de teste foi executado." -Level "Warning"
    exit 0
}
