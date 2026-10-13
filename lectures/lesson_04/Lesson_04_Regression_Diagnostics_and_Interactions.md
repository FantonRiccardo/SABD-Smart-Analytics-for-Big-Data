# Lezione 04: Regressione Lineare, Diagnostica dei Residui e Interazioni
**Corso:** Smart Analytics for Big Data (SABD / 5GUC3500) — Grenoble INP  
**Docente:** Prof. Iragaël Joly  
**Riferimento codice:** `Ex_lesson_04.R` e `Exercise_Regression/TD_RegOverview_BigMart_2023.Rmd`

---

## 1. Che calcolo fa davvero OLS con le Dummy e le Interazioni?

### Il Senso della Simulazione Monte Carlo (DGP vs Stimatore)
Nello script `Ex_lesson_04.R`, $x_1$ ha la stessa distribuzione uniforme $[0, 10]$ sia per gli uomini sia per le donne (gli uomini non fanno più ore delle donne, $x_1$ è ortogonale a `gender`).
La differenza non sta in $x_1$, ma nella **riga 7**, dove viene generata artificialmente la variabile target $y$:
```r
y <- 3 + 1.3 * as.numeric(gender == "Man") + 1.5 * x1 + as.numeric(gender == "Man") * x1 * -1.8 + epsi
```
Questa riga è il **Data Generating Process (DGP)**: siamo noi a stabilire le regole fisiche dell'universo simulato.
* **Noi nascondiamo la verità:** Costruiamo $y$ imponendo che per le donne la pendenza sia $+1{,}5$ e per gli uomini sia $-0{,}3$ ($1{,}5 - 1{,}8$), aggiungendo solo un piccolo rumore casuale $\varepsilon \sim \mathcal{N}(0, 4)$.
* **Cosa fa `lm()`:** L'algoritmo `lm()` è un detective cieco. Non conosce la riga 7, riceve solo la tabella con i numeri di $y$, $x_1$ e `gender`.
* **Perché ritrova proprio quei valori:** Poiché i minimi quadrati ordinari (OLS) sono uno stimatore corretto e non distorto (*unbiased*), minimizzando $\sum e_i^2$ l'algoritmo ripulisce il rumore $\varepsilon$ e recupera con precisione chirurgica i veri parametri che avevamo iniettato ($\hat{\beta}_1 \approx 1{,}5$, $\hat{\beta}_3 \approx -1{,}8$).
* **Scopo didattico:** Testare se lo strumento funziona quando la verità è nota, per avere la certezza di poterci fidare quando applicheremo `lm()` su dati reali (Mobilità o BigMart) dove la formula della natura è sconosciuta.

### La Forma Algebrica Intuitiva (Raggruppata)
Tenere separati i termini nella formula della riga 7 non aiuta l'intuizione. Raggruppando rispetto a $x_1$:
$$y = \underbrace{(3 + 1{,}3 \cdot \text{Man})}_{\text{Intercetta specifica}} + \underbrace{(1{,}5 - 1{,}8 \cdot \text{Man})}_{\text{Pendenza specifica}} \cdot x_1 + \varepsilon$$
* **Se Donna (`Man = 0`):** $y = 3{,}0 + 1{,}5 \cdot x_1 + \varepsilon$ (intercetta 3, pendenza $+1{,}5$).
* **Se Uomo (`Man = 1`):** $y = (3{,}0 + 1{,}3) + (1{,}5 - 1{,}8) \cdot x_1 + \varepsilon = 4{,}3 - 0{,}3 \cdot x_1 + \varepsilon$ (intercetta 4,3, pendenza $-0{,}3$).

---

