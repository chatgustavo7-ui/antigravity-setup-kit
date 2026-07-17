---
name: construcao-civil-imobiliario
description: Gerencie orçamentos de obras, cronogramas físicos-financeiros, vendas imobiliárias e carteiras de lotes/imóveis.
---

# Construção Civil e Imobiliário (Proptech & Gestão de Obras)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia e otimiza rotinas de planejamento de obras, compras de suprimentos, e comercialização de imóveis ou lotes. Ela é projetada para integrações técnicas e lógicas em ambientes de Proptech e Construtech, conectando sistemas como Sienge, Construtor de Vendas (CV), Loft e ERPs de engenharia civil.

Use esta skill quando precisar:
- Estruturar orçamentos de obras com detalhamento de insumos baseados em tabelas de referência (SINAPI/TCPO).
- Integrar portais de vendas imobiliárias com ERPs para sincronização de espelho de vendas e disponibilidade de unidades.
- Monitorar o cronograma físico-financeiro de projetos civis, calculando desvios entre o planejado e o executado.
- Automatizar o recebimento de chaves e o repasse de financiamentos imobiliários entre incorporadoras, compradores e bancos.

## 2. Stack Tecnológico e Implementação
A integração de dados de engenharia e finanças imobiliárias exige precisão e conformidade regulatória:
- **Cálculo de Desembolso**: Motores matemáticos para gerenciar o reajuste de parcelas de imóveis com base em índices como INCC e IGP-M.
- **BIM e Visualização 3D**: Renderização e manipulação de arquivos BIM (Building Information Modeling) ou plantas 2D interativas usando Three.js no frontend.
- **APIs de Cartórios e Crédito**: Conexões com serviços de consulta de crédito corporativo/pessoal e integradores de cartórios para emissão de certidões.
- **Esquema de Inventário de Unidades**: Banco de dados estruturado para controlar frações ideais, número de matrícula e bloqueios temporários de reservas.

Dicas práticas de uso:
- Ao lidar com reservas de lotes ou apartamentos, implemente bloqueios curtos (ex: 20 minutos) no banco local com expiração automática para evitar a venda duplicada da mesma unidade.
- Exponha gráficos de progresso físico de forma limpa, permitindo anexar fotos georreferenciadas dos canteiros de obras para auditoria visual.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Construção Civil e Imobiliário, utilize o seguinte prompt starter:
"Você é um engenheiro de software especialista em Proptech e sistemas de Construtech. Projete a integração e lógica de sincronização com o ERP Sienge e portais imobiliários. Desenhe o banco de dados para controle de disponibilidade e reserva de unidades, elabore o fluxo de atualização monetária de parcelas (INCC/IGP-M) e defina o pipeline para controle de medição de obras físico-financeiro."
