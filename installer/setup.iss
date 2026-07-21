[Setup]
AppName=Antigravity Setup Kit
AppVersion=2.0.0
AppPublisher=Gustavo Vitoria de Camargo
AppPublisherURL=https://github.com/chatgustavo7-ui/antigravity-setup-kit
AppSupportURL=https://github.com/chatgustavo7-ui/antigravity-setup-kit/issues
AppUpdatesURL=https://github.com/chatgustavo7-ui/antigravity-setup-kit/releases
DefaultDirName={autopf}\AntigravitySetupKit
DefaultGroupName=Antigravity Setup Kit
DisableProgramGroupPage=yes
OutputBaseFilename=AntigravitySetup
Compression=lzma2/ultra64
SolidCompression=yes
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=commandline
SetupLogging=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "\.git*,\installer\Output*"

[Run]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """{app}\setup_antigravity.ps1""""; StatusMsg: "Executando configuracao automatizada do Antigravity Setup Kit..."; Flags: runhidden waituntilterminated

[Icons]
Name: "{group}\Antigravity Setup Kit"; Filename: "{app}\setup_antigravity.ps1"
Name: "{group}\Verificar Seguranca"; Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File """{app}\security_check.ps1""""
