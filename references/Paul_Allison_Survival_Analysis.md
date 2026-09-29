# Survival Analysis Using SAS: A Practical Guide (2nd Edition) — Paul D. Allison

> **Autore**: Paul D. Allison (University of Pennsylvania)  
> **Editore**: SAS Institute Inc. (SAS Press Series)  
> **ISBN**: 978-1-59994-640-5  
> **Riferimento corso**: *Smart Analytics for Big Data (SABD) — Grenoble INP*  

---

## Panoramica e Concetti Chiave

L'opera di Paul D. Allison costituisce il testo di riferimento per l'**analisi di sopravvivenza (Survival Analysis / Event History Analysis / Reliability / Duration Analysis)**. Si focalizza sulla modellazione di eventi nel tempo in presenza di **dati censurati** (censoring) e **covariate tempo-dipendenti**.

---

## Indice dei Capitoli e Struttura Metodologica

### 1. Introduction & Basic Concepts (Capitoli 1–2)
- **Definizione di evento**: transizione discreta qualitativa situata nel tempo (es. decesso, guasto macchinari, recidiva, disoccupazione, default).
- **Tipologie di Censoring**:
  - *Right Censoring*: l'evento si verifica dopo la fine del periodo di osservazione ($T > c$).
  - *Left Censoring*: l'evento o l'origine si colloca prima dell'inizio dell'osservazione.
  - *Interval Censoring*: l'evento si verifica all'interno di un intervallo temporale $[a, b)$.
  - *Noninformative Censoring*: il meccanismo di censura è indipendente dalla prognosi dell'individuo a parità di covariate.
- **Funzioni Fondamentali**:
  - *Survivor Function*: $S(t) = P(T > t) = 1 - F(t)$
  - *Probability Density Function (PDF)*: $f(t) = -\frac{dS(t)}{dt}$
  - *Hazard Function (Rischio istantaneo)*: $h(t) = \lim_{\Delta t \to 0} \frac{P(t \le T < t+\Delta t \mid T \ge t)}{\Delta t} = \frac{f(t)}{S(t)} = -\frac{d \log S(t)}{dt}$
  - *Cumulative Hazard*: $\Lambda(t) = \int_0^t h(u) du = -\log S(t) \implies S(t) = \exp(-\Lambda(t))$

---

### 2. Metodi Non Parametrici: Kaplan-Meier e Life-Tables (Capitolo 3)
- **Kaplan-Meier Estimator (Product-Limit)**:
  $$\hat{S}(t) = \prod_{j: t_j \le t} \left(1 - \frac{d_j}{n_j}\right)$$
  dove $d_j$ sono i decessi/eventi al tempo $t_j$ e $n_j$ è il numero di soggetti a rischio (risk set).
- **Test di Confronto tra Curve**:
  - *Log-Rank Test*: $\sum (d_{1j} - e_{1j})$, ottimale sotto l'ipotesi di rischi proporzionali (più sensibile a differenze nei tempi tardivi).
  - *Wilcoxon (Breslow/Gehan) Test*: $\sum n_j (d_{1j} - e_{1j})$, pesato per la numerosità a rischio (più sensibile a differenze precoci).
  - *Tarone-Ware, Peto-Peto, Fleming-Harrington*.
- **Equivalente R**: `survival::survfit()`, `survival::survdiff()`.

---

### 3. Modelli Parametrici: Accelerated Failure Time (AFT) (Capitolo 4)
- **Formulazione AFT**:
  $$\log T_i = \mu + \beta_1 x_{i1} + \dots + \beta_k x_{ik} + \sigma \varepsilon_i$$
- **Distribuzioni dell'Errore $\varepsilon$ e di $T$**:
  - *Esponenziale*: Hazard costante $h(t) = \lambda$ ($\sigma = 1$, estremo valore a 1 parametro).
  - *Weibull*: Hazard monotono crescente/decrescente $h(t) = \lambda \gamma t^{\gamma-1}$ ($\sigma = 1/\gamma$). È sia AFT che Proportional Hazards.
  - *Log-Normale*: $\varepsilon \sim N(0, 1)$, hazard a forma di campana asimmetrica (sale e poi decresce a zero).
  - *Log-Logistica*: $\varepsilon$ logistica, hazard a campana/inversa $U$.
  - *Gamma Generalizzata*: modello a 3 parametri che racchiude Weibull ($\delta=1$), Esponenziale ($\sigma=1, \delta=1$) e Log-Normale ($\delta=0$).
