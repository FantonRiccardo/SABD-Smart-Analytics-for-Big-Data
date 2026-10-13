# ==============================================================================
# SMART ANALYTICS FOR BIG DATA (SABD) — LESSON 04
# Multiple Regression: BigMart Inventory Management
# Docente: Prof. Iragaël Joly
# Script pulito per esecuzione diretta in RStudio (senza artefatti Rmd / HTML)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. SETUP & PACCHETTI
# ------------------------------------------------------------------------------

library(tidyverse)
library(corrplot)

# ------------------------------------------------------------------------------
# 2. CARICAMENTO DATI & DIZIONARIO VARIABILI
# ------------------------------------------------------------------------------

# Dizionario delle 12 variabili originali del dataset BigMart:
# - Item_Identifier:          Codice identificativo univoco del prodotto (es. FDA15)
# - Item_Weight:              Peso della singola confezione
# - Item_Fat_Content:         Contenuto di grassi dell'alimento (Low Fat vs Regular)
# - Item_Visibility:          Quota percentuale della superficie espositiva a scaffale
# - Item_Type:                Categoria merceologica originaria (16 categorie)
# - Item_MRP:                 Maximum Retail Price (Prezzo massimo di listino al dettaglio)
# - Outlet_Identifier:        Codice identificativo univoco del punto vendita (10 negozi)
# - Outlet_Establishment_Year: Anno di apertura del negozio (1985-2009)
# - Outlet_Size:              Dimensione del negozio per superficie (Small, Medium, High)
# - Outlet_Location_Type:     Tipologia di città (Tier 1 metropoli, Tier 2 media, Tier 3 piccola)
# - Outlet_Type:              Formato del negozio (Grocery Store, Supermarket Type 1/2/3)
# - Item_Outlet_Sales:        VARIABILE TARGET Y: Fatturato totale del prodotto nel negozio
#
# Variabili create nel codice (Feature Engineering):
# - Item_Type2:               Macro-categoria ridotta a 3 livelli (Drink, Food, Non Consommable)
# - Item_Weight2:             Peso con valori mancanti (17.2% NA) imputati con la media di Item_Type2

# Risoluzione automatica del percorso (funziona da qualsiasi working directory)
csv_file <- "bigmart_data.csv"
if (!file.exists(csv_file)) {
  candidates <- c(
    "lectures/lesson_04/Exercise_Regression/bigmart_data.csv",
    "Exercise_Regression/bigmart_data.csv",
    file.path("..", "Exercise_Regression", "bigmart_data.csv"),
    file.path(getwd(), "Exercise_Regression", "bigmart_data.csv")
  )
  found <- candidates[file.exists(candidates)]
  if (length(found) > 0) csv_file <- found[1]
}

DF <- read.csv(file = csv_file, sep = ",", dec = ".")

# Dimensioni del dataset
dim(DF)
str(DF)

# Distribuzione iniziale della variabile target (Vendite)
hist(DF$Item_Outlet_Sales, breaks = 40, col = "skyblue", main = "Distribuzione Vendite", xlab = "Sales")

# Conteggio identificatori unici
cat("Prodotti unici:", length(unique(DF$Item_Identifier)), "\n")
cat("Negozi unici:   ", length(unique(DF$Outlet_Identifier)), "\n")

# ------------------------------------------------------------------------------
# 3. PULIZIA DATI, RICODIFICA & IMPUTAZIONE DEI VALORI MANCANTI
# ------------------------------------------------------------------------------

# Tasso di valori mancanti (NA) per colonna
na_rate <- sapply(DF, function(col) sum(is.na(col)) / length(col))
print(round(na_rate, 4))

# Correzione typo nella variabile Item_Fat_Content
table(DF$Item_Fat_Content)
DF <- DF %>%
  mutate(Item_Fat_Content = case_when(
    Item_Fat_Content %in% c("LF", "low fat", "Low Fat") ~ "Low Fat",
    Item_Fat_Content %in% c("reg", "Regular")           ~ "Regular"
  ))
table(DF$Item_Fat_Content)

# Riduzione delle 16 categorie di Item_Type a 3 macro-categorie (Drink, Food, Non-Consumable)
# basate sui prefissi dell'ID: DR, FD, NC
DF <- DF %>%
  mutate(Item_Type2 = case_when(
    str_detect(Item_Identifier, "DR") ~ "Drink",
    str_detect(Item_Identifier, "FD") ~ "Food",
    str_detect(Item_Identifier, "NC") ~ "Non Consommable"
  ))
table(DF$Item_Type, DF$Item_Type2)

