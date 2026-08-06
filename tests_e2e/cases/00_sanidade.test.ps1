# Caso de Teste E2E de Sanidade e Isolamento da Sandbox
Write-Host "Executando assertivas de sanidade..."

# 1. Verificar caminhos da Sandbox
Assert-True ($env:USERPROFILE -like "*tests_e2e\sandbox\userprofile*") "USERPROFILE deve apontar para a sandbox"
Assert-True ($env:APPDATA -like "*tests_e2e\sandbox\userprofile\AppData\Roaming*") "APPDATA deve apontar para a sandbox"
Assert-True ($env:LOCALAPPDATA -like "*tests_e2e\sandbox\userprofile\AppData\Local*") "LOCALAPPDATA deve apontar para a sandbox"
Assert-True ($env:TEMP -like "*tests_e2e\sandbox\temp*") "TEMP deve apontar para a sandbox"
Assert-True ($env:TMP -like "*tests_e2e\sandbox\temp*") "TMP deve apontar para a sandbox"
Assert-True ($env:ANTIGRAVITY_WORKSPACE_PATH -like "*tests_e2e\sandbox\Enterprise_Agentic_Workspace*") "ANTIGRAVITY_WORKSPACE_PATH deve apontar para a sandbox"

# As pastas físicas correspondentes devem existir
Assert-True (Test-Path $env:USERPROFILE) "Pasta USERPROFILE fisica deve existir"
Assert-True (Test-Path $env:APPDATA) "Pasta APPDATA fisica deve existir"
Assert-True (Test-Path $env:LOCALAPPDATA) "Pasta LOCALAPPDATA fisica deve existir"
Assert-True (Test-Path $env:TEMP) "Pasta TEMP fisica deve existir"
Assert-True (Test-Path $env:ANTIGRAVITY_WORKSPACE_PATH) "Pasta ANTIGRAVITY_WORKSPACE_PATH fisica deve existir"

# 2. Testar mock do gcloud
$gcloudInfo = cmd.exe /c "gcloud info"
Assert-StringContains "gcloud CLI instalada. Versao 999.0.0" $gcloudInfo "O mock do gcloud deve ser invocado e retornar a versao mockada"

$gcloudProj = cmd.exe /c "gcloud config get-value project"
Assert-StringContains "mock-gcp-project-id" $gcloudProj "O mock do gcloud deve retornar o ID do projeto mockado"

# 3. Testar mock do gh
$ghStatus = cmd.exe /c "gh auth status"
Assert-StringContains "logged in to github.com as MockUser" $ghStatus "O mock do gh deve ser invocado e retornar o usuario mockado"

# 4. Testar mock do npm/npx
cmd.exe /c "npm install -g algum-pacote" | Out-Null
cmd.exe /c "npx -y algum-servidor" | Out-Null

# 5. Verificar mock_calls.log
Assert-True (Test-Path $env:MOCK_LOG_PATH) "O arquivo mock_calls.log deve existir"
$logContent = Get-Content $env:MOCK_LOG_PATH -Raw
Assert-StringContains "gcloud info" $logContent "O log deve registrar a chamada do gcloud info"
Assert-StringContains "gcloud config get-value project" $logContent "O log deve registrar a chamada do gcloud config get-value project"
Assert-StringContains "gh auth status" $logContent "O log deve registrar a chamada do gh auth status"
Assert-StringContains "npm install -g algum-pacote" $logContent "O log deve registrar a chamada do npm install"
Assert-StringContains "npx -y algum-servidor" $logContent "O log deve registrar a chamada do npx"

# 6. Testar mock de Read-Host
$readHostVal = Read-Host -Prompt "Insira a chave de API:"
Assert-Equals "mock-api-key-12345" $readHostVal "Read-Host deve retornar a chave de API mockada"
