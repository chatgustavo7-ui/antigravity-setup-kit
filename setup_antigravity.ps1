# ============================================================================
# 🚀 Antigravity Setup Kit - Instalador Automatizado
# ============================================================================
# Este script configura o ecossistema Google Antigravity (CLI + IDE) no Windows.
# Foco em Google Login como autenticação principal.
# Idempotente: pode ser executado múltiplas vezes sem problemas.
# ============================================================================

param(
    [switch]$SkipGoogleAuth,
    [switch]$SkipGitHubAuth,
    [switch]$SkipOptionalTokens
)

$ErrorActionPreference = "Continue"
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$UserHome = $env:USERPROFILE
$GeminiDir = Join-Path $UserHome ".gemini"
$GeminiConfig = Join-Path $GeminiDir "config"
$AntigravityDir = Join-Path $GeminiDir "antigravity"
$AntigravityIdeDir = Join-Path $GeminiDir "antigravity-ide"
$EnterpriseWorkspace = if ($env:ANTIGRAVITY_WORKSPACE_PATH) { $env:ANTIGRAVITY_WORKSPACE_PATH } else { "$env:USERPROFILE\Antigravity_Workspace" }

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

function Write-Step { param($msg) Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray; Write-Host "  $msg" -ForegroundColor Cyan; Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray }
function Write-Ok { param($msg) Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Skip { param($msg) Write-Host "  ⏭️  $msg" -ForegroundColor Yellow }
function Write-Fail { param($msg) Write-Host "  ❌ $msg" -ForegroundColor Red }
function Write-Info { param($msg) Write-Host "  ℹ️  $msg" -ForegroundColor White }

# ============================================================================
# ETAPA 1: VERIFICAÇÃO DE PRÉ-REQUISITOS
# ============================================================================
Write-Host "`n" -NoNewline
Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║   🚀 ANTIGRAVITY SETUP KIT - INSTALADOR v1.0   ║" -ForegroundColor Magenta
Write-Host "  ║         Configuração Automática Completa        ║" -ForegroundColor Magenta
Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Magenta

Write-Step "ETAPA 1/8: Verificando Pré-Requisitos"

$allGood = $true

# Node.js
$nodeVersion = $null
try { $nodeVersion = (node --version 2>$null) } catch {}
if ($nodeVersion) {
    $major = [int]($nodeVersion -replace 'v','').Split('.')[0]
    if ($major -ge 20) { Write-Ok "Node.js $nodeVersion (>= 20 ✓)" }
    else { Write-Fail "Node.js $nodeVersion encontrado, mas precisa >= 20. Atualize: https://nodejs.org"; $allGood = $false }
} else { Write-Fail "Node.js não encontrado. Instale: https://nodejs.org (LTS)"; $allGood = $false }

# Python
$pyVersion = $null
try { $pyVersion = (python --version 2>&1) } catch {}
if ($pyVersion -match "Python (\d+)\.(\d+)") {
    if ([int]$Matches[1] -ge 3 -and [int]$Matches[2] -ge 10) { Write-Ok "$pyVersion (>= 3.10 ✓)" }
    else { Write-Fail "$pyVersion encontrado, mas precisa >= 3.10"; $allGood = $false }
} else { Write-Fail "Python não encontrado. Instale: https://python.org"; $allGood = $false }

# Git
try { $gitV = (git --version 2>$null); if ($gitV) { Write-Ok "$gitV" } else { throw } } catch { Write-Fail "Git não encontrado. Instale: https://git-scm.com"; $allGood = $false }

# GitHub CLI
try { $ghV = (gh --version 2>$null | Select-Object -First 1); if ($ghV) { Write-Ok "$ghV" } else { throw } } catch { Write-Fail "GitHub CLI não encontrado. Instale: winget install GitHub.cli"; $allGood = $false }

# Bun (opcional)
try { $bunV = (bun --version 2>$null); if ($bunV) { Write-Ok "Bun $bunV" } else { throw } } catch { Write-Skip "Bun não encontrado (opcional). Instale: irm bun.sh/install.ps1 | iex" }

# gcloud (para Google Auth)
$hasGcloud = $false
try { $gcloudV = (gcloud --version 2>$null | Select-Object -First 1); if ($gcloudV) { Write-Ok "Google Cloud CLI: $gcloudV"; $hasGcloud = $true } else { throw } } catch { Write-Fail "Google Cloud CLI não encontrado. Instale: https://cloud.google.com/sdk/docs/install"; Write-Info "Sem o gcloud, os 20+ servidores MCP do Google Cloud não funcionarão." }

if (-not $allGood) {
    Write-Host "`n  ⚠️  Alguns pré-requisitos estão faltando. Instale-os e rode novamente." -ForegroundColor Yellow
    Write-Host "  Continuando mesmo assim...`n" -ForegroundColor Yellow
}

# ============================================================================
# ETAPA 2: CRIAR ESTRUTURA DE DIRETÓRIOS
# ============================================================================
Write-Step "ETAPA 2/8: Criando Estrutura de Diretórios"

$dirs = @(
    $GeminiDir, $GeminiConfig, "$GeminiConfig\skills", "$GeminiConfig\plugins",
    $AntigravityDir, $AntigravityIdeDir,
    $EnterpriseWorkspace
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null; Write-Ok "Criado: $d" }
    else { Write-Skip "Já existe: $d" }
}

