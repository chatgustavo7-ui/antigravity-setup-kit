---
name: rh-e-pessoas
description: Gerencie rotinas de HCM, atração de talentos (ATS), onboarding, avaliação de desempenho e Departamento Pessoal.
---

# Recursos Humanos e Gestão de Pessoas (HCM & ATS)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill fornece as diretrizes para automação, integração e manipulação de dados em ecossistemas de Recursos Humanos (HCM) e recrutamento (ATS). Ela ajuda a estruturar fluxos de trabalho típicos de plataformas como Workday, BambooHR, Lever, Greenhouse e Gupy.

Use esta skill quando precisar:
- Automatizar o fluxo de contratação, extraindo dados de candidatos de um ATS para um sistema de folha.
- Estruturar pipelines de recrutamento com estágios definidos (triagem, entrevista técnica, oferta).
- Mapear e implementar processos de onboarding e desligamento de colaboradores.
- Consultar APIs de HCM para atualizações de cargo, salário, benefícios e hierarquia organizacional.

## 2. Stack Tecnológico e Implementação
A implementação de integrações de RH requer cuidado especial com a LGPD (Lei Geral de Proteção de Dados) e segurança da informação:
- **APIs RESTful**: Integração com webhooks de ATS (ex: Lever API) para disparar ações automáticas na assinatura do contrato.
- **Banco de Dados Relacional**: Tabelas locais estruturadas de colaboradores para espelhamento seguro e cache temporário.
- **Segurança**: Armazenamento criptografado de dados pessoais sensíveis (como CPF, RG e salário) em nível de banco de dados (AES-256).
- **Camada de Autenticação**: Uso de chaves de API restritas com escopos mínimos de leitura/escrita para sistemas de RH.

Dicas práticas de uso:
- Sempre valide se os dados recebidos via webhook possuem assinatura de verificação para evitar injeções maliciosas.
- Implemente fluxos de conciliação diários para sincronizar o banco corporativo com o HCM principal.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de RH e Gestão de Pessoas, utilize o seguinte prompt starter:
"Você é um especialista em HCM e ATS integrando sistemas de RH corporativos. Considere as restrições da LGPD e garanta o trânsito seguro de dados pessoais sensíveis. Desenhe o pipeline de dados mapeando os campos de origem do ATS (Greenhouse/Lever) para o destino no HCM (Workday/BambooHR), definindo os esquemas JSON de transição e os endpoints necessários para a sincronização automatizada."
