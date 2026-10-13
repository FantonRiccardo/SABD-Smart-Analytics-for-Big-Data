# ==============================================================================
# SABD - Lesson 02: Industrial Air Quality Data Handling & Quality Diagnostic
# ==============================================================================

# 1. Caricamento librerie essenziali
library(tidyverse)  # Include dplyr, ggplot2, lubridate

# Ingestione dataset esterno (EXT)
df_raw <- read.csv("EXT.csv", sep = ";", stringsAsFactors = FALSE)

# ==============================================================================
# 2. Parsing Temporale (Trasformare stringa in Data-Ora)
# ==============================================================================
df_clean <- df_raw %>% 
  mutate(Time = as.POSIXct(Time, format = "%Y-%m-%d %H:%M:%S"))

# ==============================================================================
# 3. Data Quality Diagnostic (I Pilastri delle slide del Prof. Joly)
# ==============================================================================
# Pilastro 1: Completeness (Missing values)
colSums(is.na(df_clean))

# Pilastro 6: Validity & Range Check
summary(df_clean %>% select(temperature, humidity, co2, pm2p5))

# ==============================================================================
# Visual A: Distribuzione Dimensionale del Particolato (Boxplot Logaritmico)
# ==============================================================================

# Trasformiamo le 4 colonne PM in formato Long per ggplot
p_boxplot <- df_clean %>% 
  sample_n(10000) %>% 
  select(pm1p0, pm2p5, pm4p0, pm10p0) %>% 
  pivot_longer(cols = everything(), names_to = "Particle_Type", values_to = "Concentration") %>% 
  ggplot(aes(x = Particle_Type, y = Concentration, fill = Particle_Type)) +
  geom_boxplot(outlier.alpha = 0.1, show.legend = FALSE) +
  scale_y_log10() + # Scala logaritmica perché il particolato ha picchi estremi
  labs(
    title = "Distribuzione Concentrazione Particolato (Sensori Esterni)",
    subtitle = "Confronto PM1.0, PM2.5, PM4.0, PM10.0 (Scala Logaritmica)",
    x = "Dimensione Particella",
    y = "Concentrazione (ug/m3 - log10)"
  ) +
  theme_minimal()

print(p_boxplot)


# ==============================================================================
# 4. Feature Engineering & Target Definition per Machine Learning
# ==============================================================================
df_featured <- df_clean %>% 
  mutate(
    hour = lubridate::hour(Time),
    is_alert = if_else(pm2p5 > 50 | co2 > 1000, 1, 0),
    air_quality = case_when(
      pm2p5 <= 25 ~ "1_Excellent",
      pm2p5 <= 50 ~ "2_Bon",
      pm2p5 <= 75 ~ "3_Moyen",
      pm2p5 <= 100 ~ "4_Degrade",
      TRUE        ~ "5_Mauvais_Critique"
    )
  )

# ==============================================================================
# 5. Aggregazione Descrittiva (Group By + Summarise)
# ==============================================================================
hourly_summary <- df_featured %>% 
  group_by(hour) %>% 
  summarise(
    mean_pm2p5   = mean(pm2p5),
    mean_co2     = mean(co2),
    alert_rate   = mean(is_alert) * 100,
    n_samples    = n()
  )

# --- VISUAL B: Profilo Orario del Rischio Inquinamento ---
p_hourly <- ggplot(hourly_summary, aes(x = hour, y = alert_rate)) +
  geom_line(color = "steelblue", linewidth = 1.2) +
  geom_point(color = "darkred", size = 2.5) +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Profilo Orario Rischio Qualità Aria nel Fablab (S.mart)",
    subtitle = "% di minuti con PM2.5 > 50 ug/m3 o CO2 > 1000 ppm per ora del giorno",
    x = "Ora del Giorno (0 - 23)",
    y = "% Minuti in Allerta"
  ) +
  theme_minimal()

print(p_hourly)

# ==============================================================================
# 6. Scompattamento & Ingestione Sensori Interni (INT)
# ==============================================================================
if (!file.exists("INT.csv")) {
  unzip("INT.zip")
}
df_int_raw <- read.csv("INT.csv", sep = ";", stringsAsFactors = FALSE)

df_int_clean <- df_int_raw %>% 
  mutate(Time = as.POSIXct(Time, format = "%Y-%m-%d %H:%M:%S"))

# Risoluzione Duplicati Temporali (Pilastro 5: Uniqueness)
df_clean_unique <- df_clean %>% distinct(Time, .keep_all = TRUE)
df_int_unique   <- df_int_clean %>% distinct(Time, .keep_all = TRUE)

# Join Relazionale
df_merged <- inner_join(df_clean_unique, df_int_unique, by = "Time", suffix = c("_ext", "_int"))

# ==============================================================================
# 7. Analisi Efficienza Filtri & Confronto INT vs EXT
# ==============================================================================
df_analysis <- df_merged %>% 
  mutate(
    pm2p5_diff = pm2p5_int - pm2p5_ext,
    filter_efficiency = if_else(
      pm2p5_int > 5, 
      ((pm2p5_int - pm2p5_ext) / pm2p5_int) * 100, 
      NA_real_
    )
  )

