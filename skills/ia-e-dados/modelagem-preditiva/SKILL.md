---
name: modelagem-preditiva
description: Seleção, treinamento e validação de modelos de aprendizado de máquina supervisionados.
---
# Modelagem Preditiva

## 1. Referências de Ecossistema ou "O que esta skill faz" e "Quando usar"
Esta skill define práticas recomendadas para a construção de modelos de aprendizado de máquina supervisionados (Regressão e Classificação). Ela engloba a divisão de dados (treino/teste/validação), a seleção de algoritmos apropriados, o ajuste de hiperparâmetros (hyperparameter tuning) e a avaliação rigorosa das métricas de desempenho para evitar sobreajuste (overfitting).

Use esta skill quando:
- Precisar construir um modelo preditivo baseado em dados rotulados históricos (supervisionados).
- Executar classificação de categorias (ex: detecção de fraudes, previsão de churn) ou regressão de valores contínuos (ex: previsão de faturamento).
- Validar a capacidade de generalização de um modelo antes do deploy em produção.
- Realizar otimização de parâmetros de modelos (GridSearch ou RandomSearch).

## 2. Stack Tecnológico e Implementação
- **Bibliotecas Principais:** Scikit-Learn (modelos tradicionais e utilitários), XGBoost, LightGBM (algoritmos baseados em árvores), Optuna (ajuste fino).
- **Validação e Separação:**
  1. Use `train_test_split` com estratificação para classes desbalanceadas.
  2. Implemente Validação Cruzada (K-Fold Cross-Validation) para garantir robustez estatística.
- **Métricas de Avaliação Recomendadas:**
  - *Classificação:* Accuracy, Precision, Recall, F1-Score, ROC-AUC, Matriz de Confusão.
  - *Regressão:* Mean Absolute Error (MAE), Mean Squared Error (MSE), R-squared (R²).
- **Práticas Recomendadas:**
  - Evite vazamento de dados (data leakage): aplique transformações (ex: escalonamento StandardScaler) apenas nos dados de treino ou use Pipelines do Scikit-Learn.
  - Avalie sempre o modelo de baseline (ex: DummyClassifier) para verificar se o modelo complexo realmente agrega valor.

## 3. Instrução de Inicialização
Ao inicializar uma tarefa de modelagem preditiva, utilize o seguinte prompt do sistema:
"""
Você é um Engenheiro de Machine Learning especialista em Modelagem Preditiva. Sua missão é projetar, treinar e validar modelos preditivos supervisionados robustos.
Siga estas diretrizes ao planejar seu fluxo:
- Defina o tipo de problema (classificação ou regressão) e selecione as métricas de sucesso de acordo com o contexto de negócios.
- Estabeleça uma estratégia clara de separação de dados (treino, teste e validação cruzada) para mitigar overfitting.
- Projete um pipeline que inclua pré-processamento (imputação de nulos, codificação de categóricos, normalização) e modelagem de forma encapsulada.
- Sugira múltiplos algoritmos candidatos (ex: Random Forest, Gradient Boosting, Regressão Logística) e compare seus resultados quantitativamente.
- Detalhe como analisar a importância das features (feature importance) para explicar as previsões do modelo.
"""
