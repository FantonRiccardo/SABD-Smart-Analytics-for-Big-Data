# R Graphics Cookbook: Practical Recipes for Visualizing Data — Winston Chang

> **Autore**: Winston Chang (RStudio / Posit)  
> **Editore**: O'Reilly Media  
> **ISBN**: 978-1-449-31695-2  
> **Riferimento corso**: *Smart Analytics for Big Data (SABD) — Grenoble INP*  

---

## Panoramica dell'Opera

*R Graphics Cookbook* è il manuale pratico definitivo per la visualizzazione dati in R tramite **`ggplot2`** e il framework della *Grammar of Graphics* (Leland Wilkinson / Hadley Wickham). Fornisce oltre 150 ricette strutturate per risolvere problemi specifici: dalla creazione di grafici esplorativi rapidi alla composizione di figure complesse per paper, report accademici e dashboard.

---

## Architettura Fondamentale di ggplot2 (Grammar of Graphics)

Ogni grafico `ggplot2` si compone di livelli (*layers*) combinati tramite l'operatore `+`:
1. **Data**: il data frame (rigorosamente in formato *tidy* / long).
2. **Aesthetic Mappings (`aes`)**: associazioni tra variabili del dataset e proprietà visive (`x`, `y`, `colour`, `fill`, `shape`, `size`, `alpha`, `linetype`, `group`).
3. **Geometric Objects (`geom_*`)**: la rappresentazione grafica effettiva (punti, barre, linee, box plot, poligoni).
4. **Statistical Transformations (`stat_*`)**: calcoli statistici intermedi (conteggi bin, stime di densità, regressioni lineari/LOESS).
5. **Scales (`scale_*`)**: controllo della mappatura tra dati e spazio visivo (assi continui/discreti, palette cromatiche, range di dimensioni).
6. **Faceting (`facet_*`)**: suddivisione del grafico in sottomatrici condizionali per variabili categoriche.
7. **Coordinate Systems (`coord_*`)**: sistemi di coordinate cartesiane, invertite (`coord_flip`), polari o geografiche.
8. **Theme (`theme`)**: styling non legato ai dati (font, griglie, assi, posizionamento delle legende).

---

## Compendio delle Ricette per Tipologia di Grafico

### 1. Grafici a Barre (Bar Graphs — Capitolo 3)

```r
library(ggplot2)

# 1.1 Barra di valori (stat = "identity")
ggplot(df, aes(x = factor(category), y = value)) +
  geom_bar(stat = "identity", fill = "steelblue", colour = "black")

# 1.2 Barre raggruppate (Dodged)
ggplot(df, aes(x = group, y = value, fill = subgroup)) +
  geom_bar(stat = "identity", position = position_dodge(0.9), colour = "black") +
  scale_fill_brewer(palette = "Pastel1")

# 1.3 Barre conteggio casi (stat = "bin" / default)
ggplot(diamonds, aes(x = cut)) +
  geom_bar(fill = "grey70", colour = "black")

# 1.4 Barre impilate al 100% (Proportional Stacked Bar)
library(dplyr)
df_prop <- df %>%
  group_by(group) %>%
  mutate(pct = value / sum(value) * 100)

ggplot(df_prop, aes(x = group, y = pct, fill = subgroup)) +
  geom_bar(stat = "identity", colour = "black") +
  guides(fill = guide_legend(reverse = TRUE))

# 1.5 Cleveland Dot Plot (alternativa pulita alle barre)
ggplot(df, aes(x = value, y = reorder(item, value))) +
  geom_point(size = 3, colour = "navy") +
  theme_bw() +
  theme(panel.grid.major.y = element_line(linetype = "dashed", colour = "grey70"),
        panel.grid.major.x = element_blank())
```

---

### 2. Grafici Lineari e Serie Storiche (Line Graphs — Capitolo 4)