# --- VISUAL C: Evoluzione Temporale Efficienza Filtro ---
weekly_filter <- df_analysis %>% 
  filter(!is.na(filter_efficiency), filter_efficiency > -50, filter_efficiency <= 100) %>% 
  mutate(week = lubridate::floor_date(Time, unit = "week")) %>% 
  group_by(week) %>% 
  summarise(
    median_efficiency = median(filter_efficiency),
    p25 = quantile(filter_efficiency, 0.25),
    p75 = quantile(filter_efficiency, 0.75)
  )

p_filter_trend <- ggplot(weekly_filter, aes(x = week, y = median_efficiency)) +
  geom_ribbon(aes(ymin = p25, ymax = p75), fill = "skyblue", alpha = 0.4) +
  geom_line(color = "navy", linewidth = 1) +
  geom_point(color = "navy", size = 2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Evoluzione Temporale dell'Efficienza di Filtraggio (PM2.5)",
    subtitle = "Mediana settimanale e banda interquartile (25%-75%)",
    x = "Data (Settimana)",
    y = "Efficienza Filtro (%)"
  ) +
  theme_minimal()

print(p_filter_trend)

# ==============================================================================
# 8. Time Series Feature Engineering con lag()
# ==============================================================================
df_ts <- df_analysis %>% 
  arrange(Time) %>% 
  mutate(
    delta_pm_int = pm2p5_int - lag(pm2p5_int, 1),
    delta_voxr_int = voxr_int - lag(voxr_int, 1),
    is_printer_spike = if_else(delta_pm_int > 20, 1, 0, missing = 0)
  )

# --- VISUAL D: Firma Chimica dell'Avvio Stampante nello Spazio CO2 vs VOC ---
set.seed(42)
df_sample_viz <- df_ts %>% sample_n(10000)

p_emissions <- ggplot(df_sample_viz, aes(x = co2_int, y = voxr_int)) +
  geom_point(aes(color = as.factor(is_printer_spike), alpha = as.factor(is_printer_spike)), size = 1.8) +
  scale_color_manual(
    values = c("0" = "gray70", "1" = "firebrick"),
    labels = c("0" = "Normale / Standby", "1" = "Picco Stampante (Spike)")
  ) +
  scale_alpha_manual(values = c("0" = 0.2, "1" = 0.9), guide = "none") +
  labs(
    title = "Firma Chimica dell'Avvio Stampante 3D",
    subtitle = "Isolamento dei picchi nello spazio CO2 vs Composti Volatili (VOC)",
    x = "Livello CO2 Interno (ppm)",
    y = "Livello Composti Volatili VOC (raw voxr)",
    color = "Stato Operativo"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_emissions)

# ==============================================================================
# Visual B: Trend Temporale Efficienza Filtri (Serie Storica Aggregata)
# ==============================================================================

# Calcoliamo la mediana settimanale dell'efficienza dei filtri
weekly_filter <- df_analysis %>% 
  filter(!is.na(filter_efficiency), filter_efficiency > -50, filter_efficiency <= 100) %>% 
  mutate(week = lubridate::floor_date(Time, unit = "week")) %>% 
  group_by(week) %>% 
  summarise(
    median_efficiency = median(filter_efficiency),
    p25 = quantile(filter_efficiency, 0.25),
    p75 = quantile(filter_efficiency, 0.75)
  )

p_filter_trend <- ggplot(weekly_filter, aes(x = week, y = median_efficiency)) +
  geom_ribbon(aes(ymin = p25, ymax = p75), fill = "skyblue", alpha = 0.4) + # Banda interquartile
  geom_line(color = "navy", linewidth = 1) +
  geom_point(color = "navy", size = 2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Evoluzione Temporale dell'Efficienza di Filtraggio (PM2.5)",
    subtitle = "Mediana settimanale e intervallo interquartile (25%-75%)",
    x = "Data (Settimana)",
    y = "Efficienza Filtro (%)"
  ) +
  theme_minimal()

print(p_filter_trend)


# ==============================================================================
# 9. Machine Learning: Confronto Metodologico tra Split
# ==============================================================================
cutoff_date <- as.POSIXct("2025-01-01 00:00:00")

df_train_time <- df_ts %>% filter(Time < cutoff_date)
df_test_time  <- df_ts %>% filter(Time >= cutoff_date)

model_time <- glm(
  is_printer_spike ~ temperature_int + humidity_int + co2_int + voxr_int,
  data = df_train_time,
  family = binomial
)

df_test_time <- df_test_time %>% 
  mutate(
    pred_prob  = predict(model_time, newdata = df_test_time, type = "response"),
    pred_class = if_else(pred_prob > 0.01, 1, 0)
  )

conf_matrix_time <- table(
  Reale    = df_test_time$is_printer_spike, 
  Predetto = df_test_time$pred_class
)

print(conf_matrix_time)