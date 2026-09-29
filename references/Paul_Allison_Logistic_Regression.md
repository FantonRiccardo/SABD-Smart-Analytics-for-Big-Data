# Logistic Regression Using SAS: Theory and Application (2nd Edition) — Paul D. Allison

> **Autore**: Paul D. Allison (University of Pennsylvania)  
> **Editore**: SAS Institute Inc. (SAS Press Series, 2012)  
> **ISBN**: 978-1-59994-641-2 / 978-1-60764-995-3  
> **Riferimento corso**: *Smart Analytics for Big Data (SABD) — Grenoble INP*  

---

## Panoramica dell'Opera

Il testo di Paul D. Allison è il punto di riferimento metodologico e applicativo per l'analisi di **variabili dipendenti categoriche (dicotomiche, politomiche nominali, ordinali)**, **scelte discrete (discrete choice)**, **dati longitudinali/clusterizzati** e **conteggi (Poisson/Negative Binomial)**. L'opera combina una rigorosa trattazione teorica basata sulla stima di massima verosimiglianza (Maximum Likelihood) con implementazioni pratiche in SAS 9.3+ (`PROC LOGISTIC`, `GENMOD`, `GLIMMIX`, `QLIM`, `MDC`).

---

## Struttura Metodologica e Concetti Fondamentali

```
                               ┌────────────────────────────────────────────────────────┐
                               │       CATEGORICAL & COUNT RESPONSE MODELING            │
                               └──────────────────────────┬─────────────────────────────┘
                                                          │
         ┌────────────────────────────────────────────────┼────────────────────────────────────────────────┐
         │                                                │                                                │
         ▼                                                ▼                                                ▼
┌──────────────────┐                            ┌───────────────────┐                            ┌──────────────────┐
│   BINARY DATA    │                            │ MULTINOMIAL/ORDER │                            │    COUNT DATA    │
│  (0 / 1 Event)   │                            │  (Nominal/Ordinal)│                            │ (0, 1, 2, ... N) │
└────────┬─────────┘                            └─────────┬─────────┘                            └────────┬─────────┘
         │                                                │                                               │
         ├─ Linear Probability Model (LPM vs Logit)       ├─ Multinomial Logit (Baseline Category)        ├─ Poisson Regression
         ├─ Odds, Odds Ratios & Log-Odds                  ├─ Cumulative Logit (Proportional Odds)         ├─ Negative Binomial (Overdisp.)
         ├─ Newton-Raphson / Fisher Scoring               ├─ Adjacent Categories & Continuation Ratio     ├─ Exposure Offsets (Rates)
         ├─ Firth Penalized Likelihood & Exact Logistic   ├─ Discrete Choice & Random Utility (McFadden)  └─ Zero-Inflated (ZIP / ZINB)
         ├─ ROC, AUC (c-stat), Hosmer-Lemeshow, Tjur R²   └─ Panel: GEE vs GLMM vs Conditional Logit
         └─ Latent Variable / Probit / Cloglog
```

---

### 1. Fondamenti del Modello Logistico Binario (Capitoli 1–2)

#### 1.1 Limiti del Modello Lineare di Probabilità (LPM via OLS)
Dato $y_i \in \{0, 1\}$, il modello $y_i = \alpha + \beta x_i + \varepsilon_i$ implica $E(y_i \mid x_i) = p_i = \alpha + \beta x_i$:
- **Eteroschedasticità intrinseca**: $\text{Var}(\varepsilon_i \mid x_i) = p_i(1 - p_i) = (\alpha + \beta x_i)(1 - \alpha - \beta x_i)$, massima per $p_i = 0.5$ e tendente a 0 per $p_i \to 0$ o $p_i \to 1$. Richiede correzione sandwich Huber-White (`PROC REG / HCC` in SAS, `sandwich::vcovHC` in R).
- **Non-normalità dei residui**: $\varepsilon_i$ assume solo due valori discreti ($1 - p_i$ con probabilità $p_i$, $-p_i$ con probabilità $1 - p_i$).
- **Previsioni non ammissibili**: $\hat{p}_i \notin [0, 1]$ per valori estremi di $x_i$.

#### 1.2 Odds, Odds Ratio e Formulazione Logit
- **Odds (Quota di scommessa)**:
  $$O_i = \frac{p_i}{1 - p_i}, \quad p_i = \frac{O_i}{1 + O_i}$$
