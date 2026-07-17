# 🧠 Guia de Skills — Como Usar e Criar

> Este guia explica como as skills funcionam no Google Antigravity e como criar as suas próprias.

---

## O que é uma Skill?

Uma **Skill** é um arquivo `SKILL.md` que ensina ao agente IA como agir em contextos específicos. Quando você menciona um tema que corresponde a uma skill instalada, o agente automaticamente carrega as instruções daquela skill e segue as diretrizes definidas.

**Exemplo:** Se você pedir "crie uma API REST", o agente detecta a skill `apis-restful` e carrega as boas práticas de FastAPI/Node.js antes de programar.

---

## Como as Skills são Carregadas

1. **Detecção Automática:** O Antigravity escaneia os diretórios de skills no início de cada sessão.
2. **Matching por Nome/Descrição:** O campo `name` e `description` no frontmatter YAML são usados para decidir quando ativar a skill.
3. **Carregamento Sob Demanda:** O corpo da skill (instruções detalhadas) só é carregado quando o agente detecta que é relevante para a tarefa atual.

---

## Onde as Skills Ficam

| Localização | Tipo | Escopo |
|-------------|------|--------|
| `~\.gemini\config\skills\` | Global (CLI) | Todas as sessões do Antigravity CLI |
| `~\.antigravity\skills\` | Global (IDE) | Todas as sessões do Antigravity IDE |
| `.agents\skills\` (dentro do projeto) | Local | Apenas dentro daquele workspace |

---

## Estrutura de uma Skill

Cada skill é uma **pasta** contendo no mínimo um arquivo `SKILL.md`:

```
minha-skill/
├── SKILL.md          # Obrigatório: instruções principais
├── scripts/          # Opcional: scripts auxiliares
├── examples/         # Opcional: exemplos de uso
├── resources/        # Opcional: templates e assets
└── references/       # Opcional: documentação extra
```

---

## Formato do SKILL.md

```yaml
---
name: nome-da-skill-em-portugues
description: Uma frase curta explicando quando usar esta skill. Máximo 120 caracteres.
---

# Título da Skill

## O que esta skill faz
Explique claramente o que o agente deve saber quando esta skill for ativada.

## Quando usar
Liste os cenários em que esta skill deve ser carregada automaticamente.

## Stack Recomendado
- **Backend:** Python/FastAPI
- **Frontend:** React/Next.js
- **Banco:** PostgreSQL

## Prompt de Inicialização
Quando ativada, siga estes passos:
1. Primeiro, pergunte ao usuário sobre [X]
2. Depois, proponha o schema de banco de dados
3. Por fim, gere o plano (`create-plan`) antes de codificar
```

---

## Como Criar sua Própria Skill

### Passo 1: Escolha um nome intuitivo
```
minha-nova-skill/SKILL.md
```
- Use letras minúsculas com hífens
- Prefira nomes em português para facilitar a busca

### Passo 2: Escreva o frontmatter
```yaml
---
name: minha-nova-skill
description: Ajuda a criar [X] seguindo boas práticas de [Y].
---
```

### Passo 3: Escreva as instruções
- Seja específico e prático
- Inclua exemplos de código quando possível
- Defina um "Prompt de Inicialização" com passos claros
- Mantenha entre 30-80 linhas

### Passo 4: Instale a skill
```powershell
# Para o CLI (global)
Copy-Item -Recurse ".\minha-nova-skill" "$env:USERPROFILE\.gemini\config\skills\"

# Para um projeto específico (local)
Copy-Item -Recurse ".\minha-nova-skill" ".\.agents\skills\"
```

### Passo 5: Teste
Abra uma nova sessão do Antigravity e peça algo relacionado à skill. O agente deve carregá-la automaticamente.

---

## Skills Incluídas neste Kit

### Por Categoria

| Categoria | Qtd | Exemplos |
|-----------|-----|----------|
| 🏢 Verticais de Negócio | 13 | rh-e-pessoas, juridico, agro, construcao-civil |
| 💻 Desenvolvimento | 10 | apis-restful, arquitetura-limpa, testes-unitarios |
| 🤖 IA & Dados | 6 | engenharia-prompts, llm-agents, banco-vetoriais |
| 🌐 Web & Mobile | 7 | desenvolvimento-react, otimizacao-seo, ui-ux-design |
| ⚙️ DevOps & Infra | 5 | docker-containers, pipelines-ci-cd, nuvem-gcp-aws |
| 💼 Negócios | 6 | analise-negocios, gestao-projetos-agil, comunicacao |
| 🤖 Automação | 5 | web-scraping, automacao-scripts, automacao-testes |
| **Total** | **52** | - |

---

## Dicas Avançadas

### 1. Skills com Scripts Auxiliares
Coloque scripts Python ou shell dentro da pasta `scripts/` da skill. O agente pode executá-los quando necessário.

```
minha-skill/
├── SKILL.md
└── scripts/
    └── validar_schema.py
```

No SKILL.md, instrua o agente:
```markdown
Antes de prosseguir, execute o script `scripts/validar_schema.py` para validar o schema.
```

### 2. Skills com Referências Extensas
Se suas instruções passam de 500 linhas, use a pasta `references/`:

```
minha-skill/
├── SKILL.md             # Instruções principais (< 500 linhas)
└── references/
    ├── padroes_api.md   # Documentação extra detalhada
    └── exemplos.md      # Exemplos extensos
```

### 3. Compartilhando Skills entre Projetos
Use um `skills.json` para apontar para skills em locais não-padrão:

```json
{
  "entries": [
    { "path": "C:\\MeusProjetos\\skills-compartilhadas" }
  ]
}
```

---

## Resolução de Problemas com Skills

| Problema | Solução |
|----------|---------|
| Skill não é detectada | Verifique se o frontmatter YAML é válido (nome e descrição) |
| Skill não é ativada | Ajuste a `description` para ser mais específica |
| Skill ativada no momento errado | Torne a `description` mais restritiva |
| Arquivo SKILL.md muito grande | Mova conteúdo para `references/` |