# Imputazione di Item_Weight: sostituzione degli NA con la media del rispettivo Item_Type2
DF <- DF %>%
  group_by(Item_Type2) %>%
  mutate(Av_weight = mean(Item_Weight, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(Item_Weight2 = ifelse(is.na(Item_Weight), Av_weight, Item_Weight))

# Verifica assenza NA su Item_Weight2
sum(is.na(DF$Item_Weight2))

# ------------------------------------------------------------------------------
# 4. FORMATTAZIONE DELLE VARIABILI CATEGORIALI (FACTORS)
# ------------------------------------------------------------------------------

DF$Item_Type2                <- factor(DF$Item_Type2)
DF$Item_Fat_Content          <- factor(DF$Item_Fat_Content)
DF$Outlet_Establishment_Year <- factor(DF$Outlet_Establishment_Year)
DF$Outlet_Size               <- factor(DF$Outlet_Size)
DF$Outlet_Location_Type      <- factor(DF$Outlet_Location_Type)
DF$Outlet_Type               <- factor(DF$Outlet_Type)

# ------------------------------------------------------------------------------
# 5. REGRESSIONE SEMPLICE (Reg1: Prezzo vs Vendite) & DIAGNOSTICA
# ------------------------------------------------------------------------------

# Matrice di correlazione per le sole variabili numeriche
num_cols <- DF %>%
  select(where(is.numeric), -Item_Weight, -Av_weight)
my_cor <- cor(num_cols, use = "complete.obs")
corrplot(my_cor, method = "circle")

# Stima del modello semplice: Item_Outlet_Sales ~ Item_MRP
Reg1 <- lm(Item_Outlet_Sales ~ Item_MRP, data = DF)
summary(Reg1)

# Scatter plot con retta di regressione
ggplot(DF, aes(x = Item_MRP, y = Item_Outlet_Sales)) +
  geom_point(color = "grey60", alpha = 0.4) +
  geom_smooth(method = "lm", color = "red") +
  theme_minimal() +
  labs(title = "Reg1: Item Outlet Sales vs Item MRP", x = "Prezzo di Listino (MRP)", y = "Vendite Totali")

# Diagnostica dei 4 grafici residui
par(mfrow = c(2, 2))
plot(Reg1)
par(mfrow = c(1, 1))

# ------------------------------------------------------------------------------
# 6. REGRESSIONE MULTIPLA QUANTITATIVA (Reg2: Prezzo, Visibilità, Peso)
# ------------------------------------------------------------------------------

# Verifica congiunta dei predittori continui
Reg2 <- lm(Item_Outlet_Sales ~ Item_MRP + Item_Visibility + Item_Weight2, data = DF)
summary(Reg2)

# Nota didattica sul coefficiente negativo di Item_Visibility:
# Non indica che mostrare un prodotto riduca le vendite, ma un bias di selezione
# (i prodotti a bassa rotazione vengono esposti di più per smaltirli).

# ------------------------------------------------------------------------------
# 7. CARATTERISTICHE DEL PUNTO VENDITA (Reg3: Singolarità e Multicollinearità)
# ------------------------------------------------------------------------------

# Tabella incrociata dimensione vs tipologia negozio
table(DF$Outlet_Size, DF$Outlet_Type)

# Stima con attributi del negozio:
Reg3 <- lm(Item_Outlet_Sales ~ Outlet_Establishment_Year + Outlet_Size + Outlet_Type, data = DF)
summary(Reg3)

# Nota didattica sugli NA nei coefficienti (Singularities):
# I 10 negozi hanno attributi fissi sovrapposti. La matrice X'X perde rango pieno
# per collinearità perfetta e R rimuove automaticamente i coefficienti ridondanti.

# ------------------------------------------------------------------------------
# 8. INTERAZIONI PRODOTTO-PREZZO (Reg4: MRP * Item_Type2)
# ------------------------------------------------------------------------------

# Effetto di interazione: la reattività al prezzo dipende dalla categoria merceologica?
Reg4 <- lm(Item_Outlet_Sales ~ Item_MRP * Item_Type2, data = DF)
summary(Reg4)

# Modello additivo senza interazione per confronto
Reg4_add <- lm(Item_Outlet_Sales ~ Item_MRP + Item_Type2, data = DF)

# Test F di Fisher per modelli annidati
anova(Reg4_add, Reg4)

# Nota didattica sul test ANOVA:
# I p-value dell'interazione sono elevati (non significativi al 5%).
# A differenza della simulazione sim3, qui l'interazione non è necessaria.

# ------------------------------------------------------------------------------
# 9. PREVISIONE & INTERVALLI (Confidence vs Prediction)
# ------------------------------------------------------------------------------

# Previsione per valori medi e mediani di MRP
new_points <- data.frame(Item_MRP = c(mean(DF$Item_MRP), median(DF$Item_MRP)))
predict(Reg1, newdata = new_points)

# Differenza formale tra intervallo di confidenza (media) e intervallo di predizione (singolo punto)
predict(Reg1, newdata = new_points, interval = "confidence")
predict(Reg1, newdata = new_points, interval = "prediction")

# Generazione della griglia di previsione lungo tutto il dominio di MRP
grid_mrp <- data.frame(Item_MRP = seq(min(DF$Item_MRP), max(DF$Item_MRP), length.out = 100))
pred_grid <- as.data.frame(predict(Reg1, newdata = grid_mrp, interval = "prediction"))
pred_grid$Item_MRP <- grid_mrp$Item_MRP

# ------------------------------------------------------------------------------
# 10. VISUALIZZAZIONE DELLE PREVISIONI PER MACRO-CATEGORIA
# ------------------------------------------------------------------------------

ggplot(DF, aes(x = Item_MRP, y = Item_Outlet_Sales)) +
  geom_point(alpha = 0.25, color = "grey50") +
  geom_line(data = pred_grid, aes(x = Item_MRP, y = fit), color = "red", linewidth = 1) +
  geom_line(data = pred_grid, aes(x = Item_MRP, y = lwr), color = "blue", linetype = "dashed") +
  geom_line(data = pred_grid, aes(x = Item_MRP, y = upr), color = "blue", linetype = "dashed") +
  facet_wrap(~ Item_Type2) +
  theme_minimal() +
  labs(
    title = "Previsione OLS e Intervalli di Predizione (95%)",
    x = "Prezzo di Listino (Item_MRP)",
    y = "Vendite Negozio (Item_Outlet_Sales)"
  )
