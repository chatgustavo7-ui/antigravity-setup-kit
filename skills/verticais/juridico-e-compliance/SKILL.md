---
name: juridico-e-compliance
description: Gerencie contratos, assinaturas eletrônicas, conformidade legal e auditoria (LegalTech & Compliance).
---

# Jurídico e Compliance (LegalTech & Contratos)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia o ciclo de vida de documentos legais, controle de processos judiciais e auditoria de conformidade regulatória. Ela fornece as bases para interações com APIs de assinatura eletrônica (como Docusign, Contractbook, Clicksign) e gerenciadores jurídicos (como Projuris).

Use esta skill quando precisar:
- Automatizar a geração de contratos em PDF utilizando templates e dados dinâmicos do banco local.
- Integrar webhooks de plataformas de assinatura eletrônica para monitorar o status do documento (enviado, assinado, rejeitado).
- Organizar repositórios de termos de uso, políticas de privacidade e auditoria de logs de aceite.
- Rastrear prazos processuais e audiências conectando a sistemas de tribunal ou software de gestão jurídica.

## 2. Stack Tecnológico e Implementação
O ambiente jurídico exige integridade de dados absoluta e controle de versionamento rigoroso:
- **PDF Generation**: Bibliotecas robustas como `pdfkit` (Node.js) ou `reportlab` (Python) para renderização de contratos a partir de HTML/CSS.
- **Hash e Assinatura Digital**: Algoritmos de criptografia como SHA-256 para gerar assinaturas hash e garantir que o documento original não foi alterado.
- **Cloud Storage**: Armazenamento seguro de PDFs assinados em buckets protegidos (Amazon S3 ou Google Cloud Storage) com políticas de retenção rígidas.
- **Audit Trail (Trilha de Auditoria)**: Registro detalhado em banco de dados contendo data, hora, IP, e-mail e hash do navegador de cada pessoa que visualizou ou assinou o documento.

Dicas práticas de uso:
- Sempre armazene o contrato original em PDF e o anexo com o log de assinaturas emitido pela API da Docusign de forma acoplada.
- Nunca exponha documentos confidenciais publicamente. Use URLs pré-assinadas com tempo de expiração curto (ex: 15 minutos) para download.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas da área Jurídica e Compliance, utilize o seguinte prompt starter:
"Você é um consultor técnico especialista em LegalTech e Compliance. Ajude a desenhar um fluxo automatizado de assinatura de contratos. O fluxo deve gerar um documento em formato PDF dinâmico, enviá-lo via API (Docusign/Contractbook) para os signatários, rastrear o progresso via webhooks e registrar o arquivo final com sua respectiva trilha de auditoria e hashes criptográficos de segurança."
