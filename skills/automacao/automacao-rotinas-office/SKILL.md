---
name: automacao-rotinas-office
description: Automação de rotinas de planilhas locais e na nuvem usando bibliotecas Python ou APIs de escritório.
---

# Automação de Rotinas Office

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define padrões, estratégias e ferramentas para automatizar a criação, leitura e manipulação de planilhas de cálculo, documentos de texto e apresentações locais ou integrados a serviços em nuvem (como Microsoft 365 e Google Workspace).

Você deve usar esta skill quando precisar:
- Ler ou escrever arquivos Excel (`.xlsx`, `.xls`) ou CSV em grande escala.
- Aplicar fórmulas, formatações condicionais, tabelas dinâmicas ou estilos em planilhas programaticamente.
- Sincronizar dados entre planilhas locais e serviços em nuvem como Google Sheets ou SharePoint.
- Automatizar o preenchimento de templates de relatórios em Word (`.docx`) ou slides em PowerPoint (`.pptx`).

## 2. Stack Tecnológico e Implementação
As tecnologias sugeridas para uso local e integração com serviços em nuvem são:
- **`openpyxl`**: A biblioteca padrão do ecossistema Python para leitura e gravação nativa de arquivos `.xlsx` do Excel.
- **`pandas`**: Ideal para operações de análise e manipulação rápidas de dados tabulares locais, permitindo importação e exportação de dados em formatos Office.
- **`python-docx` e `python-pptx`**: Úteis para a geração automatizada de relatórios em Word e apresentações de slides.
- **APIs de Nuvem**: Google Sheets API e Microsoft Graph API para manipulação direta de arquivos hospedados na nuvem.

Dicas práticas:
- Ao escrever grandes volumes de dados no Excel com `openpyxl`, utilize o modo de gravação otimizado (`WriteOnlyWorksheet`) para reduzir o consumo de memória RAM.
- Para automações de planilhas que serão abertas por usuários finais, certifique-se de que os nomes das fórmulas correspondam aos idiomas corretos e as células de resultados sejam recalculadas apropriadamente.
- Guarde credenciais e tokens de APIs de nuvem (como `credentials.json` do Google) de forma segura em variáveis de ambiente, nunca diretamente no código-fonte do script.

## 3. Instrução de Inicialização
Ao inicializar um agente com esta skill, utilize o seguinte prompt de inicialização:
"Atue como um especialista em automação administrativa de escritório (Office). Crie scripts eficientes e integrados para manipulação de planilhas locais (Excel) e nuvem (Google Sheets/Microsoft 365). Siga padrões limpos de manipulação de dados, documente todas as dependências de APIs de terceiros, preze pela performance em arquivos volumosos e desenvolva relatórios finais claros e fáceis de ler pelo usuário."
