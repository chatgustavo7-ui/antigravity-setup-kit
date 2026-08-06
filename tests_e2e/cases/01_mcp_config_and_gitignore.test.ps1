# Caso de Teste E2E de validacao do .gitignore e mcp_config_cli.template.json

Write-Host "Executando assertivas do .gitignore..."
$gitignorePath = Join-Path $projectRoot ".gitignore"
Assert-FileExists $gitignorePath "O arquivo .gitignore deve existir"

$gitIgnoreContent = Get-Content $gitignorePath -Raw

# 1. Verificar regras de arquivos de segredos, credenciais e bancos de dados
Assert-True ($gitIgnoreContent -match '\.env') "Deve ignorar .env"
Assert-True ($gitIgnoreContent -match '\*\.sqlite') "Deve ignorar *.sqlite"
Assert-True ($gitIgnoreContent -match '\*\.key') "Deve ignorar *.key"
Assert-True ($gitIgnoreContent -match '\*credential') "Deve ignorar arquivos de credenciais"
Assert-True ($gitIgnoreContent -match '\*\*/secrets/') "Deve ignorar pastas de segredos"
Assert-True ($gitIgnoreContent -match '\*\*/credentials/') "Deve ignorar pastas de credenciais"
Assert-True ($gitIgnoreContent -match 'mcp_oauth_tokens\.json') "Deve ignorar mcp_oauth_tokens.json"
Assert-True ($gitIgnoreContent -match 'installer/Output/') "Deve ignorar o artefato de build do instalador"

Write-Host "Executando assertivas do mcp_config_cli.template.json..."
$mcpConfigPath = Join-Path $projectRoot "config_templates\mcp_config_cli.template.json"
Assert-FileExists $mcpConfigPath "O arquivo mcp_config_cli.template.json deve existir"

# 2. Testar a validade do JSON e presenca de servidores
$jsonContent = Get-Content $mcpConfigPath -Raw
$jsonObj = $jsonContent | ConvertFrom-Json
Assert-True ($null -ne $jsonObj) "O arquivo deve ser um JSON valido"
$servers = @($jsonObj.mcpServers.PSObject.Properties)
Assert-True ($servers.Count -gt 0) "Deve conter pelo menos um servidor MCP cadastrado"
Assert-True ($null -ne $jsonObj.mcpServers.github) "Deve conter o servidor github"
Assert-True ($null -ne $jsonObj.mcpServers.stripe) "Deve conter o servidor stripe"

Write-Host "Todas as assertivas do gitignore e mcp_config passaram com sucesso!"
