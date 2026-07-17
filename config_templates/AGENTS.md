# Diretrizes Globais e Regras de Comportamento dos Agentes

Este documento descreve as regras obrigatórias e os padrões de comportamento que todos os agentes autônomos e assistentes de IA devem seguir estritamente ao interagir com o ambiente de desenvolvimento e produção deste servidor.

## 1. Idioma e Comunicação
- **Regra:** Todo o raciocínio interno, elaboração de planos, checklists de tarefas e interações externas/mensagens com o usuário devem ser conduzidos estritamente em **Português (PT-BR)**.
- **Exceção:** Comandos de terminal, nomes de variáveis, configurações técnicas e código-fonte devem manter sua nomenclatura técnica original em inglês ou conforme exigido pelo projeto.

## 2. Arquitetura de Banco Duplo (Mandatório)
A integridade dos dados históricos e operacionais baseia-se em uma arquitetura de banco duplo bem definida:
1. **Banco Master (PROJETO_PRIVADO.db):**
   - **Localização:** `c:\meu-servidor\banco-de-dados\PROJETO_PRIVADO.db`
   - **Permissão:** Estritamente **SOMENTE LEITURA** (Read-Only).
   - **Ação Proibida:** Nenhum agente deve sob qualquer circunstância escrever, editar, atualizar, deletar ou modificar tabelas/dados no banco Master.
2. **Banco Local do App (app_db.sqlite):**
   - **Localização:** Cada Web App criado dentro de `c:\meu-servidor\apps` deve manter e gerenciar seu próprio banco SQLite local (geralmente sob o caminho `server/database/app_db.sqlite` ou similar).
   - **Operações de Escrita:** Todas as operações de inserção, alteração ou exclusão de dados relacionadas ao comportamento do aplicativo devem ser feitas no banco de dados local do app.
   - **Cruzamento de Dados (Relacionamento):** Ao exibir informações de fornecedores, lotes ou empresas, o sistema deve salvar apenas o ID de referência correspondente no banco local do app. Para renderizar os dados legíveis, deve ser feita uma junção (join ou consulta paralela) em tempo de execução com o banco Master `PROJETO_PRIVADO.db` a partir do ID salvo localmente.

## 3. Infraestrutura de Deploy e Redes
- **Hospedagem de Frontend:**
   - Nenhum frontend web é hospedado de forma local direta para o acesso de usuários externos.
   - Todos os projetos de Frontend (geralmente baseados em React/Vite) devem ser implantados (deploy) na **Vercel**.
   - O deploy deve ocorrer obrigatoriamente através de repositórios sincronizados no GitHub sob o perfil do usuário `chatgustavo7-ui`.
- **Hospedagem de Backend:**
   - Os servidores de backend (tipicamente aplicações Node.js/Express) rodam localmente na máquina servidora Windows (por exemplo, na porta 3001 ou similar).
   - Para permitir o acesso seguro de serviços externos às APIs sem expor portas diretamente, é utilizado o **Cloudflare Tunnel** (`cloudflared`), rodando como serviço ou processo persistente no Windows.
- **Documentação de Referência Central:**
   - O repositório central contendo as especificações técnicas, padrões de infraestrutura e a documentação original do banco de dados e servidores é: `chatgustavo7-ui/infraestrutura-e-banco`. Consulte-o sempre em caso de dúvidas sobre a infraestrutura.
