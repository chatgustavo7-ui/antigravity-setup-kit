---
name: agro-e-agronegocio
description: Gerencie o cultivo agrícola, telemetria de maquinário, previsão meteorológica e rotinas de Agrotech (Aegro, Farmbox).
---

# Agro e Agronegócio (Agrotech & Telemetria)

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill gerencia e integra fluxos operacionais, agronômicos e de maquinário no campo. Ela atende ao ecossistema de Agrotech, orientando a sincronização de dados de talhões, aplicação de defensivos, telemetria agrícola e sensoriamento IoT. Roda em proximidade lógica com softwares como Aegro, Climate FieldView, Farmbox e John Deere Operations Center.

Use esta skill quando precisar:
- Mapear talhões de plantio georreferenciados e registrar as fases de cultivo (plantio, pulverização, colheita).
- Integrar APIs meteorológicas para fornecer alertas e previsões de clima para o produtor rural.
- Tratar logs de telemetria recebidos via ISO-XML ou barramento CAN de tratores e colheitadeiras.
- Gerenciar receitas agronômicas e estoques de insumos químicos controlados por leis agrícolas.

## 2. Stack Tecnológico e Implementação
A infraestrutura tecnológica rural exige processamento offline e suporte a coordenadas geográficas:
- **Banco de Dados Geográfico**: Extensão PostGIS (PostgreSQL) ou SQLite SpatiaLite para consultas espaciais e representação de polígonos de talhões.
- **Offline-First Architectures**: Sincronização robusta em banco de dados local no celular ou tablet para operar sem sinal de internet no campo.
- **APIs e Padrões de Maquinário**: Conversão de arquivos ISO 11783 (ISOBUS) para estruturar trajetórias de maquinário e relatórios de plantio.
- **Imagens de Satélite**: Integração com APIs do Google Earth Engine ou Sentinel para monitoramento de índices vegetativos (NDVI).

Dicas práticas de uso:
- Sempre armazene as coordenadas geográficas em formato padrão EPSG:4326 (WGS84) para garantir compatibilidade com mapas web (Leaflet/Mapbox).
- Otimize a sincronização offline transmitindo apenas os deltas (modificações) dos cadastros para economizar o tráfego de dados móveis limitados.

## 3. Instrução de Inicialização
Sempre que inicializar tarefas de Agro e Agronegócio, utilize o seguinte prompt starter:
"Você é um arquiteto de sistemas e engenheiro especialista em Agrotech. Projete a infraestrutura técnica para uma aplicação de campo offline-first. Desenhe o esquema de banco de dados espacial para talhões agrícolas, estruture a sincronização de logs de telemetria de maquinário (ISOBUS/CAN) e defina a arquitetura para tratamento offline de dados operacionais e meteorológicos."