# Criar 13 pastas verticais no Enterprise Workspace
$verticais = @(
    "01_RH_e_Pessoas", "02_Juridico_e_Compliance", "03_Financeiro_e_Administrativo",
    "04_Estrategia_Operacoes_Processos", "05_Comunicacao_Interna", "06_Educacao",
    "07_Contabilidade", "08_SaaS_e_Tecnologia", "09_Industria_Franquias_Distribuicao",
    "10_Agro_e_Agronegocio", "11_Construcao_Civil_Imobiliario",
    "12_Financas_Consultoria_Servicos_Locais", "13_Desenvolvimento_Jogos_Plugins_UI"
)
foreach ($v in $verticais) {
    $vPath = Join-Path $EnterpriseWorkspace $v
    if (-not (Test-Path $vPath)) { New-Item -ItemType Directory -Path $vPath -Force | Out-Null }
}
Write-Ok "13 pastas verticais do Enterprise Workspace criadas"

# ============================================================================
# ETAPA 3: AUTENTICAÇÃO GOOGLE (PRINCIPAL)
# ============================================================================
Write-Step "ETAPA 3/8: Autenticação Google (Login Principal)"

if ($SkipGoogleAuth) {
    Write-Skip "Autenticação Google pulada (flag -SkipGoogleAuth)"
} elseif ($hasGcloud) {
    Write-Info "O Google Login desbloqueia 20+ servidores MCP automaticamente:"
    Write-Info "BigQuery, Spanner, Firestore, Cloud SQL, Pub/Sub, Logging,"
    Write-Info "Monitoring, Compute Engine, Cloud Run, Vertex AI e mais!"
    Write-Host ""
    
    $doGoogle = Read-Host "  Deseja fazer login no Google agora? (S/n)"
    if ($doGoogle -ne 'n' -and $doGoogle -ne 'N') {
        Write-Info "Abrindo navegador para login Google..."
        try {
            gcloud auth login --brief 2>&1 | Out-Null
            Write-Ok "Login Google realizado com sucesso!"
            
            Write-Info "Configurando credenciais padrão (ADC)..."
            gcloud auth application-default login --brief 2>&1 | Out-Null
            Write-Ok "Credenciais padrão (ADC) configuradas!"
        } catch {
            Write-Fail "Erro no login Google: $_"
            Write-Info "Você pode rodar manualmente depois: gcloud auth login"
        }
    } else {
        Write-Skip "Login Google pulado pelo usuário"
    }
} else {
    Write-Skip "gcloud não encontrado - instale o Google Cloud CLI primeiro"
}

