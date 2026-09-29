# ==============================================================================
# Smart Analytics for Big Data (SABD) — Complete Package Installation Script
# ==============================================================================

# 1. Definizione lista pacchetti standard e avanzati
pkgs <- c(
  # RMarkdown, Formatting & Output
  "knitr", "tinytex", "prettydoc", "kableExtra", "rmarkdown", 
  "stargazer", "rmdformats", "formatR", "skimr", "ggpubr",
  
  # Data Handling & Core Analytics
  "tidyverse", "reshape2", "mongolite",
  
  # Data & Datasets
  "Ecdat", "MASS", "HSAUR3",
  
  # Advanced Graphics
  "ggplot2", "gcookbook", "RColorBrewer",
  
  # Econometrics, DCM & Statistical Models
  "lmtest", "gmodels", "VGAM", "mlogit", "gmnl",
  
  # Spatial Analytics & Cartography
  "sp", "cartography", "dismo"
)

# 2. Installazione pacchetti mancanti
new_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
if (length(new_pkgs) > 0) {
  message("Installazione di ", length(new_pkgs), " pacchetti in corso...")
  install.packages(new_pkgs, dependencies = TRUE)
} else {
  message("Tutti i pacchetti principali sono già installati!")
}

# 3. Setup TinyTeX (motore LaTeX per generare PDF da RMarkdown)
if (!tinytex::is_tinytex()) {
  message("Installazione TinyTeX per la compilazione PDF...")
  tinytex::install_tinytex()
}

# 4. Nota su librerie spaziali legacy (rgdal e maptools)
# Nota: 'rgdal' e 'maptools' sono state ritirate da CRAN a fine 2023.
# I loro sostituti moderni nello standard R sono 'sf' e 'terra'.
legacy_spatial <- c("sf", "terra")
new_spatial <- legacy_spatial[!(legacy_spatial %in% installed.packages()[, "Package"])]
if (length(new_spatial) > 0) {
  install.packages(new_spatial, dependencies = TRUE)
}

message("\n>>> Setup dell'ambiente SABD completato con successo! <<<")