### Che calcolo fa OLS sotto il cofano?
Per stimare i parametri, OLS crea una matrice $X$ a 4 colonne:
1. `(Intercept)`: colonna di soli $1$.
2. `x1`: valori continui da 0 a 10.
3. `genderMan`: vettore binario ($0$ per donna, $1$ per uomo).
4. `x1:genderMan`: **il prodotto algebrico riga per riga** tra colonna 2 e colonna 3.
   - Per le donne: $x_1 \times 0 = 0$ (valore sempre nullo).
   - Per gli uomini: $x_1 \times 1 = x_1$ (il valore reale di $x_1$).

### Risoluzione dell'equivoco: Varianza di cosa se gli uomini sono tutti 1?
Un vettore di soli $1$ ha ovviamente varianza zero: non stiamo calcolando la varianza della dummy!
Immagina di aprire il dataset in un foglio Excel e applicare un filtro:
1. **Filtra solo le righe dove `gender == "Man"` (circa 60 persone):**
   * Guarda la colonna $x_1$ (es. ore di lavoro): i valori sono $1{,}2, 4{,}5, 7{,}8, 9{,}1\dots$ (variano da 0 a 10).
   * Guarda la colonna $y$ (es. stress): i valori sono $4{,}1, 3{,}2, 2{,}1, 1{,}4\dots$ (variano anch'essi).
   * Calcoli la pendenza ordinaria OLS su quel sottoinsieme:
     $$\text{Pendenza Uomini} = \frac{\text{Cov}(x_1, y)_{\text{uomini}}}{\text{Var}(x_1)_{\text{uomini}}} \approx -0{,}3$$
     Perché tra gli uomini chi ha lavorato più ore ($x_1$ alto) ha registrato valori di $y$ più bassi.
2. **Filtra solo le righe dove `gender == "Woman"`:**
   * Fai lo stesso calcolo su $x_1$ e $y$ delle sole donne e ottieni $+1{,}5$.
3. **Il ruolo della dummy binaria:**
   Il vettore binario di `0` e `1` è semplicemente un "interruttore algebrico": serve a far svolgere a R entrambi i calcoli contemporaneamente in una sola regressione, stimando la pendenza base delle donne ($+1{,}5$) e il differenziale sottrattivo degli uomini ($-1{,}8$, per cui $+1{,}5 - 1{,}8 = -0{,}3$).

---

## 2. Il Test F di Fisher (`anova(OLS3, OLS1)`): Il Rapporto Segnale/Rumore

Quando esegui `anova(OLS3, OLS1)`:
* **Modello 1 (`OLS3`):** $y \sim x_1 + \text{gender}$ (modello ristretto a rette parallele, $SSR = 1107{,}38$).
* **Modello 2 (`OLS1`):** $y \sim x_1 \times \text{gender}$ (modello completo con pendenze libere, $SSR = 458{,}86$).

### Cosa testa l'ipotesi nulla $H_0$?
L'ipotesi nulla è scettica: *"L'interazione non esiste nella realtà ($\beta_{\text{interazione}} = 0$). Le rette vere sono parallele. Il calo di errore che vedi aggiungendo l'interazione è dovuto solo alla fortuna o al caso campionario."*

### Perché $F = 163{,}95$ è gigantesco?
La statistica $F$ è un rapporto segnale/rumore:
$$F = \frac{\text{Varianza spiegata dal nuovo parametro}}{\text{Varianza casuale residua}} = \frac{(1107{,}38 - 458{,}86) / 1}{458{,}86 / 116} \approx 163{,}95$$
* Se l'ipotesi nulla fosse vera (aggiunta di un parametro inutile), la statistica $F$ oscillerebbe attorno a $1$ (sotto la gobba della distribuzione $F$).
* Ottenere $F = 164$ significa che l'interazione riduce l'errore di una quantità **164 volte superiore al rumore casuale**.
* Il $p$-value $< 2{,}2 \times 10^{-16}$ indica che la probabilità di ottenere questo risultato per caso è praticamente zero.
* **Decisione:** Rifiuto netto di $H_0$. Il vincolo di parallelismo viene bocciato: l'interazione è reale e indispensabile.

---

## 3. Le 4 Diagnostiche dei Residui (`plot(lm)`): Guida Concettuale

### A. Residuals vs Fitted (Verifica di Linearità)
* **Obiettivo:** Verificare se una retta è il modello corretto o se serve una curva (polinomio $x_1^2$, termine logaritmico, spline).
* **Meccanismo:** Se la vera relazione fosse parabolica ma noi stimiamo una retta lineare, il modello sottostimerebbe al centro e sovrastimerebbe agli estremi. La linea rossa farebbe una conca a "U".
* **Esito nel nostro modello:** La linea rossa è piatta e orizzontale su zero. Conferma che non serve introdurre gradi superiori (es. polinomi).

### B. Normal Q-Q Plot (Confronto con la Campana di Gauss)
* **Obiettivo:** Verificare se i residui seguono una distribuzione normale $\mathcal{N}(0, \sigma^2)$.
* **Meccanismo:** Mette a confronto i quantili teorici gaussiani (dove dovrebbero cadere i punti) con i quantili standardizzati reali (dove cadono davvero).
  * Se gli errori sono gaussiani, tutti i punti cadono sulla bisettrice a 45 gradi.
* **Perché 500 minuti di viaggio deformano il grafico a "bastone da hockey"?**
  In una curva gaussiana con media 90 min e deviazione standard 50 min:
  * Un valore a $+3\sigma$ (240 min) accade 1 volta su 740.
  * Un valore di 500 min si trova a $(500 - 90)/50 = +8{,}2\sigma$ dalla media.
  * In una gaussiana, $+8\sigma$ ha una probabilità di $10^{-16}$ (un evento ogni miliardi di anni).
  * Se nel campione trovi persone reali che viaggiano 300 o 500 minuti, non sono semplici "outlier rari": indicano che la distribuzione della mobilità **non è una gaussiana simmetrica**, ma una distribuzione asimmetrica a coda pesante (log-normale o Gamma).
  * Sul Q-Q plot i punti estremi schizzano verso l'alto rispetto alla retta teorica a 45 gradi: il grafico assume la forma a bastone da hockey, segnalando che l'OLS classico su scala lineare distorce le stime.

### C. Scale-Location (Verifica di Omoschedasticità)
* **Obiettivo:** Controllare che la varianza dell'errore $\sigma^2$ sia costante lungo tutti i valori predetti.
* **Pratico:** L'incertezza del modello deve essere identica per valori piccoli e per valori grandi di $Y$. Se l'incertezza esplode a imbuto (eteroschedasticità), gli errori standard OLS convenzionali diventano inattendibili.
* **Esito nel nostro modello:** Ampiezza della nuvola costante lungo l'asse orizzontale: omoschedasticità verificata.

### D. Residuals vs Leverage (Fisica dell'Altalena e Distanza di Cook)
* **Leva (Leverage, $h_{ii}$):** Misura quanto un'osservazione è isolata ed estrema nello spazio dei predittori $X$ rispetto al baricentro campionario (il fulcro dell'altalena).
* **Residuo Standardizzato:** Misura l'errore verticale del modello su quell'individuo (distanza verticale dalla retta).
* **Distanza di Cook ($D_i$):** È il prodotto tra leva e residuo. Quantifica quanto quell'unica osservazione, da sola, sposta tutti i coefficienti della retta di regressione:
  * Un punto con leva alta ma residuo zero sta già sulla retta: non la sposta.
  * Un punto con residuo alto ma leva bassa sta vicino al baricentro: sposta l'intercetta di poco, non la pendenza.
  * Un punto con **leva alta E residuo alto** agisce come una forza al braccio estremo della leva: ruota l'intera retta verso di sé.
* **Esito nel nostro modello:** Nessun punto supera la linea critica di Cook ($D_i > 0{,}5$). Nessuna singola osservazione controlla arbitrariamente le stime.