# ============================================================================
# ETAPA 4: AUTENTICAÇÃO GITHUB
# ============================================================================
Write-Step "ETAPA 4/8: Autenticação GitHub"

if ($SkipGitHubAuth) {
    Write-Skip "Autenticação GitHub pulada (flag -SkipGitHubAuth)"
} else {
    # Verificar se já está logado
    $ghStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Ok "GitHub CLI já está autenticado"
        Write-Info $($ghStatus | Select-Object -First 2)
    } else {
        Write-Info "Abrindo navegador para login GitHub (OAuth)..."
        try {
            gh auth login --web --git-protocol https 2>&1
            Write-Ok "Login GitHub realizado com sucesso!"
        } catch {
            Write-Fail "Erro no login GitHub: $_"
            Write-Info "Rode manualmente: gh auth login"
        }
    }
    
    # Salvar token como variável de ambiente para os MCP servers
    $ghToken = gh auth token 2>$null
    if ($ghToken) {
        [System.Environment]::SetEnvironmentVariable("GITHUB_PERSONAL_ACCESS_TOKEN", $ghToken, "User")
        $env:GITHUB_PERSONAL_ACCESS_TOKEN = $ghToken
        Write-Ok "Token GitHub salvo como variável de ambiente do usuário"
    }
}

# ============================================================================
# ETAPA 5: TOKENS OPCIONAIS (SERVIÇOS EXTERNOS)
# ============================================================================
Write-Step "ETAPA 5/8: Tokens Opcionais (Serviços Externos)"

if ($SkipOptionalTokens) {
    Write-Skip "Tokens opcionais pulados (flag -SkipOptionalTokens)"
} else {
    Write-Info "Estes tokens são OPCIONAIS. Pressione Enter para pular qualquer um."
    Write-Host ""
    
    $optionalTokens = @(
        @{ Name = "STRIPE_SECRET_KEY";    Desc = "Stripe (Pagamentos)";     Hint = "sk_live_... ou sk_test_..." },
        @{ Name = "SLACK_BOT_TOKEN";      Desc = "Slack (Mensageria)";      Hint = "xoxb-..." },
        @{ Name = "NOTION_API_KEY";       Desc = "Notion (Documentação)";   Hint = "ntn_..." },
        @{ Name = "LINEAR_API_KEY";       Desc = "Linear (Gestão Ágil)";    Hint = "lin_api_..." },
        @{ Name = "FIGMA_ACCESS_TOKEN";   Desc = "Figma (Design)";          Hint = "figd_..." },
        @{ Name = "SUPABASE_ACCESS_TOKEN"; Desc = "Supabase (BaaS)";        Hint = "sbp_..." }
    )
    
    foreach ($token in $optionalTokens) {
        $existing = [System.Environment]::GetEnvironmentVariable($token.Name, "User")
        if ($existing) {
            Write-Skip "$($token.Desc) - já configurado"
        } else {
            $value = Read-Host "  $($token.Desc) [$($token.Hint)] (Enter para pular)"
            if ($value) {
                [System.Environment]::SetEnvironmentVariable($token.Name, $value, "User")
                Set-Item -Path "env:$($token.Name)" -Value $value
                Write-Ok "$($token.Desc) salvo como variável de ambiente"
            } else {
                Write-Skip "$($token.Desc) pulado"
            }
        }
    }
}

# ============================================================================
# ETAPA 6: INSTALAR CONFIGURAÇÕES MCP
# ============================================================================
Write-Step "ETAPA 6/8: Configurando Servidores MCP"

