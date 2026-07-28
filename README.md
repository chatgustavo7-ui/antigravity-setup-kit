<div align="center">

<!-- Banner animado -->
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,50:3b82f6,100:6366f1&height=220&section=header&text=Antigravity%20Setup%20Kit&fontSize=48&fontColor=ffffff&fontAlignY=36&animation=twinkling&desc=Ecossistema%20Automatizado%20Google%20Antigravity%20(CLI%20%2B%20IDE)&descSize=18&descAlignY=58&descColor=bfdbfe" width="100%" />

[![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![macOS](https://img.shields.io/badge/macOS-Apple_Silicon%2FIntel-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos)
[![Linux](https://img.shields.io/badge/Linux-Qualquer_Distro-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org)
[![Node.js](https://img.shields.io/badge/Node.js-%3E%3D20-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org)
[![Python](https://img.shields.io/badge/Python-%3E%3D3.10-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Inno Setup](https://img.shields.io/badge/Instalador-Execut%C3%A1vel_Unificado-7c3aed?style=for-the-badge&logo=windows11&logoColor=white)](#-instalador-unificado-exe-com-uac-admin)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-MIT-green?style=for-the-badge)](LICENSE)

**Clone → Rode → Pronto!** Configure todo seu ambiente Antigravity em menos de 5 minutos com elevação de privilégios automatizada.

</div>

---

> [!NOTE]
> Este kit foi projetado para integrar o **Google Antigravity** ao seu sistema com suporte a **52+ Skills em PT-BR**, **37+ Servidores MCP** e memória persistente contínua via **Obsidian MCP Second Brain**.

---

## ⚡ Instalação Rápida em 1 Clique

### Option A: Executável Unificado (.exe) com UAC Admin (Recomendado)
Faça download do instalador unificado construído via **Inno Setup**. Ele configura todas as permissões de Administrador automaticamente em um único clique:

1. Baixe o instalador `AntigravitySetup.exe` na aba [Releases](../../releases).
2. Clique com o botão direito e selecione **"Executar como Administrador"**.
3. Siga o assistente de instalação — todos os componentes Node, Python, Git e MCPs serão provisionados.

---

### Option B: Comando Único (Recomendado para quem não usa Git)

#### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.ps1 | iex
```

#### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/chatgustavo7-ui/antigravity-setup-kit/master/install.sh | bash
```

Esse comando baixa o kit inteiro e já roda a configuração completa — não precisa clonar nada na mão.

### Option C: Clonar Manualmente (para quem quer revisar o código antes)

#### Windows (PowerShell Administrador)
```powershell
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
powershell -ExecutionPolicy Bypass -File .\setup_antigravity.ps1
```

#### Linux / macOS
```bash
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
cp .env.example .env
bash setup_linux.sh
```

#### Docker (qualquer SO)
```bash
git clone https://github.com/chatgustavo7-ui/antigravity-setup-kit.git
cd antigravity-setup-kit
cp .env.example .env
docker-compose up -d
```

---

## ✨ Principais Funcionalidades

| Recursos | Descrição |
| :--- | :--- |
| 🧠 **Second Brain Automático** | App do **Obsidian instalado nativamente** + integração via MCP para memória persistente sem amnésia entre sessões. |
| 🔌 **37+ Servidores MCP** | Conectores para Google Cloud (BigQuery, Spanner, Firestore, Cloud Run), GitHub, Chrome DevTools, etc. |
| 📚 **52+ Skills em PT-BR** | Skills organizadas em 13 verticais de mercado (RH, Jurídico, Finanças, DevOps, IA, Web, etc.). |
| 🔐 **Autenticação Zero-Touch** | Tokens e segredos gerenciados via variáveis de ambiente seguras. |
| 🛡️ **Segurança & UAC** | Verificação de segredos (`security_check.ps1`) e elevação UAC automatizada. |

---

## 📂 Estrutura do Projeto

```text
AntigravitySetupKit/
├── 📄 setup_antigravity.ps1          # Script de instalação nativo PowerShell
├── 📄 security_check.ps1             # Verificador de vazamento de segredos
├── 📄 Dockerfile / docker-compose.yml# Container Docker para ambiente Linux isolado
├── 📁 installer/                     # Fontes do Instalador Executável Unificado
│   ├── setup.iss                     # Script de compilação Inno Setup
│   └── app_manifest.xml              # Manifesto UAC (requireAdministrator)
├── 📁 config_templates/              # Modelos de configuração MCP e regras
└── 📁 skills/                        # 52+ Skills documentadas em PT-BR
```

---

## 🛠️ Requisitos de Sistema

- **Windows 10 / 11 / Server** ou **Linux (WSL2 / Docker)**
- **Node.js** >= 20.x
- **Python** >= 3.10.x
- **Git**

---

## 📜 Licença

Distribuído sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

<div align="center">

Desenvolvido por **[Gustavo Vitória de Camargo](https://github.com/chatgustavo7-ui)** para a comunidade Antigravity 🚀

</div>