```r
# 2.1 Linea base con punti
ggplot(df, aes(x = time, y = response)) +
  geom_line(colour = "darkred", size = 1) +
  geom_point(size = 2.5, shape = 21, fill = "white")

# 2.2 Linee multiple per gruppo (con raggruppamento esplicito)
ggplot(df, aes(x = time, y = response, colour = group, linetype = group)) +
  geom_line(size = 0.8) +
  geom_point(size = 2, position = position_dodge(0.2)) +
  scale_colour_brewer(palette = "Set1")

# 2.3 Banda di confidenza / Shaded Ribbon
ggplot(df, aes(x = year, y = estimate)) +
  geom_ribbon(aes(ymin = estimate - se, ymax = estimate + se), alpha = 0.2, fill = "blue") +
  geom_line(colour = "blue", size = 1)

# 2.4 Stacked Area Graph
ggplot(df, aes(x = year, y = value, fill = category)) +
  geom_area(colour = "black", size = 0.2, alpha = 0.6) +
  scale_fill_brewer(palette = "Blues")
```

---

### 3. Scatter Plot e Modelli di Regressione (Capitolo 5)

```r
# 3.1 Scatter plot con modello lineare e banda di confidenza
ggplot(df, aes(x = x_var, y = y_var)) +
  geom_point(alpha = 0.5, size = 2) +
  stat_smooth(method = "lm", level = 0.95, colour = "red", fill = "pink")

# 3.2 Scatter plot con curva LOESS (non parametrica)
ggplot(df, aes(x = x_var, y = y_var, colour = group)) +
  geom_point(alpha = 0.6) +
  stat_smooth(method = "loess", se = FALSE)

# 3.3 Gestione overplotting: Hexbin o 2D Binning
library(hexbin)
ggplot(large_df, aes(x = x, y = y)) +
  stat_binhex(bins = 50) +
  scale_fill_gradient(low = "lightblue", high = "red")

# 3.4 Jittering per variabili discrete
ggplot(df, aes(x = factor(dose), y = score)) +
  geom_point(position = position_jitter(width = 0.2, height = 0), alpha = 0.4)

# 3.5 Balloon Plot (area proporzionale al valore)
ggplot(df, aes(x = var1, y = var2, size = count)) +
  geom_point(shape = 21, fill = "cornsilk", colour = "black") +
  scale_size_area(max_size = 15)
```

---

### 4. Distribuzioni Statistiche (Capitolo 6)

```r
# 4.1 Istogramma con densità sovrapposta
ggplot(df, aes(x = value, y = ..density..)) +
  geom_histogram(binwidth = 2, fill = "cornsilk", colour = "grey60") +
  geom_density(colour = "darkblue", size = 1)

# 4.2 Multiple Density Curves per gruppo
ggplot(df, aes(x = value, fill = group)) +
  geom_density(alpha = 0.3) +
  scale_fill_brewer(palette = "Set1")

# 4.3 Box Plot con tacche di confidenza (Notches) e punto della media
ggplot(df, aes(x = group, y = value)) +
  geom_boxplot(notch = TRUE, fill = "lightblue", outlier.size = 1.5) +
  stat_summary(fun = mean, geom = "point", shape = 23, size = 3, fill = "white")

# 4.4 Violin Plot combinato con Box Plot
ggplot(df, aes(x = group, y = value)) +
  geom_violin(trim = FALSE, fill = "grey90", colour = "grey40") +
  geom_boxplot(width = 0.1, fill = "black", outlier.colour = NA) +
  stat_summary(fun = median, geom = "point", fill = "white", shape = 21, size = 2.5)

# 4.5 2D Density Plot (Curve di livello / Raster)
ggplot(faithful, aes(x = eruptions, y = waiting)) +
  stat_density2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
  geom_point(colour = "white", alpha = 0.3, size = 1) +
  scale_fill_gradient(low = "black", high = "yellow")
```

---

### 5. Annotazioni, Etichette e Formule Matematiche (Capitolo 7)

