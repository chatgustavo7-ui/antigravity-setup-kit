# ============================================================================
# Bootstrap de instalacao remota do Antigravity Setup Kit
# Uso: irm https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.ps1 | iex
# ============================================================================

$ErrorActionPreference = "Stop"

$RepoZipUrl = "https://github.com/chatgustavo7-ui/antigravity-setup-kit/archive/refs/heads/master.zip"
$InstallDir = Join-Path $env:USERPROFILE "antigravity-setup-kit"
$TempZip = Join-Path $env:TEMP "antigravity-setup-kit.zip"
$TempExtract = Join-Path $env:TEMP "antigravity-setup-kit-extract"

Write-Host "Baixando Antigravity Setup Kit..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $RepoZipUrl -OutFile $TempZip -UseBasicParsing

if (Test-Path $TempExtract) { Remove-Item $TempExtract -Recurse -Force }
Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force

$ExtractedFolder = Get-ChildItem -Path $TempExtract -Directory | Select-Object -First 1

if (Test-Path $InstallDir) {
    Write-Host "Pasta $InstallDir ja existe, atualizando conteudo..." -ForegroundColor Yellow
    Remove-Item $InstallDir -Recurse -Force
}
Move-Item -Path $ExtractedFolder.FullName -Destination $InstallDir

Remove-Item $TempZip -Force
Remove-Item $TempExtract -Recurse -Force

Write-Host "Instalado em $InstallDir. Rodando o setup..." -ForegroundColor Cyan
Set-Location $InstallDir
& powershell -ExecutionPolicy Bypass -File "$InstallDir\setup_antigravity.ps1"
