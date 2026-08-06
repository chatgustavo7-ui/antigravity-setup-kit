# Caso de Teste E2E para o Security Check (Scanner de Segredos)
Write-Host "Iniciando 05_security_check.test.ps1"

# Funcao para resetar e limpar a pasta temporaria de escaneamento
$scanTempDir = Join-Path $env:TEMP "security_scan_test"
function Reset-ScanFolder {
    if (Test-Path $scanTempDir) {
        Remove-Item -Path $scanTempDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    New-Item -ItemType Directory -Path $scanTempDir -Force | Out-Null
}

# ============================================================================
# TIER 1 - HAPPY-PATHS (5 CENARIOS)
# ============================================================================

# --- Cenario 1: Scan limpo em pasta com arquivos normais ---
Write-Host "Executando Cenario 1 (Tier 1): Scan limpo em pasta normal..."
Reset-ScanFolder
Set-Content -Path (Join-Path $scanTempDir "config.json") -Value "{ `"port`": 8080, `"host`": `"localhost`" }" -Encoding UTF8
Set-Content -Path (Join-Path $scanTempDir "README.md") -Value "# Projeto Legal`nEste e um projeto seguro." -Encoding UTF8

$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "NENHUM SEGREDO ENCONTRADO - Tudo seguro!" $output "Scanner deve reportar pasta como limpa"
Assert-StringContains "2 arquivos escaneados" $output "Deve contar 2 arquivos escaneados"

# --- Cenario 2: Extensoes de arquivo suportadas sem segredos ---
Write-Host "Executando Cenario 2 (Tier 1): Validando multiplas extensoes limpas..."
Reset-ScanFolder
$exts = @("yaml", "toml", "ini", "ps1", "py", "js", "ts")
foreach ($ext in $exts) {
    Set-Content -Path (Join-Path $scanTempDir "file.$ext") -Value "# Sem segredos aqui" -Encoding UTF8
}
$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "NENHUM SEGREDO ENCONTRADO" $output "Tudo deve estar limpo"
Assert-StringContains "7 arquivos escaneados" $output "Deve contar todos os 7 arquivos escaneados"

# --- Cenario 3: Pastas excluidas sao ignoradas pelo scanner ---
Write-Host "Executando Cenario 3 (Tier 1): Pastas excluidas (.git, node_modules) ignoradas..."
Reset-ScanFolder
# Criar pasta excluida e colocar um arquivo com segredo nela
$ignoredDir1 = Join-Path $scanTempDir "node_modules\algum-pacote"
$ignoredDir2 = Join-Path $scanTempDir ".git"
New-Item -ItemType Directory -Path $ignoredDir1 -Force | Out-Null
New-Item -ItemType Directory -Path $ignoredDir2 -Force | Out-Null

# Colocar valores no formato de chave Stripe/GitHub (fake, montados por
# concatenacao para nao disparar o secret-scanning do GitHub) para testar a exclusao
$fakeStripeKey1 = "sk_" + "live_" + "123456789012345678901234"
$fakeGhPat1 = "ghp_" + "1234567890123456789012345678901234" + "56"
Set-Content -Path (Join-Path $ignoredDir1 "vazamento.js") -Value "const key = '$fakeStripeKey1';" -Encoding UTF8
Set-Content -Path (Join-Path $ignoredDir2 "config") -Value "token = $fakeGhPat1" -Encoding UTF8

$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "NENHUM SEGREDO ENCONTRADO" $output "Nao deve reportar segredos nas pastas excluidas"
Assert-StringContains "0 arquivos escaneados" $output "Nenhum arquivo deve ser contabilizado"

# --- Cenario 4: Extensoes nao mapeadas contendo segredos sao ignoradas ---
Write-Host "Executando Cenario 4 (Tier 1): Extensoes nao monitoradas sao ignoradas..."
Reset-ScanFolder
$fakeStripeKey2 = "sk_" + "live_" + "123456789012345678901234"
$fakeGhPat2 = "ghp_" + "1234567890123456789012345678901234" + "56"
Set-Content -Path (Join-Path $scanTempDir "foto.png") -Value $fakeStripeKey2 -Encoding UTF8
Set-Content -Path (Join-Path $scanTempDir "dados.zip") -Value $fakeGhPat2 -Encoding UTF8

$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "NENHUM SEGREDO ENCONTRADO" $output "Extensoes nao suportadas devem ser ignoradas"
Assert-StringContains "0 arquivos escaneados" $output "Arquivos nao devem ser escaneados"

# --- Cenario 5: Execucao com Verbose ---
Write-Host "Executando Cenario 5 (Tier 1): Modo Verbose ativado..."
Reset-ScanFolder
Set-Content -Path (Join-Path $scanTempDir "config.json") -Value "{}" -Encoding UTF8
$output = & $securityCheckScript -ScanPath $scanTempDir -Verbose *>&1 | Out-String
Assert-StringContains "SCANNER DE SEGREDOS" $output "Deve conter cabecalho do scanner"
Assert-StringContains "1 arquivos escaneados" $output "Deve contabilizar arquivo escaneado"


# ============================================================================
# TIER 2 - CASOS DE BORDA E ERROS (5 CENARIOS)
# ============================================================================

# --- Cenario 6: Vazamento de GitHub PAT Classico ---
Write-Host "Executando Cenario 6 (Tier 2): Vazamento de GitHub PAT classico..."
Reset-ScanFolder
# ghp_ seguido de 36 caracteres alfanumericos
# Montado por concatenacao (nao como string literal contigua) para nao disparar
# o secret-scanning do GitHub Push Protection - e um valor de teste, nao um token real.
$ghPat = "ghp_" + "AbCdEfGhIjKlMnOpQrStUvWxYz" + "0123456789"
Set-Content -Path (Join-Path $scanTempDir "auth.env") -Value "token=$ghPat" -Encoding UTF8

$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "SEGREDO(S) POTENCIAL(IS) ENCONTRADO(S)!" $output "Deve encontrar segredos vazados"
Assert-StringContains "GitHub PAT (clássico)" $output "Deve identificar tipo correto: GitHub PAT classico"

# --- Cenario 7: Vazamento de Stripe Secret Key ---
Write-Host "Executando Cenario 7 (Tier 2): Vazamento de Stripe Secret Key..."
Reset-ScanFolder
$stripeKey = "sk_" + "test_" + "123456789012345678901234" # 24 chars depois de sk_test_
Set-Content -Path (Join-Path $scanTempDir "payment.py") -Value "stripe_key = `"$stripeKey`"" -Encoding UTF8

$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "SEGREDO(S) POTENCIAL(IS) ENCONTRADO(S)!" $output "Deve encontrar segredos vazados"
Assert-StringContains "Stripe Secret Key" $output "Deve identificar tipo correto: Stripe Secret Key"

# --- Cenario 8: Vazamento Multiplo de Chaves ---
Write-Host "Executando Cenario 8 (Tier 2): Vazamento multiplo de chaves no mesmo arquivo e arquivos diferentes..."
Reset-ScanFolder
$stripeKey2 = "sk_" + "live_" + "123456789012345678901234"
$ghPat2 = "ghp_" + "1234567890123456789012345678901234" + "56"
Set-Content -Path (Join-Path $scanTempDir "secrets.json") -Value "{ `"stripe`": `"$stripeKey2`", `"github`": `"$ghPat2`" }" -Encoding UTF8
$slackWebhook = "https://hooks.slack.com/services/" + "T12345678/B12345678/123456789012345678901234"
Set-Content -Path (Join-Path $scanTempDir "slack.yaml") -Value "slack_webhook: $slackWebhook" -Encoding UTF8

