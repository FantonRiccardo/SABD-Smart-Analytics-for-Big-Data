#####
# Packages to be installed from R or RStudio
# To install the packages :
# 1. Select the line(s) of the packages you want to install
# 2. click 'Run' button or CTRL+ENTER
#    tip: CTRL+A and CTRL+ENTER to install all packages on this page
#    you can also install packages by the "packages" panel 


# RMarkdown and output management packages
install.packages('knitr', dependencies = TRUE)
install.packages("tinytex", dependencies = TRUE)
tinytex::install_tinytex()
install.packages('prettydoc', dependencies = TRUE)
install.packages('kableExtra', dependencies = TRUE)
install.packages('rmarkdown', dependencies = TRUE)
install.packages("stargazer")
install.packages("rmdformats")
install.packages("formatR")
install.packages("lmtest")
install.packages("skimr")
install.packages("mongolite")
install.packages("ggpubr")


# Data handling package
install.packages("tidyverse")

# Data packages 
install.packages("Ecdat"); install.packages("MASS")
install.packages("HSAUR3") # data from handbook of stat using R

# Packages for advanced graphics
install.packages(c("ggplot2", "gcookbook"))

# Packages for the DCM models
install.packages("gmnl")   # GMNL may be to be installed before  MLOGIT ?
install.packages("mlogit")
install.packages("lmtest") 
install.packages("gmodels");install.packages("VGAM");


install.packages("dismo")
install.packages("maptools")
install.packages("reshape2")         # transformation format long, format large
install.packages("sp")               # objets spatiaux
install.packages("rgdal")            # fonctions de la bibliothèque GDAL
install.packages("grid")             # fonction arrow
install.packages("cartography")      # cartographie thématique
install.packages("RColorBrewer")     # palettes de couleurs de C. Brewer
