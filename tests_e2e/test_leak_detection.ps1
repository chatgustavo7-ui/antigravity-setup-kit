# Script de Teste para Detecção de Vazamento de Variáveis de Ambiente
# Verifica que o runner de testes E2E restaura corretamente o ambiente do
# processo pai apos executar a suite - nenhuma variavel da sandbox deve vazar.

$ErrorActionPreference = "Stop"

Write-Output "=== PASSO 1: Capturando variaveis de ambiente originais ==="
$envVarsAntes = @{}
$varsParaTestar = @(
    "APPDATA",
    "LOCALAPPDATA",
    "USERPROFILE",
    "HOMEPATH",
    "TEMP",
    "TMP",
    "ANTIGRAVITY_WORKSPACE_PATH",
    "MOCK_LOG_PATH",
    "PATH",
    "ANTIGRAVITY_NON_INTERACTIVE",
    "CI"
)

foreach ($var in $varsParaTestar) {
    $val = [Environment]::GetEnvironmentVariable($var, [System.EnvironmentVariableTarget]::Process)
    $envVarsAntes[$var] = $val
    Write-Output "  $var = $val"
}

# Modificar o runner para substituir exit por return para podermos executá-lo no mesmo processo sem fechar a sessão
$runnerPath = Join-Path $PSScriptRoot "run_tests.ps1"
$tempRunnerPath = Join-Path $PSScriptRoot "run_tests_temp_wrapper.ps1"

Write-Output "`n=== PASSO 2: Criando wrapper temporario do runner ==="
$runnerContent = Get-Content -Path $runnerPath -Raw
# Substitui 'exit 0' e 'exit 1' por return de forma segura
$runnerContentMod = $runnerContent -replace '\bexit\s+0\b', 'Write-Output "[WRAPPER] Interceptado exit 0"; return'
$runnerContentMod = $runnerContentMod -replace '\bexit\s+1\b', 'Write-Output "[WRAPPER] Interceptado exit 1"; return'

$runnerContentMod | Out-File -FilePath $tempRunnerPath -Encoding utf8 -Force
Write-Output "Wrapper temporario criado em: $tempRunnerPath"

Write-Output "`n=== PASSO 3: Executando o runner no mesmo processo ==="
try {
    . $tempRunnerPath
}
catch {
    Write-Output "Erro durante a execucao do runner: $_"
}

Write-Output "`n=== PASSO 4: Comparando variaveis de ambiente apos a execucao ==="
$vazou = $false
foreach ($var in $varsParaTestar) {
    $valDepois = [Environment]::GetEnvironmentVariable($var, [System.EnvironmentVariableTarget]::Process)
    $valAntes = $envVarsAntes[$var]

    if ($valAntes -ne $valDepois) {
        Write-Output "ALERTA: Variavel de ambiente '$var' mudou!"
        Write-Output "  Antes:  $valAntes"
        Write-Output "  Depois: $valDepois"
        $vazou = $true
    } else {
        $msg = "  " + $var + ": OK (Inalterada)"
        Write-Output $msg
    }
}

# Limpeza
if (Test-Path $tempRunnerPath) {
    Remove-Item -Path $tempRunnerPath -Force
}

if ($vazou) {
    Write-Output "`n[RESULTADO] DETECTADO VAZAMENTO DE VARIÁVEIS DE AMBIENTE!"
    exit 1
} else {
    Write-Output "`n[RESULTADO] Sucesso: Nenhuma variavel de ambiente vazou no processo pai."
    exit 0
}
