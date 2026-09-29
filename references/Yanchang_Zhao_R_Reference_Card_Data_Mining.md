# R Reference Card for Data Mining — Yanchang Zhao

> **Autore**: Yanchang Zhao (RDataMining.com)  
> **Tipo**: Cheat Sheet / Quick Reference Compendium  
> **Contesto**: Sintesi sistematica delle funzioni e dei pacchetti R per Data Mining, Machine Learning supervisionato/non supervisionato, Text Mining, Time Series e Network Analysis.

---

## 1. Association Rules & Sequential Patterns

### Funzioni Principali
* `apriori(data, parameter = list(supp = ..., conf = ...))` (`arules`): Algoritmo Apriori breadth-first basato su conteggio transazioni per individuare itemset frequenti e regole d'associazione.
* `eclat(data, parameter = list(supp = ...))` (`arules`): Algoritmo Eclat depth-first basato su classi di equivalenza e intersezione di set.
* `cspade(data, parameter = list(support = ...))` (`arulesSequences`): Mining di pattern sequenziali frequenti (algoritmo cSPADE).
* `seqefsub()` (`TraMineR`): Ricerca di sottosequenze frequenti di eventi/stati.

### Pacchetti Chiave
* `arules`: Core data structures per transazioni, itemset e regole.
* `arulesViz`: Visualizzazione grafica di regole (scatter plot, graph network, grouped matrix).
* `arulesCBA`, `arc`, `rCBA`: Classificazione basata su regole d'associazione (Associative Classification).

---

## 2. Classificazione & Machine Learning Supervisionato

### Decision Trees & Ensemble
* `rpart(formula, data, method = "class")` (`rpart`): Alberi di classificazione e regressione basati su CART.
  * `rpart.plot(model)` (`rpart.plot`): Visualizzazione avanzata dell'albero.
* `ctree(formula, data)` (`party`): Conditional Inference Trees basati su test d'indipendenza statistica non parametrica.
* `randomForest(formula, data, ntree = ..., mtry = ...)` (`randomForest`): Random Forest per classificazione e regressione.
  * `importance(model)`: Calcolo dell'importanza delle feature (Mean Decrease Gini / Accuracy).
  * `varimp(model)` (`party`): Importanza variabili con ensemble `cforest`.

### Reti Neurali & SVM
* `nnet(formula, data, size = ..., decay = ...)` (`nnet`): Rete neurale feed-forward a singolo layer nascosto e modelli log-lineari multinomiali.
* `neuralnet(formula, data, hidden = ...)` (`neuralnet`): Training con backpropagation e resilient backpropagation.
* `svm(formula, data, kernel = "radial")` (`e1071`): Support Vector Machine (C-classification, nu-classification, epsilon-SVR).
* `ksvm()` (`kernlab`): Kernel Support Vector Machines.
* `naiveBayes(formula, data)` (`e1071`): Classificatore Naïve Bayes.

### Valutazione Performance dei Modelli
* `pROC::roc(response, predictor)`: Costruzione della curva ROC.
* `pROC::auc(roc_obj)`: Calcolo dell'Area Under the Curve (AUC).
* `ROCR::prediction()`, `ROCR::performance()`: Generazione di metriche avanzate (ROC, Precision-Recall, Lift).
* `caret::confusionMatrix(data, reference)`: Matrice di confusione, Accuracy, Sensitivity, Specificity, F1-Score, Cohen's Kappa.

---

## 3. Regressione

* `lm(formula, data)`: Regressione lineare ordinaria (OLS).
* `glm(formula, data, family = binomial)`: Modelli Lineari Generalizzati (Logistic, Poisson, Gamma).
* `gbm(formula, data, distribution = "bernoulli")` (`gbm`): Generalized Boosted Regression Models (Gradient Boosting).
* `predict(model, newdata, type = ...)`: Inferenza e calcolo valori predetti / probabilità.
* `residuals(model)`: Estrazione dei residui.
* `nls()`: Regressione non lineare per minimi quadrati.
* `nlme::gls()` / `nlme::lme()`: Modelli lineari a effetti misti e minimi quadrati generalizzati per dati gerarchici o eteroschedastici.

---

## 4. Clustering (Non Supervisionato)

### Metodi di Partizionamento
* `kmeans(x, centers = k, nstart = 25)`: k-Means standard su matrice numerica.
* `cluster::pam(x, k)`: Partitioning Around Medoids (PAM / k-Medoids, più robusto a outlier rispetto a k-Means).
* `cluster::clara(x, k)`: PAM per dataset di grandi dimensioni con campionamento.
* `fpc::pamk(x)`: PAM con stima automatica del numero ottimale di cluster $k$.
* `fpc::dbscan(data, eps = ..., MinPts = ...)`: Density-Based Spatial Clustering (riconosce cluster di forma arbitraria e isola il rumore).

