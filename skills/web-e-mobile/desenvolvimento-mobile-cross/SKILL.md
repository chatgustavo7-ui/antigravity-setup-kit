---
name: desenvolvimento-mobile-cross
description: Desenvolvimento híbrido multiplataforma utilizando Flutter e React Native.
---

# Desenvolvimento Mobile Multiplataforma

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill consolida as melhores práticas para o desenvolvimento de aplicativos móveis híbridos para iOS e Android. Ela abrange a arquitetura, gerenciamento de estado e estruturação de projetos usando os dois principais frameworks multiplataforma do mercado: React Native e Flutter, priorizando performance nativa, consistência visual e reuso de código.

Use esta skill quando:
- Estiver planejando ou implementando aplicativos que precisam rodar em iOS e Android com uma única base de código.
- For necessário decidir entre a stack de JavaScript/TypeScript (React Native/Expo) ou Dart (Flutter).
- Precisar otimizar o tempo de inicialização do app, consumo de memória ou performance de renderização de listas complexas.
- Integrar APIs nativas do dispositivo (câmera, geolocalização, sensores) de forma multiplataforma.

## 2. Stack Tecnológico e Implementação
- **React Native (com Expo)**: Framework baseado em JavaScript/TypeScript. Recomendado para equipes com experiência em web.
  - Utilize Expo Router para navegação baseada em arquivos.
  - Otimize imagens com `expo-image` e use Hermes como engine JavaScript para melhor performance.
- **Flutter**: SDK de UI da Google baseado na linguagem Dart. Recomendado para interfaces customizadas de alta fidelidade e performance extrema.
  - Adote gerenciamento de estado robusto (como Bloc, Riverpod ou Provider).
  - Mantenha widgets puros e pequenos, minimizando reconstruções desnecessárias na árvore de widgets usando `const`.
- **Dicas Práticas**:
  - Evite lógica de negócios acoplada na camada de visualização em ambos os frameworks.
  - Utilize ferramentas de linting estritas (ex: `flutter_lints` para Flutter e `eslint-plugin-react-native` para React Native).

## 3. Instrução de Inicialização
"Ative a skill de Desenvolvimento Mobile Multiplataforma. Sempre que solicitado a criar telas, lógica de estado ou integrações para aplicativos móveis, pergunte ao usuário se prefere React Native (Expo/TS) ou Flutter (Dart). Siga rigorosamente os padrões modernos de design e arquitetura do ecossistema escolhido (como injeção de dependência e separação de lógica e visual). Forneça instruções claras de build, depuração e configuração de permissões nativas para iOS e Android."
