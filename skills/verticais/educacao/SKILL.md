---
name: educacao
description: Gerencie ambientes virtuais de aprendizagem (LMS/LXP), consumo de conteúdos, trilhas de cursos e certificados.
---

# Educação (Ambientes Virtuais de Aprendizagem LMS & LXP)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia e integra sistemas de gestão de aprendizagem (LMS/LXP) e infoprodutos. Ela foca no consumo de vídeo-aulas, gamificação, controle de trilhas de aprendizado, emissão automática de certificados e integração com plataformas como Moodle, Coursera, Hotmart Club, Memberkit e Kajabi.

Use esta skill quando precisar:
- Criar portais internos de capacitação técnica ou onboarding de novos colaboradores.
- Integrar sistemas de cobrança com plataformas de ensino para liberar cursos após aprovação do pagamento.
- Emitir certificados de conclusão em PDF com QR Code de autenticação validado em banco de dados local.
- Rastrear o progresso dos alunos (tempo assistido, notas de provas, lições concluídas) para análise de retenção.

## 2. Stack Tecnológico e Implementação
Plataformas de educação precisam ser escaláveis e possuir controle fino sobre permissões de mídia:
- **Streaming e Hospedagem de Vídeos**: Integrações com Vimeo, YouTube Embed ou Cloudflare Stream (com chaves seguras e restrição de domínio).
- **Banco de Dados de Progresso**: Modelos relacionais eficientes para armazenar a matriz de progresso de cada aluno por aula/módulo.
- **Padrão SCORM / xAPI**: Protocolos e especificações industriais para pacotes de cursos interativos compatíveis com Moodle.
- **Autenticação e SSO (Single Sign-On)**: Conexões seguras (OAuth2/SAML) para permitir que os alunos usem suas contas corporativas ou redes sociais.

Dicas práticas de uso:
- Evite hospedar vídeos diretamente no mesmo servidor da aplicação backend. Utilize CDNs especializadas para não sobrecarregar a banda do servidor.
- Para certificados, utilize geradores que permitam assinatura digital para evitar fraudes ou alterações de nomes.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Educação, utilize o seguinte prompt starter:
"Você é um arquiteto especialista em EdTechs e plataformas LMS. Projete um portal de aprendizagem e cursos. Desenhe a modelagem de banco de dados para progresso de alunos e trilhas modulares, elabore a arquitetura de segurança para streaming de vídeo privado (evitando downloads piratas) e estruture a rota de geração e verificação pública de certificados com assinatura hash criptográfica."