### Metodi Gerarchici
* `hclust(dist(x), method = "ward.D2")`: Clustering gerarchico agglomerativo (Single, Complete, Average, Ward).
* `cluster::agnes()`, `cluster::diana()`: Clustering agglomerativo e divisivo.
* `pvclust::pvclust(x, method.hclust = "ward.D2")`: Clustering gerarchico con p-value calcolati via bootstrap resampling.
* `mclust::Mclust(x)`: Clustering basato su miscele di gaussiane (GMM, Expectation-Maximization).

### Validazione dei Cluster
* `cluster::silhouette(cluster_ids, dist_matrix)`: Silhouette analysis per misurare coesione interna e separazione.
* `fpc::cluster.stats()`: Statistiche di validità interna/esterna (Dunn index, Rand index, silhouette media).
* `NbClust::NbClust()`: Valutazione simultanea di 30 indici per determinare il numero ottimale di cluster.

---

## 5. Outlier Detection & Anomaly Detection

* `boxplot.stats(x)$out`: Outlier univariati secondo la regola IQR ($\pm 1.5 \times \text{IQR}$).
* `DMwR::lofactor(data, k = ...)` / `Rlof::lof()`: Local Outlier Factor (LOF) per anomalie densità-dipendenti multivariate.
* `mvoutlier`: Riconoscimento robusto di outlier multivariati basato su distanze di Mahalanobis robuste.

---

## 6. Time Series Analysis & Forecasting

* `ts(data, frequency = 12, start = c(year, month))`: Creazione di un oggetto serie storica.
* `decompose(x, type = "additive"/"multiplicative")`: Decomposizione classica (Trend, Stagionalità, Residuo).
* `stl(x, s.window = "periodic")`: Decomposizione robusta basata su Loess.
* `acf(x)`, `pacf(x)`: Autocorrelazione totale e parziale.
* `forecast::auto.arima(x)`: Selezione automatica del modello ARIMA/SARIMA con criteri AIC/BIC.
* `forecast::forecast(model, h = ...)`: Proiezione a orizzonte $h$ con intervalli di confidenza al 80% e 95%.

---

## 7. Text Mining & Natural Language Processing

* `tm::Corpus(VectorSource(text_vector))`: Costruzione del corpus testuale.
* `tm::tm_map(corpus, content_transformer(tolower))`: Pipeline di pulizia (lowercase, `removePunctuation`, `removeNumbers`, `removeWords(stopwords("en"))`, `stemDocument`).
* `tm::TermDocumentMatrix(corpus)` / `DocumentTermMatrix(corpus)`: Matrice Termini-Documenti.
* `tm::findFreqTerms(dtm, lowfreq = ...)`: Estrazione termini frequenti.
* `tm::findAssocs(dtm, "target_word", corlimit = 0.5)`: Correlazioni lessicali.
* `topicmodels::LDA(dtm, k = ...)`: Latent Dirichlet Allocation per Topic Modeling.
* `wordcloud::wordcloud(words, freq, min.freq = ...)`: Generazione Word Cloud.
* `sentimentr::sentiment(text)`: Sentiment analysis a livello di frase con intensificatori e negazioni.

---

## 8. Network Analysis & Grafi

* `igraph::graph_from_data_frame(d = edges, vertices = nodes, directed = TRUE)`: Creazione grafo da edge list e node attributes.
* `igraph::degree(g)`, `betweenness(g)`, `closeness(g)`, `eigen_centrality(g)`: Metriche di centralità.
* `igraph::cluster_fast_greedy(g)`, `cluster_louvain(g)`: Community Detection su reti complesse.
* `igraph::mst(g)`: Minimum Spanning Tree.
* `igraph::plot(g)`: Visualizzazione statica; `networkD3` per grafi interattivi HTML/D3.js.

---

## 9. Data Manipulation & Big Data Tools

* `dplyr`: `select()`, `filter()`, `mutate()`, `group_by()`, `summarise()`, `inner_join()`.
* `tidyr`: `pivot_longer()`, `pivot_wider()`, `separate()`, `unite()`.
* `data.table`: Sintassi performante ad altissima velocità `DT[i, j, by]`.
* `readxl` / `writexl`: Lettura e scrittura nativa di file Excel (.xlsx).
* `parallel` & `foreach`: Calcolo parallelo multicore (`registerDoParallel()`, `%dopar%`).
* `bigmemory` & `ff`: Gestione e matrici mappate su disco che eccedono la memoria RAM fisica.

---

## 10. Reporting & Interfacce

* `knitr` / `rmarkdown`: Creazione di report dinamici riproducibili in HTML, PDF e Word.
* `xtable`: Esportazione di tabelle R direttamente formattate in sintassi LaTeX o HTML.
* `shiny`: Sviluppo di dashboard e web application interattive direttamente in R.
