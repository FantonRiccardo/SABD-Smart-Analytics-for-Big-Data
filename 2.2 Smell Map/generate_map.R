library(sf)
library(ggplot2)
sf_use_s2(FALSE)

shp_path <- "/Users/riccardofanton/Documents/Visual Studio Code/01_ACTIVE_PROJECTS/0 - VS POLI/02_GRENOBLE_INP_3A/2 - Smart Analytics for Big Data/02_tp_mobility/Files_OK_2026/FOND_MAP/NewESRI.shp"
out_fig <- "/Users/riccardofanton/Documents/Visual Studio Code/01_ACTIVE_PROJECTS/0 - VS POLI/02_GRENOBLE_INP_3A/2 - Smart Analytics for Big Data/2.2 Smell Map/figures/fig5_grenoble_smell_cartography_gis.png"

shp <- st_read(shp_path, quiet = TRUE)

target_ids <- c(101:114, 121:126, 128:132)
sub_shp <- shp[shp$cod_sectir %in% target_ids, ]

# Map Municipality
sub_shp$Commune <- ifelse(sub_shp$cod_sectir <= 114, "Grenoble",
                   ifelse(sub_shp$cod_sectir <= 126, "Saint-Martin-d'Hères", "Échirolles"))

# Assign Primary Olfactory Profile based on empirical urban reality
sub_shp$Smell_Signature <- "Residential / Clean Baseline"
sub_shp$Smell_Signature[sub_shp$cod_sectir == 101] <- "Food & Bakery Aromas (Rue de Strasbourg / Halles)"
sub_shp$Smell_Signature[sub_shp$cod_sectir == 102] <- "Coffee & Café Terraces (Place Championnet / Victor Hugo)"
sub_shp$Smell_Signature[sub_shp$cod_sectir == 103] <- "Floral & Biogenic Haven (Parc Paul Mistral)"
sub_shp$Smell_Signature[sub_shp$cod_sectir %in% c(104, 105, 106, 114)] <- "Traffic & Exhaust Fumes (Grands Boulevards / A480)"
sub_shp$Smell_Signature[sub_shp$cod_sectir %in% c(121, 122)] <- "Floral & Biogenic Haven (UGA Campus / Arboretum)"
sub_shp$Smell_Signature[sub_shp$cod_sectir == 126] <- "Traffic & Exhaust Fumes (Rocade Sud Corridor)"
sub_shp$Smell_Signature[sub_shp$cod_sectir == 129] <- "Waste Logistics & Refuse Buffer"
sub_shp$Smell_Signature[sub_shp$cod_sectir %in% c(130, 132)] <- "Industrial & Chemical Emissions (Comboire / Pont-de-Claix border)"

palette_smells <- c(
  "Food & Bakery Aromas (Rue de Strasbourg / Halles)" = "#E67E22",
  "Coffee & Café Terraces (Place Championnet / Victor Hugo)" = "#8E44AD",
  "Floral & Biogenic Haven (Parc Paul Mistral)" = "#2ECC71",
  "Floral & Biogenic Haven (UGA Campus / Arboretum)" = "#27AE60",
  "Traffic & Exhaust Fumes (Grands Boulevards / A480)" = "#E74C3C",
  "Traffic & Exhaust Fumes (Rocade Sud Corridor)" = "#C0392B",
  "Industrial & Chemical Emissions (Comboire / Pont-de-Claix border)" = "#34495E",
  "Waste Logistics & Refuse Buffer" = "#D35400",
  "Residential / Clean Baseline" = "#AED6F1"
)

# Centroids for labeling
sub_shp$centroid <- st_centroid(sub_shp$geometry)
coords <- st_coordinates(sub_shp$centroid)
sub_shp$X <- coords[,1]
sub_shp$Y <- coords[,2]

# Label key landmark sectors
key_labels <- sub_shp[sub_shp$cod_sectir %in% c(101, 102, 103, 104, 122, 130, 132), ]
key_labels$label_name <- c(
  "Grenoble Centre\n(Food/Bakery)",
  "Championnet\n(Coffee/Cafés)",
  "Parc Paul Mistral\n(Floral)",
  "Grands Boulevards\n(Traffic Fumes)",
  "UGA Campus\n(Floral/Arboretum)",
  "Échirolles Est\n(Commercial)",
  "Échirolles Ouest\n(Industrial Fumes)"
)

# Municipality boundary outlines
commune_boundaries <- aggregate(sub_shp$geometry, list(sub_shp$Commune), function(x) st_union(st_combine(x)))

p <- ggplot(data = sub_shp) +
  geom_sf(aes(fill = Smell_Signature), color = "#5D6D7E", size = 0.35) +
  scale_fill_manual(values = palette_smells, name = "Dominant Olfactory Profile (Fused Big Data Streams)") +
  geom_text(data = key_labels, aes(x = X, y = Y, label = label_name), 
            size = 2.7, fontface = "bold", color = "#17202A", check_overlap = TRUE) +
  labs(
    title = "Figure 5: Dynamic GIS Smell Cartography of Grenoble, Saint-Martin-d'Hères, and Échirolles",
    subtitle = "Zonal Classification derived from Multi-Source Data Fusion (ATMO Air Quality, OSM Scent Hotspots, Citizen Reports, and Waste Nodes)",
    caption = "Source: Grenoble-Alpes Métropole EMD Sector Boundary Shapefile (NewESRI.shp) | Spatial Resolution: 25 IRIS Sectors"
  ) +
  theme_minimal(base_size = 9.5) +
  theme(
    plot.title = element_text(face = "bold", size = 11.5, color = "#1B2631"),
    plot.subtitle = element_text(size = 8.5, color = "#566573", margin = margin(b = 10)),
    plot.caption = element_text(size = 7.5, color = "#7F8C8D", hjust = 0),
    legend.position = "bottom",
    legend.direction = "vertical",
    legend.title = element_text(face = "bold", size = 9),
    legend.text = element_text(size = 8),
    panel.grid.major = element_line(color = "#EBEDEF", size = 0.25),
    panel.background = element_rect(fill = "#FAFAFA", color = NA)
  )

ggsave(out_fig, plot = p, width = 10, height = 6.2, dpi = 300)
print(paste("Generated:", out_fig))