```r
# 5.1 Annotazione testo con coordinate fisse o agli estremi
p + annotate("text", x = 15, y = 50, label = "Soglia critica", colour = "red", fontface = "bold") +
    annotate("text", x = Inf, y = -Inf, label = "Fonte: Dati 2026", hjust = 1.1, vjust = -0.5)

# 5.2 Formule matematiche LaTeX-style (parse = TRUE)
p + annotate("text", x = 2, y = 0.3, parse = TRUE,
             label = "frac(1, sqrt(2 * pi)) * e^{-x^2 / 2}")

# 5.3 Linee di riferimento orizzontali/verticali/oblique
p + geom_hline(yintercept = 100, linetype = "dashed", colour = "red") +
    geom_vline(xintercept = 2020, linetype = "dotted") +
    geom_abline(intercept = 0, slope = 1)

# 5.4 Segmenti e frecce direzionali
library(grid)
p + annotate("segment", x = 10, xend = 20, y = 5, yend = 15,
             arrow = arrow(length = unit(0.3, "cm")), colour = "darkblue", size = 1)

# 5.5 Barre di errore su grafici a barre dodged
ggplot(df, aes(x = group, y = mean_val, fill = subgroup)) +
  geom_bar(stat = "identity", position = position_dodge(0.9)) +
  geom_errorbar(aes(ymin = mean_val - se, ymax = mean_val + se),
                position = position_dodge(0.9), width = 0.2)
```

---

### 6. Controllo Assi, Temi e Legende (Capitoli 8–10)

```r
# 6.1 Assi: range, inversione e scala logaritmica
p + scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 20)) +
    scale_x_log10(breaks = c(1, 10, 100, 1000)) +
    coord_flip() # Inverte assi X e Y

# 6.2 Gestione Legende
p + theme(legend.position = c(0.85, 0.2), # All'interno del plot (x, y) normalizzati
          legend.background = element_rect(fill = "white", colour = "grey80"),
          legend.title = element_text(size = 10, face = "bold")) +
    guides(colour = guide_legend(title = "Condizione", reverse = TRUE))

# 6.3 Temi professionali e personalizzazione
p + theme_bw() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      axis.title = element_text(size = 11, face = "bold"),
      axis.text = element_text(size = 10),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank()
    )
```

---

### 7. Faceting & Sotto-grafici (Capitolo 11)

```r
# 7.1 Griglia bidimensionale (Righe ~ Colonne)
p + facet_grid(sex ~ race)

# 7.2 Griglia monodimensionale con a-capo automatico
p + facet_wrap(~ category, ncol = 3, scales = "free_y")
# scales = "free_y" permette assi Y indipendenti per facet
```

---

### 8. Gestione Palette Cromatiche (Capitolo 12)

| Tipologia Scala | Funzione ggplot2 | Palette / Esempi |
|---|---|---|
| **Discreta (Categorica)** | `scale_fill_brewer(palette = "Set1")` | `Set1`, `Set2`, `Pastel1`, `Dark2` (ColorBrewer) |
| **Discreta Manuale** | `scale_fill_manual(values = c("#E69F00", "#56B4E9", "#009E73"))` | Palette Okabe-Ito (Colorblind safe) |
| **Continua (Gradiente a 2 colori)** | `scale_fill_gradient(low = "white", high = "darkred")` | Sfumatura lineare |
| **Continua (Divergente a 3 colori)** | `scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0)` | Centrata sullo zero / anomalie |
| **Continua Multi-stop** | `scale_fill_gradientn(colours = terrain.colors(10))` | Viridis, Magma, Plasma, Inferno |

---

### 9. Export per Pubblicazioni e Report (Capitolo 14)

```r
# Salvataggio grafico vettoriale ad alta risoluzione (PDF / SVG)
ggsave("plot_output.pdf", width = 8, height = 6, units = "in")

# Salvataggio bitmap a 300 DPI per presentazioni/stampe
ggsave("plot_output.png", width = 2400, height = 1800, units = "px", dpi = 300)
```

---

### 10. Data Shaping Essenziale per ggplot2 (Capitolo 15)

`ggplot2` richiede dati in formato **Long / Tidy** (ogni riga un'osservazione, ogni colonna una variabile/estetica):

```r
library(tidyr)
library(dplyr)

# Conversione da Wide a Long
df_long <- df_wide %>%
  pivot_longer(cols = c(year2020, year2021, year2022),
               names_to = "year",
               values_to = "revenue")

# Conversione da Long a Wide
df_wide <- df_long %>%
  pivot_wider(names_from = year, values_from = revenue)

# Riordino dei livelli di un fattore in base ai valori (fondamentale per grafici puliti)
df$category <- reorder(df$category, df$value, FUN = median)
```