$output = & $securityCheckScript -ScanPath $scanTempDir *>&1 | Out-String
Assert-StringContains "3 SEGREDO(S) POTENCIAL(IS) ENCONTRADO(S)!" $output "Deve encontrar exatamente 3 segredos"
Assert-StringContains "Stripe Secret Key" $output "Deve reportar Stripe"
Assert-StringContains "GitHub PAT (clássico)" $output "Deve reportar GitHub"
Assert-StringContains "Slack Webhook URL" $output "Deve reportar Slack Webhook"

# --- Cenario 9: Caminho de Scan Inexistente ---
Write-Host "Executando Cenario 9 (Tier 2): Caminho de scan inexistente..."
$nonExistentPath = Join-Path $scanTempDir "pasta_que_nao_existe"

$output = & $securityCheckScript -ScanPath $nonExistentPath *>&1 | Out-String
Assert-StringContains "NENHUM SEGREDO ENCONTRADO" $output "Deve rodar sem erros catastoficos"
Assert-StringContains "0 arquivos escaneados" $output "Deve reportar 0 arquivos escaneados"

# --- Cenario 10: Arquivos Ilegiveis (Simulando Bloqueio) ---
Write-Host "Executando Cenario 10 (Tier 2): Lidar com arquivos ilegiveis..."
Reset-ScanFolder
$lockedFile = Join-Path $scanTempDir "locked.json"
$stripeKey3 = "sk_" + "live_" + "123456789012345678901234"
Set-Content -Path $lockedFile -Value "{ `"secret`": `"$stripeKey3`" }" -Encoding UTF8

# Criar outro arquivo legivel para garantir que o scanner prossegue
Set-Content -Path (Join-Path $scanTempDir "readable.json") -Value "{}" -Encoding UTF8

# Bloquear acesso de leitura ao locked.json
# No Windows, podemos usar ACL para negar a leitura ao usuario atual
$acl = Get-Acl $lockedFile
$username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($username, "Read", "Deny")
$acl.AddAccessRule($rule)
Set-Acl $lockedFile $acl

try {
    # Executar scanner no modo Verbose
    $output = & $securityCheckScript -ScanPath $scanTempDir -Verbose *>&1 | Out-String

    # O Get-Content do scanner usa -ErrorAction SilentlyContinue (nao lanca excecao),
    # entao o arquivo bloqueado e simplesmente pulado sem nenhum aviso, mesmo em modo Verbose.
    # Validamos que isso nao quebra o scan e que o segredo do arquivo bloqueado nao vaza no resultado.
    Assert-StringContains "NENHUM SEGREDO ENCONTRADO" $output "Deve reportar limpo ja que nao leu o segredo do arquivo bloqueado"
}
finally {
    # Remover regra de Deny para permitir exclusao na limpeza
    $acl = Get-Acl $lockedFile
    $acl.RemoveAccessRule($rule) | Out-Null
    Set-Acl $lockedFile $acl
    Reset-ScanFolder
}

Write-Host "05_security_check.test.ps1 concluido com sucesso!"