# Copiar template CLI
$cliTemplateSrc = Join-Path $ScriptRoot "config_templates\mcp_config_cli.template.json"
$cliDest = Join-Path $GeminiConfig "mcp_config.json"
if (Test-Path $cliTemplateSrc) {
    $content = Get-Content $cliTemplateSrc -Raw -Encoding UTF8
    # Substituir placeholders por valores reais das env vars
    if ($env:GITHUB_PERSONAL_ACCESS_TOKEN) {
        $content = $content -replace '__YOUR_GITHUB_TOKEN__', $env:GITHUB_PERSONAL_ACCESS_TOKEN
    }
    if (-not (Test-Path $cliDest) -or (Read-Host "  MCP config CLI já existe. Sobrescrever? (s/N)") -eq 's') {
        Set-Content -Path $cliDest -Value $content -Encoding UTF8
        Write-Ok "MCP config CLI instalado em: $cliDest"
    } else { Write-Skip "MCP config CLI mantido (já existia)" }
} else { Write-Fail "Template CLI não encontrado em: $cliTemplateSrc" }

# Copiar template IDE
$ideTemplateSrc = Join-Path $ScriptRoot "config_templates\mcp_config_ide.template.json"
$ideDest = Join-Path $AntigravityIdeDir "mcp_config.json"
if (Test-Path $ideTemplateSrc) {
    $content = Get-Content $ideTemplateSrc -Raw -Encoding UTF8
    if ($env:GITHUB_PERSONAL_ACCESS_TOKEN) {
        $content = $content -replace '__YOUR_GITHUB_TOKEN__', $env:GITHUB_PERSONAL_ACCESS_TOKEN
    }
    if (-not (Test-Path $ideDest) -or (Read-Host "  MCP config IDE já existe. Sobrescrever? (s/N)") -eq 's') {
        Set-Content -Path $ideDest -Value $content -Encoding UTF8
        Write-Ok "MCP config IDE instalado em: $ideDest"
    } else { Write-Skip "MCP config IDE mantido (já existia)" }
} else { Write-Fail "Template IDE não encontrado em: $ideTemplateSrc" }

# Copiar settings (hooks claude-mem)
$settingsSrc = Join-Path $ScriptRoot "config_templates\settings.template.json"
$settingsDest = Join-Path $GeminiDir "settings.json"
if (Test-Path $settingsSrc) {
    if (-not (Test-Path $settingsDest)) {
        Copy-Item $settingsSrc $settingsDest -Force
        Write-Ok "Settings (hooks) instalados em: $settingsDest"
    } else { Write-Skip "Settings já existem (mantidos)" }
}

# Copiar regras globais
$agentsSrc = Join-Path $ScriptRoot "config_templates\AGENTS.md"
$agentsDest = Join-Path $GeminiConfig "AGENTS.md"
if (Test-Path $agentsSrc) {
    if (-not (Test-Path $agentsDest)) {
        Copy-Item $agentsSrc $agentsDest -Force
        Write-Ok "Regras globais (AGENTS.md) instaladas"
    } else { Write-Skip "AGENTS.md já existe (mantido)" }
}

$geminiMdSrc = Join-Path $ScriptRoot "config_templates\GEMINI.md"
$geminiMdDest = Join-Path $GeminiDir "GEMINI.md"
if (Test-Path $geminiMdSrc) {
    if (-not (Test-Path $geminiMdDest)) {
        Copy-Item $geminiMdSrc $geminiMdDest -Force
        Write-Ok "Diretivas globais (GEMINI.md) instaladas"
    } else { Write-Skip "GEMINI.md já existe (mantido)" }
}

# ============================================================================
# ETAPA 7: COPIAR SKILLS
# ============================================================================
Write-Step "ETAPA 7/8: Instalando Skills"

