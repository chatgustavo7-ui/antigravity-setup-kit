# Caso de Teste E2E para Pre-requisitos, Diretorios e Regras Globais
Write-Host "Iniciando 02_prereqs_and_directories.test.ps1"

# Funcoes Auxiliares de Limpeza para os testes
function Reset-TestSandbox {
    Write-Host "  [Sandbox] Resetando pastas de teste..."
    if (Test-Path $env:USERPROFILE\.gemini) {
        Remove-Item -Path $env:USERPROFILE\.gemini -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    if (Test-Path $env:ANTIGRAVITY_WORKSPACE_PATH) {
        Remove-Item -Path $env:ANTIGRAVITY_WORKSPACE_PATH -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    # Recriar caminhos basicos
    New-Item -ItemType Directory -Path $env:USERPROFILE -Force | Out-Null
    New-Item -ItemType Directory -Path $env:ANTIGRAVITY_WORKSPACE_PATH -Force | Out-Null

    # Limpar log de chamadas
    if (Test-Path $env:MOCK_LOG_PATH) {
        Clear-Content $env:MOCK_LOG_PATH -ErrorAction SilentlyContinue | Out-Null
    }
}

# Criar mocks temporarios especificos
function Set-MockCommand {
    param([string]$Name, [string]$Content)
    $path = Join-Path $mocksDir "$Name.cmd"
    $Content | Out-File -FilePath $path -Encoding ascii -Force
}

function Remove-MockCommand {
    param([string]$Name)
    $path = Join-Path $mocksDir "$Name.cmd"
    if (Test-Path $path) {
        Remove-Item -Path $path -Force -ErrorAction SilentlyContinue | Out-Null
    }
}

# ============================================================================
# TIER 1 - HAPPY-PATHS (5 CENARIOS)
# ============================================================================

# --- Cenario 1: Pre-requisitos OK com todas as CLIs validas ---
Write-Host "Executando Cenario 1 (Tier 1): Pre-requisitos em ordem..."
Reset-TestSandbox

# Criar mocks ideais
Set-MockCommand "node" "@echo off`necho v20.11.0"
Set-MockCommand "python" "@echo off`necho Python 3.11.5"
Set-MockCommand "git" "@echo off`necho git version 2.43.0"
Set-MockCommand "gh" "@echo off`necho gh version 2.40.0"
Set-MockCommand "gcloud" "@echo off`necho Google Cloud SDK 460.0.0"
Set-MockCommand "bun" "@echo off`necho 1.0.25"

# Executar apenas verificacao rodando o setup com flags para pular auth interativa
$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String

Assert-StringContains "Node.js v20.11.0 (>= 20" $output "Node.js deve ser validado com sucesso"
Assert-StringContains "Python 3.11.5 (>= 3.10" $output "Python deve ser validado com sucesso"
Assert-StringContains "git version 2.43.0" $output "Git deve ser validado com sucesso"
Assert-StringContains "gh version 2.40.0" $output "GitHub CLI deve ser validado com sucesso"
Assert-StringContains "Google Cloud CLI: Google Cloud SDK 460.0.0" $output "gcloud deve ser validado com sucesso"

# --- Cenario 2: Criacao do Enterprise Workspace com as 13 pastas verticais ---
Write-Host "Executando Cenario 2 (Tier 1): Criacao do Enterprise Workspace e verticais..."
# O setup ja rodou no cenario 1, entao validamos se criou as pastas verticais corretas
$verticais = @(
    "01_RH_e_Pessoas", "02_Juridico_e_Compliance", "03_Financeiro_e_Administrativo",
    "04_Estrategia_Operacoes_Processos", "05_Comunicacao_Interna", "06_Educacao",
    "07_Contabilidade", "08_SaaS_e_Tecnologia", "09_Industria_Franquias_Distribuicao",
    "10_Agro_e_Agronegocio", "11_Construcao_Civil_Imobiliario",
    "12_Financas_Consultoria_Servicos_Locais", "13_Desenvolvimento_Jogos_Plugins_UI"
)

foreach ($v in $verticais) {
    $vPath = Join-Path $env:ANTIGRAVITY_WORKSPACE_PATH $v
    Assert-True (Test-Path $vPath) "A pasta vertical $v deve existir no Enterprise Workspace"
}

# --- Cenario 3: Copia de skills gerais e verticais ---
Write-Host "Executando Cenario 3 (Tier 1): Copia e distribuicao de skills..."
# Verificar skills verticais copiadas para cada pasta
$vertMap = @{
    "rh-e-pessoas" = "01_RH_e_Pessoas"
    "juridico-e-compliance" = "02_Juridico_e_Compliance"
    "financeiro-e-administrativo" = "03_Financeiro_e_Administrativo"
}
foreach ($key in $vertMap.Keys) {
    $vDir = $vertMap[$key]
    $skillMd = Join-Path $env:ANTIGRAVITY_WORKSPACE_PATH "$vDir\SKILL.md"
    Assert-FileExists $skillMd "O arquivo SKILL.md de $vDir deve ser copiado"
}

# Verificar skills gerais copiadas para .gemini/config/skills
$skillsConfigDir = Join-Path $env:USERPROFILE ".gemini\config\skills"
Assert-True (Test-Path $skillsConfigDir) "Diretorio de skills configurado deve existir"
$skillsGerais = Get-ChildItem -Path $skillsConfigDir -Directory
Assert-True ($skillsGerais.Count -gt 0) "Deve conter skills gerais instaladas"

# --- Cenario 4: Idempotencia do Instalador (segunda execucao) ---
Write-Host "Executando Cenario 4 (Tier 1): Idempotencia..."
# Modificar um arquivo de skill vertical para testar idempotencia (verticais sao sempre sobrescritas por design)
$rhSkillPath = Join-Path $env:ANTIGRAVITY_WORKSPACE_PATH "01_RH_e_Pessoas\SKILL.md"
Assert-FileExists $rhSkillPath "O SKILL.md vertical deve existir antes do teste de idempotencia"

# Skills gerais NAO devem ser sobrescritas se ja existirem (setup usa 'if (-not (Test-Path $destSkill))')
$umaSkillGeral = $skillsGerais | Select-Object -First 1
$skillGeralPath = Join-Path $skillsConfigDir "$($umaSkillGeral.Name)\SKILL.md"
if (Test-Path $skillGeralPath) {
    $customContent = "Conteudo customizado de teste para testar idempotencia"
    Set-Content -Path $skillGeralPath -Value $customContent -Encoding utf8

    & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String | Out-Null

    $currentContent = Get-Content $skillGeralPath -Raw
    Assert-True ($currentContent.Contains($customContent)) "Skills gerais ja instaladas nao devem ser sobrescritas (idempotencia)"
}

# ============================================================================
# TIER 2 - CASOS DE BORDA E ERROS (5 CENARIOS)
# ============================================================================

# --- Cenario 5: Node.js versao menor que 20 ---
Write-Host "Executando Cenario 5 (Tier 2): Node.js com versao insuficiente..."
Reset-TestSandbox
Set-MockCommand "node" "@echo off`necho v18.10.0"

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Node.js v18.10.0 encontrado, mas precisa >= 20" $output "Deve avisar que versao de Node e insuficiente"

# --- Cenario 6: Python versao menor que 3.10 ---
Write-Host "Executando Cenario 6 (Tier 2): Python com versao insuficiente..."
Reset-TestSandbox
Set-MockCommand "node" "@echo off`necho v20.11.0"
Set-MockCommand "python" "@echo off`necho Python 3.9.18"

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Python 3.9.18 encontrado, mas precisa >= 3.10" $output "Deve avisar que versao de Python e insuficiente"

# --- Cenario 7: Ferramentas criticas ausentes no PATH ---
Write-Host "Executando Cenario 7 (Tier 2): Ferramentas criticas ausentes..."
Reset-TestSandbox
Set-MockCommand "node" "@echo off`nexit /b 9009"
Set-MockCommand "python" "@echo off`necho Comando Invalido >&2`nexit /b 1"
Set-MockCommand "git" "@echo off`nexit /b 9009"
Set-MockCommand "gh" "@echo off`nexit /b 9009"

$output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
Assert-StringContains "Node.js não encontrado" $output "Deve avisar que Node.js esta ausente"
Assert-StringContains "Git não encontrado" $output "Deve avisar que Git esta ausente"
Assert-StringContains "GitHub CLI não encontrado" $output "Deve avisar que GitHub CLI esta ausente"

# --- Cenario 8: Ausencia da pasta de skills de origem ---
Write-Host "Executando Cenario 8 (Tier 2): Pasta de skills de origem ausente..."
Reset-TestSandbox
# Restaurar mocks ideais primeiro
Set-MockCommand "node" "@echo off`necho v20.11.0"
Set-MockCommand "python" "@echo off`necho Python 3.11.5"
Set-MockCommand "git" "@echo off`necho git version 2.43.0"
Set-MockCommand "gh" "@echo off`necho gh version 2.40.0"

# Mover a pasta skills temporariamente
$originalSkillsPath = Join-Path $projectRoot "skills"
$tempSkillsPath = Join-Path $projectRoot "skills_temp_e2e"

if (Test-Path $originalSkillsPath) {
    Rename-Item -Path $originalSkillsPath -NewName "skills_temp_e2e" -Force
}

try {
    $output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
    Assert-StringContains "Pasta skills/ não encontrada no kit" $output "Deve acusar que pasta de skills de origem nao existe"
}
finally {
    # Restaurar a pasta original sob qualquer circunstancia
    if (Test-Path $tempSkillsPath) {
        Rename-Item -Path $tempSkillsPath -NewName "skills" -Force
    }
}

# --- Cenario 9: Modelos de config_templates ausentes ---
Write-Host "Executando Cenario 9 (Tier 2): Templates de configuracao ausentes..."
Reset-TestSandbox

$originalTemplatesPath = Join-Path $projectRoot "config_templates"
$tempTemplatesPath = Join-Path $projectRoot "config_templates_temp_e2e"

if (Test-Path $originalTemplatesPath) {
    Rename-Item -Path $originalTemplatesPath -NewName "config_templates_temp_e2e" -Force
}

try {
    $output = & $setupScript -SkipGoogleAuth -SkipGitHubAuth -SkipOptionalTokens *>&1 | Out-String
    Assert-StringContains "Template CLI não encontrado" $output "Deve alertar sobre a falta de templates CLI"
    Assert-StringContains "Template IDE não encontrado" $output "Deve alertar sobre a falta de templates IDE"
}
finally {
    if (Test-Path $tempTemplatesPath) {
        Rename-Item -Path $tempTemplatesPath -NewName "config_templates" -Force
    }
}

# Limpeza e restauracao final de mocks
Create-Mocks
Write-Host "02_prereqs_and_directories.test.ps1 concluido com sucesso!"