- **Interpretazione Coefficienti AFT**:
  - $\exp(\beta_j)$: fattore moltiplicativo sul tempo atteso di sopravvivenza ($100(\exp(\beta_j)-1)\%$ variazione percentuale).
- **Equivalente R**: `survival::survreg(Surv(time, event) ~ x, dist="weibull")`.

---

### 4. Modello di Cox a Rischi Proporzionali (Capitolo 5)
- **Formulazione Semiparametrica**:
  $$h_i(t) = h_0(t) \exp(\beta_1 x_{i1} + \dots + \beta_k x_{ik})$$
  dove $h_0(t)$ è la baseline hazard non specificata.
- **Stima via Partial Likelihood**:
  $$PL(\beta) = \prod_{j=1}^k \frac{\exp(\beta' x_{(j)})}{\sum_{l \in R(t_j)} \exp(\beta' x_l)}$$
- **Gestione dei Legami (Tied Data)**: metodi Breslow, Efron (standard/più accurato), Exact.
- **Covariate Tempo-Dipendenti e Sintassi Counting Process**: intervalli $(t_{\text{start}}, t_{\text{stop}}, \text{event})$.
- **Verifica Assunzione di Proporzionalità**: residui di Schoenfeld, interazioni con il tempo ($x \times \log t$), stratificazione.
- **Equivalente R**: `survival::coxph(Surv(time, event) ~ x, ties="efron")`, `survival::cox.zph()`.

---

### 5. Competing Risks & Modelli Avanzati (Capitoli 6–8)
- **Rischi Competitivi (Competing Risks)**:
  - *Cause-Specific Hazard*: modella il rischio di uno specifico tipo di evento trattando gli altri come censure.
  - *Cumulative Incidence Functions (CIF)*: probabilità assoluta di incorrere nell'evento $k$ prima del tempo $t$.
- **Dati Discreti e Raggruppati (Discrete-Time Hazard)**:
  - Modelli Logit / Complementary Log-Log (`cloglog`) stimati come regressioni logistiche binarie su intervalli discreti.
- **Eterogeneità Non Osservata (Frailty Models) & Eventi Ripetuti**:
  - Modelli a effetti casuali / frailty ($\gamma$-frailty, log-normale) per cluster o eventi multipli sullo stesso soggetto.
  - Varianza robusta sandwich (Huber-White / Lin-Wei).

---

## Mappatura Strumenti: SAS $\leftrightarrow$ R

| Metodologia | Procedura SAS (Allison) | Funzione R (`survival` / `cmprsk`) |
|---|---|---|
| **Curve Kaplan-Meier** | `PROC LIFETEST METHOD=KM;` | `survfit(Surv(time, status) ~ group)` |
| **Log-Rank / Wilcoxon Test** | `STRATA group / TESTS=ALL;` | `survdiff(Surv(time, status) ~ group)` |
| **Life-Table Attuariale** | `PROC LIFETEST METHOD=LIFE;` | `KMsurv::lifetab()` |
| **Regressione Parametrica (AFT)** | `PROC LIFEREG; MODEL t*s(0)=x / D=WEIBULL;` | `survreg(Surv(time, status) ~ x, dist="weibull")` |
| **Modello di Cox (PH)** | `PROC PHREG; MODEL t*s(0)=x;` | `coxph(Surv(time, status) ~ x, data=df)` |
| **Covariate Tempo-Dipendenti** | `PROC PHREG; MODEL (tstart, tstop)*s(0)=x;` | `coxph(Surv(tstart, tstop, status) ~ x)` |
| **Verifica Proporzionalità** | `ASSESS PH / RESAMPLE;` | `cox.zph(cox_fit)` |
| **Competing Risks (CIF)** | `PROC PHREG; / CUMINC;` | `cmprsk::cuminc(ftime, fstatus, group)` |
| **Discrete Time (Logit/Cloglog)** | `PROC LOGISTIC; MODEL event=x / LINK=CLOGLOG;` | `glm(event ~ x + factor(time), family=binomial("cloglog"))` |