- **Odds Ratio (OR)** tra due gruppi $A$ e $B$: $\text{OR} = \frac{O_A}{O_B} = \frac{p_A / (1 - p_A)}{p_B / (1 - p_B)}$. Nelle tabelle $2 \times 2$, corrisponde al cross-product ratio $\frac{a \cdot d}{b \cdot c}$.
- **Equazione del Modello Logistico**:
  $$\text{logit}(p_i) = \log\left(\frac{p_i}{1 - p_i}\right) = \alpha + \beta_1 x_{i1} + \dots + \beta_k x_{ik}$$
  $$p_i = \frac{\exp(\alpha + \beta' x_i)}{1 + \exp(\alpha + \beta' x_i)} = \frac{1}{1 + \exp(-(\alpha + \beta' x_i))}$$

#### 1.3 Interpretazione dei Coefficienti e Effetti Marginali
- **Odds Ratio aggiustato**: $\text{OR}_j = \exp(\beta_j)$. Per un incremento unitario di $x_j$, l'odds dell'evento aumenta del $100(\exp(\beta_j) - 1)\%$.
- **Effetto Marginale (Marginal Effect)**: pendenza istantanea rispetto a una covariata continua:
  $$\frac{\partial p_i}{\partial x_{ij}} = \beta_j p_i (1 - p_i)$$
  - *Marginal Effect at the Mean (MEM)*: calcolato sostituendo $\bar{p} = \bar{y}$ o $\hat{p}(\bar{x})$.
  - *Average Marginal Effect (AME)*: media delle derivate calcolate per ciascuna singola osservazione $\frac{1}{n}\sum_{i=1}^n \beta_j \hat{p}_i (1 - \hat{p}_i)$.

---

### 2. Dettagli di Stima, Diagnostica e Scelte Avanzate (Capitolo 3)

#### 2.1 Stima di Massima Verosimiglianza (MLE)
- **Log-Likelihood Function**:
  $$\log L(\beta) = \sum_{i=1}^n \left[ y_i \log(p_i) + (1 - y_i) \log(1 - p_i) \right] = \sum_{i=1}^n \left[ y_i (\alpha + \beta' x_i) - \log(1 + e^{\alpha + \beta' x_i}) \right]$$
- **Score (Gradiente)** $U(\beta) = \sum_{i=1}^n (y_i - \hat{p}_i) x_i = 0$.
- **Hessian / Information Matrix** $I(\beta) = \sum_{i=1}^n \hat{p}_i (1 - \hat{p}_i) x_i x_i'$.
- **Algoritmo Newton-Raphson / Fisher Scoring**: $\beta^{(j+1)} = \beta^{(j)} + I(\beta^{(j)})^{-1} U(\beta^{(j)})$.

#### 2.2 Problemi di Separazione dei Dati (Separation)
- **Complete Separation**: esiste un iperpiano lineare nelle covariate che separa perfettamente gli $y_i=1$ dagli $y_i=0$. La MLE non esiste ($\beta \to \infty$, devianza $\to 0$, standard error $\to \infty$, Wald test inaffidabile).
- **Quasi-Complete Separation**: per quasi tutte le configurazioni di $x$ l'esito è deterministico, tranne per una singola coordinata/cella (molto frequente con dummy contenenti celle a frequenza zero).
- **Risoluzioni**:
  1. *Firth Penalized Likelihood (`FIRTH`)*: modifica lo score con il gradiente dell'informazione di Jeffreys $U^*(\beta) = U(\beta) + \frac{1}{2} \text{Tr}[I(\beta)^{-1} \frac{\partial I(\beta)}{\partial \beta}]$, rimuovendo il bias di primo ordine e garantendo stime finite.
  2. *Exact Logistic Regression (`EXACT`)*: condiziona sulle statistiche sufficienti senza assumere asintoticità (generalizzazione del Fisher exact test).
  3. *Profile Likelihood CIs (`CLPARM=PL`)*: affidabili anche in presenza di quasi-separazione dove i test di Wald falliscono.
  4. *Accorpamento categorie (Collapsing levels)* o esclusione controllata del sottogruppo deterministico.

#### 2.3 Misure di Bontà di Adattamento e Potere Predittivo
- **Devianza ($G^2$) e Pearson $\chi^2$**: interpretabili come test formali solo su dati raggruppati (grouped data / profili finiti). Su dati individuali non seguono una distribuzione asintotica $\chi^2$.
- **Hosmer-Lemeshow Test (`LACKFIT`)**: raggruppa le osservazioni in 10 decili di probabilità predetta e confronta eventi osservati vs attesi con un test $\chi^2_{g-2}$. *Attenzione*: sensibile al numero di classi e poco potente verso interazioni specifiche.
- **Pseudo-$R^2$**:
  - *Cox & Snell (Generalized $R^2$)*: $R^2 = 1 - \exp(-L^2 / n)$ dove $L^2 = 2(\log L_{model} - \log L_0)$. Limite superiore $< 1$.
  - *Nagelkerke (Max-Rescaled $R^2$)*: normalizzato dividendo per $1 - \exp(2 \log L_0 / n)$.
  - *McFadden*: $R^2_{McF} = 1 - \frac{\log L_{model}}{\log L_0}$.
  - *Tjur's Coefficient of Discrimination ($D$)*: $D = \bar{\hat{p}}_{y=1} - \bar{\hat{p}}_{y=0}$. Varia tra 0 e 1, intuitivo e non parametrico.
- **ROC Curve e Statistica $c$ (AUC)**:
  - *Sensitivity*: $\frac{TP}{TP + FN}$ (True Positive Rate).
  - *Specificity*: $\frac{TN}{TN + FP} \implies 1 - \text{Specificity} = \frac{FP}{TN + FP}$ (False Positive Rate).
  - Area Under Curve ($c$-statistic): probabilità che un'osservazione positiva scelta a caso abbia una probabilità predetta superiore a un'osservazione negativa scelta a caso ($c = 0.5 \implies$ lancio di moneta; $c > 0.8 \implies$ eccellente discriminazione).

#### 2.4 Modelli Alternativi: Probit e Cloglog
- **Modello a Variabile Latente**: $y_i^* = \alpha_0 + \alpha' x_i + \sigma \varepsilon_i$, con $y_i = 1$ se $y_i^* > \mu$, altrimenti 0.
  - Se $\varepsilon \sim \text{Logistic}$, $\beta = \alpha / \sigma \implies$ **Logit** ($\sigma = \pi / \sqrt{3} \approx 1.814$).
  - Se $\varepsilon \sim N(0, 1)$, $\Phi^{-1}(p_i) = \alpha + \beta' x_i \implies$ **Probit** ($\sigma = 1$). I coefficienti Probit sono approssimativamente $\beta_{\text{logit}} / 1.6 \approx 0.625 \beta_{\text{logit}}$.
  - Se $\varepsilon \sim \text{Extreme Value (Gumbel)}$, $\log(-\log(1 - p_i)) = \alpha + \beta' x_i \implies$ **Complementary Log-Log (Cloglog)** (asimmetrico, legato ai modelli a rischi proporzionali in tempo discreto).

---

### 3. Modelli Politomici e Scelte Discrete (Capitoli 5–7)

#### 3.1 Multinomial Logit (Categorie Nominali $J > 2$)
Per variabili di risposta senza ordinamento naturale (es. scelta del mezzo di trasporto: Auto, Bus, Treno):
- **Formulazione con Categoria di Riferimento ($J$)**:
  $$\log\left(\frac{P(Y_i = j)}{P(Y_i = J)}\right) = \alpha_j + \beta_{j1} x_{i1} + \dots + \beta_{jk} x_{ik}, \quad j = 1, \dots, J-1$$
  $$P(Y_i = j) = \frac{\exp(\alpha_j + \beta_j' x_i)}{1 + \sum_{m=1}^{J-1} \exp(\alpha_m + \beta_m' x_i)}$$
- **Ipotesi IIA (Independence of Irrelevant Alternatives)**: il rapporto tra le probabilità di due scelte qualsiasi è indipendente dalla presenza o dalle caratteristiche di altre alternative disponibili (paradosso del *Red Bus / Blue Bus*).

#### 3.2 Logistic Regression per Categorie Ordinate (Capitolo 6)
Quando le categorie possiedono un ordinamento intrinseco (es. Severità: Lieve, Moderata, Grave):
- **Cumulative Logit (Proportional Odds Model)**:
  $$\log\left(\frac{P(Y_i \le j)}{P(Y_i > j)}\right) = \alpha_j - \beta' x_i, \quad j = 1, \dots, J-1$$
  - *Ipotesi dei Rischi/Odds Proporzionali*: i coefficienti $\beta$ sono identici attraverso tutti i cutpoint $j$; cambiano solo le intercette $\alpha_1 < \alpha_2 < \dots < \alpha_{J-1}$.
  - *Score Test for Proportional Odds*: verifica l'uguaglianza delle pendenze tra categorie. Se rigettato, si usano modelli a quote parzialmente proporzionali o modelli multinomiali.
- **Modelli Alternativi**:
  - *Adjacent Categories Model*: confronta categorie adiacenti $\log(P(Y=j)/P(Y=j+1))$.
  - *Continuation Ratio Model*: probabilità condizionata di fermarsi al livello $j$ dato che si è raggiunto almeno il livello $j$ (equivalente a un modello di sopravvivenza in tempo discreto).

#### 3.3 Discrete Choice Analysis (McFadden Random Utility Model — Capitolo 7)
Modella la scelta tra alternative sulla base di attributi che variano sia per individuo che per alternativa:
- **Utilità Latente**: $U_{ij} = V_{ij} + \varepsilon_{ij} = \beta' x_{ij} + \gamma_j' z_i + \varepsilon_{ij}$, dove $x_{ij}$ sono attributi dell'alternativa e $z_i$ caratteristiche dell'individuo.
- **Conditional Logit (McFadden)**: assumendo errori $\varepsilon_{ij}$ i.i.d. Gumbel:
  $$P(Y_i = j) = \frac{\exp(\beta' x_{ij} + \gamma_j' z_i)}{\sum_{k \in C_i} \exp(\beta' x_{ik} + \gamma_k' z_i)}$$
- **Modelli Avanzati**: Nested Logit (allenta IIA raggruppando scelte correlate in nidi), Mixed/Random Parameters Logit (eterogeneità continua nelle preferenze).

---

### 4. Dati Longitudinali, Clusterizzati e di Conteggio (Capitoli 8–9)

#### 4.1 Modelli Logit per Dati Clusterizzati / Panel
Dati con misure ripetute sullo stesso soggetto o soggetti raggruppati in cluster (scuole, famiglie, ospedali):
1. **Marginal / Population-Averaged Models (GEE)**:
   - Modella la media marginale senza assumere distribuzioni per gli effetti casuali.
   - Corregge la matrice di covarianza usando una struttura di correlazione di lavoro (autoregressiva, exchangeable, unstructured) e lo stimatore a sandwich (Huber-White).
2. **Subject-Specific Random Effects (GLMM)**:
   - Introduce un termine casuale individuale: $\text{logit}(p_{it}) = \alpha + \beta' x_{it} + u_i$, con $u_i \sim N(0, \sigma_u^2)$.
   - Stimato via quadratura gaussiana adattiva. I coefficienti condizionali sono sistematicamente più grandi in magnitudo rispetto a quelli marginali (GEE) a causa dell'unobserved heterogeneity shrinkage.
3. **Fixed Effects via Conditional Logistic Regression**:
   - Elimina l'effetto fisso non osservato $u_i$ condizionando sul numero totale di successi per individuo $\sum_t y_{it}$.
   - Non richiede alcuna assunzione distributiva su $u_i$, ma cancella i soggetti con esiti costanti (tutti 0 o tutti 1) e impedisce la stima di covariate tempo-invarianti.

#### 4.2 Regressione per Dati di Conteggio (Count Data — Capitolo 9)
Modellazione di variabili di conteggio non negative ($y_i \in \{0, 1, 2, \dots\}$):
- **Poisson Regression**:
  $$\log(\mu_i) = \beta' x_i \implies \mu_i = \exp(\beta' x_i)$$
  - *Ipotesi di Equidispersione*: $E(y_i) = \text{Var}(y_i) = \mu_i$.
  - *Offset*: per modellare tassi rispetto a un tempo di esposizione o volume $T_i$: $\log(\mu_i) = \log(T_i) + \beta' x_i$.
- **Negative Binomial Regression (Sovradispersione)**:
  - Rilassa l'equidispersione introducendo eterogeneità Gamma moltiplicativa: $\text{Var}(y_i) = \mu_i + \alpha \mu_i^2$, dove $\alpha > 0$ è il parametro di dispersione.
- **Zero-Inflated Models (ZIP e ZINB)**:
  - Gestiscono un eccesso strutturale di zeri combinando un processo logistico latente (distingue chi non può mai incorrere nell'evento dai soggetti suscettibili) e un processo Poisson/NB per i soggetti suscettibili.

---

## Mappatura Strumenti: SAS $\leftrightarrow$ R

| Metodologia / Modello | Procedura SAS (Allison) | Funzione / Pacchetto R | Note Metodologiche |
|---|---|---|---|
| **Binary Logistic Regression** | `PROC LOGISTIC DATA=df; MODEL y(EVENT='1') = x1 x2;` | `glm(y ~ x1 + x2, family=binomial(link="logit"), data=df)` | SAS modella di default il livello più basso se omesso `EVENT='1'`. |
| **Reference Coding (Dummy)** | `CLASS cat / PARAM=REF;` | Default in R per fattori (`contr.treatment`) | Il default di SAS senza `PARAM=REF` è l'Effect coding (ANOVA, sum-to-zero). |
| **Firth Penalized Likelihood** | `MODEL y = x / FIRTH;` | `logistf::logistf(y ~ x, data=df)` | Risolve la quasi-separazione / separazione completa. |
| **Exact Logistic Regression** | `EXACT x1 x2 / ESTIMATE=BOTH;` | `elrm::elrm()` o `coxph` stratificato | Test esatti condizionati per piccoli campioni. |
| **Profile Likelihood CIs** | `MODEL y = x / CLPARM=PL;` | `MASS::confint(glm_fit)` | Più accurati dei Wald CI in campioni finiti. |
| **Hosmer-Lemeshow Test** | `MODEL y = x / LACKFIT;` | `ResourceSelection::hoslem.test(y, fitted(m))` | Test di calibrazione a 10 gruppi. |
| **ROC & AUC Analysis** | `PLOTS(ONLY)=ROC; ROC 'sub' x1; ROCCONTRAST;` | `pROC::roc()`, `pROC::roc.test()` | Confronto non parametrico dell'area sotto la curva. |
| **Marginal Effects** | `PROC QLIM; OUTPUT OUT=df MARGINAL;` | `marginaleffects::avg_slopes(m)` | Derivate parziali AME vs MEM. |
| **Multinomial Logit** | `PROC LOGISTIC; MODEL y = x / LINK=GLOGIT;` | `nnet::multinom(y ~ x)` o `mlogit::mlogit` | Categorie non ordinate, assume IIA. |
| **Cumulative Logit (Ordinal)** | `PROC LOGISTIC; MODEL y_ord = x;` | `MASS::polr(y_ord ~ x, method="logistic")` | Modello a quote proporzionali. |
| **Discrete Choice / Conditional** | `PROC LOGISTIC; STRATA group; MODEL choice = attr;` | `survival::clogit(choice ~ attr + strata(group))` | Conditional logit di McFadden. |
| **Advanced Choice Models** | `PROC MDC; MODEL choice = attr / TYPE=NLOGIT;` | `mlogit::mlogit(..., type="nested")` | Nested logit, mixed logit, MNP. |
| **Longitudinal / Clustered (GEE)** | `PROC GENMOD; REPEATED SUBJECT=id / TYPE=AR;` | `geepack::geeglm(y ~ x, id=id, family=binomial, corstr="ar1")` | Modelli di popolazione mediata, errori sandwich. |
| **Random Effects (GLMM)** | `PROC GLIMMIX; MODEL y = x / DIST=BINARY; RANDOM id;` | `lme4::glmer(y ~ x + (1|id), family=binomial)` | Modello a effetti casuali soggetto-specifici. |
| **Fixed Effects Logit** | `PROC LOGISTIC; STRATA id; MODEL y = x;` | `survival::clogit(y ~ x + strata(id))` | Condiziona eliminando l'eterogeneità fissa. |
| **Count: Poisson Regression** | `PROC GENMOD; MODEL count = x / DIST=POISSON;` | `glm(count ~ x, family=poisson)` | Tassi modellabili tramite offset `+ offset(log(T))`. |
| **Count: Negative Binomial** | `PROC GENMOD; MODEL count = x / DIST=NEGBIN;` | `MASS::glm.nb(count ~ x)` | Corregge la sovraddispersione $\text{Var} = \mu + \alpha\mu^2$. |
| **Zero-Inflated Count (ZIP/ZINB)** | `PROC GENMOD; MODEL count = x / DIST=ZIP; ZEROMODEL z;` | `pscl::zeroinfl(count ~ x | z, dist="poisson")` | Processo a 2 componenti (zeri strutturali + conteggio). |