$skillsSrc = Join-Path $ScriptRoot "skills"
if (Test-Path $skillsSrc) {
    $skillCategories = Get-ChildItem -Path $skillsSrc -Directory
    $totalSkills = 0
    foreach ($cat in $skillCategories) {
        $skills = Get-ChildItem -Path $cat.FullName -Directory
        foreach ($skill in $skills) {
            $destSkill = Join-Path $GeminiConfig "skills\$($skill.Name)"
            if (-not (Test-Path $destSkill)) {
                Copy-Item -Path $skill.FullName -Destination $destSkill -Recurse -Force
                $totalSkills++
            }
        }
    }
    
    # Copiar verticais para Enterprise Workspace
    $vertSrc = Join-Path $skillsSrc "verticais"
    if (Test-Path $vertSrc) {
        $vertSkills = Get-ChildItem -Path $vertSrc -Directory
        $vertMap = @{
            "rh-e-pessoas" = "01_RH_e_Pessoas"
            "juridico-e-compliance" = "02_Juridico_e_Compliance"
            "financeiro-e-administrativo" = "03_Financeiro_e_Administrativo"
            "estrategia-operacoes-processos" = "04_Estrategia_Operacoes_Processos"
            "comunicacao-interna" = "05_Comunicacao_Interna"
            "educacao" = "06_Educacao"
            "contabilidade" = "07_Contabilidade"
            "saas-e-tecnologia" = "08_SaaS_e_Tecnologia"
            "industria-franquias-distribuicao" = "09_Industria_Franquias_Distribuicao"
            "agro-e-agronegocio" = "10_Agro_e_Agronegocio"
            "construcao-civil-imobiliario" = "11_Construcao_Civil_Imobiliario"
            "financas-consultoria-servicos-locais" = "12_Financas_Consultoria_Servicos_Locais"
            "desenvolvimento-jogos-plugins-ui" = "13_Desenvolvimento_Jogos_Plugins_UI"
        }
        foreach ($vs in $vertSkills) {
            $mapped = $vertMap[$vs.Name]
            if ($mapped) {
                $dest = Join-Path $EnterpriseWorkspace "$mapped\SKILL.md"
                $src = Join-Path $vs.FullName "SKILL.md"
                if (Test-Path $src) { Copy-Item $src $dest -Force }
            }
        }
        Write-Ok "Skills verticais copiadas para Enterprise Workspace"
    }
    
    Write-Ok "$totalSkills novas skills instaladas no Antigravity"
} else { Write-Fail "Pasta skills/ não encontrada no kit" }

# ============================================================================
# ETAPA 8: PRÉ-CACHE DOS MCP SERVERS (npm)
# ============================================================================
Write-Step "ETAPA 8/8: Pré-instalando Servidores MCP (npm)"

$mcpServers = @(
    "@modelcontextprotocol/server-sequential-thinking",
    "@modelcontextprotocol/server-memory",
    "@modelcontextprotocol/server-github",
    "@modelcontextprotocol/server-filesystem",
    "@modelcontextprotocol/server-git",
    "@modelcontextprotocol/server-sqlite"
)

foreach ($server in $mcpServers) {
    Write-Info "Instalando $server ..."
    try {
        npx -y $server --help 2>&1 | Out-Null
        Write-Ok "$server pré-instalado"
    } catch {
        Write-Skip "$server será instalado na primeira execução"
    }
}

# ============================================================================
# RESUMO FINAL
# ============================================================================
Write-Host "`n" -NoNewline
Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║       🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO!      ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  📁 Configurações em: $GeminiConfig" -ForegroundColor White
Write-Host "  🧠 Skills em:        $GeminiConfig\skills" -ForegroundColor White
Write-Host "  🏢 Workspace em:     $EnterpriseWorkspace" -ForegroundColor White
Write-Host ""
Write-Host "  🔑 Autenticação:" -ForegroundColor White
if ($hasGcloud) { Write-Host "     Google Cloud: ✅ (20+ MCP servers ativos)" -ForegroundColor Green }
else { Write-Host "     Google Cloud: ⚠️  (instale gcloud CLI)" -ForegroundColor Yellow }
Write-Host ""
Write-Host "  💡 Próximos passos:" -ForegroundColor Cyan
Write-Host "     1. Abra o Antigravity IDE ou rode 'agy' no terminal" -ForegroundColor White
Write-Host "     2. Os servidores MCP estarão prontos automaticamente" -ForegroundColor White
Write-Host "     3. Peça ao agente para usar qualquer skill instalada" -ForegroundColor White
Write-Host ""
