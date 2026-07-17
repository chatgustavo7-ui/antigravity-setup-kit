# ============================================================================
# 🔒 Security Check - Scanner de Segredos
# ============================================================================
# Varre arquivos de configuração procurando tokens/senhas acidentalmente expostos.
# Rode este script periodicamente para garantir que nenhum segredo vazou.
# ============================================================================

param(
    [string]$ScanPath = ".",
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"

Write-Host "`n  🔒 SCANNER DE SEGREDOS - Antigravity Security Check" -ForegroundColor Cyan
Write-Host "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  Escaneando: $ScanPath`n" -ForegroundColor White

$patterns = @(
    @{ Name = "GitHub PAT (clássico)";       Regex = "ghp_[A-Za-z0-9]{36}" },
    @{ Name = "GitHub PAT (fine-grained)";   Regex = "github_pat_[A-Za-z0-9_]{82}" },
    @{ Name = "GitHub OAuth Token";          Regex = "gho_[A-Za-z0-9]{36}" },
    @{ Name = "Stripe Secret Key";           Regex = "sk_(live|test)_[A-Za-z0-9]{24,}" },
    @{ Name = "Stripe Publishable Key";      Regex = "pk_(live|test)_[A-Za-z0-9]{24,}" },
    @{ Name = "Slack Bot Token";             Regex = "xoxb-[0-9]{10,}-[A-Za-z0-9]+" },
    @{ Name = "Slack User Token";            Regex = "xoxp-[0-9]{10,}-[A-Za-z0-9]+" },
    @{ Name = "Slack Webhook URL";           Regex = "https://hooks\.slack\.com/services/T[A-Z0-9]+/B[A-Z0-9]+/[A-Za-z0-9]+" },
    @{ Name = "OpenAI API Key";              Regex = "sk-[A-Za-z0-9]{48,}" },
    @{ Name = "Google API Key";              Regex = "AIza[A-Za-z0-9_-]{35}" },
    @{ Name = "AWS Access Key";              Regex = "AKIA[A-Z0-9]{16}" },
    @{ Name = "AWS Secret Key";              Regex = "(?i)aws(.{0,20})?['\"][0-9a-zA-Z/+]{40}['\"]" },
    @{ Name = "Supabase Key";                Regex = "sbp_[A-Za-z0-9]{40,}" },
    @{ Name = "Notion API Key";              Regex = "ntn_[A-Za-z0-9]{40,}" },
    @{ Name = "Linear API Key";              Regex = "lin_api_[A-Za-z0-9]{40,}" },
    @{ Name = "Private Key Header";          Regex = "-----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----" },
    @{ Name = "JWT Token";                   Regex = "eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]+" },
    @{ Name = "Generic Secret Assignment";   Regex = "(?i)(password|secret|token|api_key|apikey)\s*[=:]\s*['\"][A-Za-z0-9+/=_-]{16,}['\"]" }
)

$extensions = @("*.json", "*.md", "*.yaml", "*.yml", "*.toml", "*.env", "*.cfg", "*.ini", "*.conf", "*.ps1", "*.sh", "*.bat", "*.py", "*.js", "*.ts")
$excludeDirs = @("node_modules", ".git", ".venv", "__pycache__", "dist", "build")

$totalFindings = 0
$scannedFiles = 0

$files = Get-ChildItem -Path $ScanPath -Recurse -File -Include $extensions -ErrorAction SilentlyContinue | 
    Where-Object { 
        $path = $_.FullName
        -not ($excludeDirs | Where-Object { $path -like "*\$_\*" })
    }

foreach ($file in $files) {
    $scannedFiles++
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        foreach ($pattern in $patterns) {
            $matches = [regex]::Matches($content, $pattern.Regex)
            if ($matches.Count -gt 0) {
                $totalFindings += $matches.Count
                Write-Host "  ⚠️  $($pattern.Name)" -ForegroundColor Red
                Write-Host "     Arquivo: $($file.FullName)" -ForegroundColor Yellow
                Write-Host "     Ocorrências: $($matches.Count)" -ForegroundColor Yellow
                if ($Verbose) {
                    foreach ($m in $matches) {
                        $preview = $m.Value.Substring(0, [Math]::Min(20, $m.Value.Length)) + "..."
                        Write-Host "     Preview: $preview" -ForegroundColor DarkGray
                    }
                }
                Write-Host ""
            }
        }
    } catch {
        if ($Verbose) { Write-Host "  ⏭️  Não foi possível ler: $($file.FullName)" -ForegroundColor DarkGray }
    }
}

Write-Host "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  📊 Resultado: $scannedFiles arquivos escaneados" -ForegroundColor White

if ($totalFindings -eq 0) {
    Write-Host "  ✅ NENHUM SEGREDO ENCONTRADO - Tudo seguro!" -ForegroundColor Green
} else {
    Write-Host "  ❌ $totalFindings SEGREDO(S) POTENCIAL(IS) ENCONTRADO(S)!" -ForegroundColor Red
    Write-Host "     Remova os segredos e use variáveis de ambiente." -ForegroundColor Yellow
    Write-Host "     Exemplo: `$env:GITHUB_PERSONAL_ACCESS_TOKEN" -ForegroundColor Yellow
}
Write-Host ""
