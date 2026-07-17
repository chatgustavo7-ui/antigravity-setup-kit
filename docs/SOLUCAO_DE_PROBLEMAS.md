# 🔧 Solução de Problemas

> Guia de troubleshooting para os erros mais comuns durante e após a instalação do Antigravity Setup Kit.

---

## 1. ❌ "O termo 'agy' não é reconhecido"

**Causa:** O executável `agy` não está no PATH do Windows.

**Solução:**
```powershell
# Encontre onde o agy está instalado
Get-ChildItem -Path $env:USERPROFILE -Recurse -Filter "agy.exe" -ErrorAction SilentlyContinue | Select-Object FullName

# Adicione ao PATH (substitua pelo caminho encontrado)
$agyPath = "C:\Users\SEU_USUARIO\.gemini\antigravity\bin"
[System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";$agyPath", "User")
```
Depois feche e reabra o terminal.

---

## 2. ❌ "gcloud: command not found"

**Causa:** O Google Cloud CLI não está instalado.

**Solução:**
1. Baixe o instalador: https://cloud.google.com/sdk/docs/install
2. Execute o instalador `.exe`
3. Reinicie o terminal
4. Rode: `gcloud init`

---

## 3. ❌ "RESOURCE_EXHAUSTED" ou "Quota exceeded"

**Causa:** Você atingiu o limite de requisições da API (geralmente temporário).

**Solução:**
- Aguarde 30-60 minutos e tente novamente
- Verifique seus limites no Console do Google Cloud
- Para o Antigravity IDE: feche e reabra a aplicação

---

## 4. ❌ "invalid_grant" na autenticação Google

**Causa:** O token de autenticação expirou ou é inválido.

**Solução:**
```powershell
# Revogar credenciais antigas
gcloud auth revoke --all

# Fazer login novamente
gcloud auth login
gcloud auth application-default login
```

---

## 5. ❌ MCP Server não conecta (GitHub)

**Causa:** Token GitHub ausente ou expirado.

**Solução:**
```powershell
# Verificar se o token existe
echo $env:GITHUB_PERSONAL_ACCESS_TOKEN

# Se vazio, fazer login novamente
gh auth login --web
$token = gh auth token
[System.Environment]::SetEnvironmentVariable("GITHUB_PERSONAL_ACCESS_TOKEN", $token, "User")
```

---

## 6. ❌ "npm ERR! ERESOLVE" ao instalar MCP servers

**Causa:** Conflito de dependências npm.

**Solução:**
```powershell
# Limpar cache do npm
npm cache clean --force

# Tentar instalar com flag legacy
npx -y --legacy-peer-deps @modelcontextprotocol/server-github
```

---

## 7. ❌ Skills não aparecem no Antigravity

**Causa:** As skills não foram copiadas para o diretório correto.

**Solução:**
```powershell
# Verificar se as skills existem
Get-ChildItem "$env:USERPROFILE\.gemini\config\skills" -Directory | Measure-Object

# Se estiverem vazias, re-rodar o instalador
powershell -File .\setup_antigravity.ps1
```

---

## 8. ❌ "Execution Policy" bloqueia o script PowerShell

**Causa:** Política de segurança do Windows impede scripts não assinados.

**Solução:**
```powershell
# Opção 1: Rodar com bypass temporário
powershell -ExecutionPolicy Bypass -File .\setup_antigravity.ps1

# Opção 2: Alterar política permanentemente (requer Admin)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

---

## 9. ❌ Antigravity IDE não carrega as configurações MCP

**Causa:** O arquivo `mcp_config.json` da IDE está num local diferente.

**Solução:**
```powershell
# Verificar o local correto
$idePath = "$env:USERPROFILE\.gemini\antigravity-ide\mcp_config.json"
if (Test-Path $idePath) { Write-Host "Config existe: $idePath" }
else { Write-Host "Config NÃO encontrada!" }

# Copiar do template
Copy-Item ".\config_templates\mcp_config_ide.template.json" $idePath
```

---

## 10. ❌ Erro de encoding (caracteres estranhos nos arquivos)

**Causa:** Arquivos salvos com encoding incorreto (esperado UTF-8).

**Solução:**
```powershell
# Forçar UTF-8 no PowerShell
$env:PYTHONUTF8 = 1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
```

---

## 🆘 Ainda com problemas?

1. **Rode o scanner de segurança** para verificar se não há conflitos:
   ```powershell
   powershell -File .\security_check.ps1 -ScanPath "$env:USERPROFILE\.gemini" -Verbose
   ```

2. **Verifique as versões** dos pré-requisitos:
   ```powershell
   node --version; python --version; git --version; gh --version
   ```

3. **Re-rode o instalador** — ele é idempotente e seguro:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\setup_antigravity.ps1
   ```
