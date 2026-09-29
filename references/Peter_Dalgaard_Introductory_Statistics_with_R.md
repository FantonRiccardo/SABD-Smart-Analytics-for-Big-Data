# Introductory Statistics with R (2nd Edition) — Peter Dalgaard

> **Autore**: Peter Dalgaard (Department of Biostatistics, University of Copenhagen)  
> **Editore**: Springer (Statistics and Computing Series)  
> **ISBN**: 978-0-387-79053-4  
> **Riferimento corso**: *Smart Analytics for Big Data (SABD) — Grenoble INP*  

---

## Indice dei Capitoli (Table of Contents)

1. **Basics**: R environment, vector arithmetic, indexing, logical selections, factors, data frames, lists, implicit loops (`lapply`, `sapply`, `apply`, `tapply`), sorting.
2. **The R Environment**: Session management (`ls`, `rm`, `save.image`), graphic layout (`par`, `mfrow`), scripting, data import (`read.table`, `read.csv`).
3. **Probability and Distributions**: Random sampling (`sample`), combinatorics (`choose`), discrete distributions (`dbinom`, `pbinom`, `qbinom`, `rbinom`), continuous distributions (`dnorm`, `pnorm`, `qnorm`, `rnorm`).
4. **Descriptive Statistics and Graphics**: Means, SD, quantiles, histograms (`hist`), empirical CDF (`ecdf`), Q-Q plots (`qqnorm`), boxplots, stripcharts, tables (`table`, `xtabs`, `ftable`, `prop.table`), barplots, dotcharts.
5. **One- and Two-Sample Tests**: One-sample $t$-test (`t.test`), Wilcoxon signed-rank (`wilcox.test`), two-sample $t$-test (Welch vs Student), variance comparison (`var.test`), paired $t$-test.
6. **Regression and Correlation**: Simple OLS (`lm(y ~ x)`), fitted values & residuals (`fitted`, `resid`), prediction/confidence bands (`predict(..., interval="confidence")`), correlation (Pearson, Spearman, Kendall via `cor.test`).
7. **Analysis of Variance and Kruskal–Wallis**: One-way ANOVA (`anova(lm(y ~ f))`), pairwise comparisons (`pairwise.t.test`), non-parametric Kruskal–Wallis (`kruskal.test`), two-way ANOVA, Friedman test (`friedman.test`).
8. **Tabular Data**: Single proportions (`prop.test`, `binom.test`), two independent proportions, trend test in proportions (`prop.trend.test`), contingency tables ($\chi^2$ test via `chisq.test`, Fisher exact test via `fisher.test`).
9. **Power and Sample Size Calculation**: Principles of power calculations, `power.t.test` (one-sample, two-sample, paired), `power.prop.test`.
10. **Advanced Data Handling**: Recoding variables (`cut`), manipulating factor levels, date handling (`as.Date`), restructuring (`rbind`, `merge`, `reshape` wide $\leftrightarrow$ long), `split`/`unsplit`/`ave`.
11. **Multiple Regression**: Multivariate formulas (`y ~ x1 + x2 + x3`), model search & backward elimination (`step`, `drop1`), nested model comparison via `anova(m1, m2)`.
12. **Linear Models**: Polynomial regression (`I(x^2)`), regression through the origin (`y ~ x - 1`), design matrices & dummy variables (`model.matrix`), interaction terms (`a*b = a + b + a:b`), ANCOVA (Analysis of Covariance), regression diagnostics (`plot(lm.fit, which=1:4)`, `cooks.distance`, `rstudent`, `dfbetas`, `dffits`).
13. **Logistic Regression (GLM)**: Binary & tabular logistic regression (`glm(y ~ x, family=binomial("logit"))`), deviance table (`anova(glm.fit, test="Chisq")`), odds ratio estimation (`exp(coef(fit))`), likelihood profiling (`confint`).
14. **Survival Analysis**: Survival objects (`Surv(time, event)`), Kaplan–Meier estimation (`survfit`), Log-Rank test (`survdiff`), Cox Proportional Hazards model (`coxph` da package `survival`).
15. **Rates and Poisson Regression**: Poisson GLM (`glm(cases ~ city + age + offset(log(pop)), family=poisson)`), SMR (Standardized Mortality Rate), piecewise constant intensities.
16. **Nonlinear Curve Fitting**: Non-linear least squares (`nls`), Gompertz curves, self-starting models (`SSgompertz`), parameter profiling.

---

## Compendio Rapido di Sintassi R (Appendix C Dalgaard)

### 1. Operatori e Assegnazione
- Assegnazione: `x <- 2` (oppure `x = 2`)
- Aritmetica: `+`, `-`, `*`, `/`, `^` (potenza), `%/%` (divisione intera), `%%` (modulo/resto).
- Logica: `==`, `!=`, `<`, `>`, `<=`, `>=`, `is.na(x)`, `&` (AND vettoriale), `|` (OR vettoriale), `!` (NOT).

### 2. Gestione Oggetti e Workspace
- `ls()`: lista variabili in memoria.
- `rm(x, y)`: elimina variabili.
- `rm(list = ls())`: pulisce completamente il workspace.
- `save.image()`: salva il workspace in `.RData`.
- `load(".RData")`: ricarica lo stato salvato.

### 3. Vettori e Data Frame
- Creazione vettori: `c(1, 2, 3)`, `seq(from, to, by)`, `rep(x, times)`.
- Fattori / Categoriche: `factor(x, levels = ..., labels = ...)`.
- Data Frame: `data.frame(col1, col2)`, `df$col1`, `df[riga, colonna]`, `subset(df, condizione)`.
- Trasformazioni: `transform(df, new_col = ...)` oppure con Tidyverse: `df %>% mutate(new_col = ...)`.

### 4. Distribuzioni Statistiche
Per ogni distribuzione (`norm`, `binom`, `t`, `f`, `chisq`, `pois`, `unif`, `exp`):
- `d<dist>`: densità o probabilità puntuale (es. `dnorm(x)`).
- `p<dist>`: funzione di ripartizione cumulata $P(X \le x)$ (es. `pnorm(1.96)`).
- `q<dist>`: quantili (inversa della cumulata, es. `qnorm(0.975)` $\approx 1.96$).
- `r<dist>`: generazione numeri pseudo-casuali (es. `rnorm(100)`).

### 5. Sintassi dei Modelli e Formule (`formula`)
- `~`: "spiegato da" / descritto da.
- `+`: effetto additivo (`y ~ x1 + x2`).
- `:`: interazione (`y ~ x1:x2`).
- `*`: effetti principali + interazione (`y ~ x1*x2` $\equiv$ `y ~ x1 + x2 + x1:x2`).
- `- 1`: rimozione dell'intercetta (passaggio per l'origine).
- `I(...)`: protezione di espressioni aritmetiche nelle formule (es. `I(x^2)`).
- `offset(...)`: termine di offset per Poisson GLM (es. `offset(log(pop))`).

### 6. Funzioni Estrattrici per Oggetti `lm` e `glm`
- `summary(fit)`: stime coefficienti, standard error, $t$/$z$-stat, $p$-value, $R^2$, devianza.
- `anova(fit)`: tabella ANOVA / devianza sequenziale.
- `anova(m1, m2)`: confronto modelli annidati ($F$-test o $\chi^2$-LRT).
- `coef(fit)`: vettore dei coefficienti stimati.
- `fitted(fit)`: valori predetti $\hat{y}$ sul training set.
- `resid(fit)`: residui $y - \hat{y}$.
- `predict(fit, newdata, interval = "confidence")`: predizioni e bande di confidenza/predizione.
- `confint(fit)`: intervalli di confidenza per i parametri.
- `plot(fit, which = 1:4)`: 4 grafici diagnostici standard (Residui vs Fitted, Q-Q plot, Scale-Location, Cook's Distance).
