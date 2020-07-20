###############################################################################
# POKUD CHCI NAHRÁVAT NOVÁ DATA TAK MUSÍM PROMAZAT RSTUDIO_DATA!!!!!!!!!!!!!! #
###############################################################################

#################################################################
#setwd("~/cesta do složky se skripty")

#složka bude vypadat:
# -- Projekt štěpík <- sem si nastavíš working directory!
#  -- skript 1.R
#  -- skript 2.R
#  -- rstudio_data
#  -- rstudio_import
#################################################################


if (!file.exists("./rstudio_import")){
  # create source directory if it doesn't exit
  dir.create("./rstudio_import")
}

if (!file.exists("./rstudio_data")){
  # create source directory if it doesn't exit
  dir.create("./rstudio_data")
}


 # print("data folder is empty, initiating import...") 
 # #copy each ext_usage and add date stamp based on folder name
 #  folder_names <- list.files("./rstudio_import/")
 #  print(paste("Reorganising..."))
 #  for (folder in folder_names){
 #    file.copy(from = paste("./rstudio_import/", folder,"/ext_usage.csv", sep = ""),
 #              to = paste("./rstudio_data/",substr(folder, 0, 10),"_ext_usage.csv", sep = "")
 #    )
 #  }



if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr")}
if("readr" %in% rownames(installed.packages()) == FALSE) {install.packages("readr")}
if("ggplot2" %in% rownames(installed.packages()) == FALSE) {install.packages("ggplot2")}
if("tibble" %in% rownames(installed.packages()) == FALSE) {install.packages("tibble")}
if("ggrepel" %in% rownames(installed.packages()) == FALSE) {install.packages("ggrepel")}
if("tidyr" %in% rownames(installed.packages()) == FALSE) {install.packages("ggrepel")}

library(readr)
library(tibble)
library(dplyr)
library(ggplot2)
library(ggrepel)

# load processing functions
source("./init_dataset.R", echo = FALSE)
source("./summarise.R", echo = FALSE)
source("./graph.R", echo = FALSE)
source("./analysis.R", echo = FALSE)

# load original dataset and list of articles which contained edits
ds <- init_dataset("./rstudio_data")
ae <- add_page_id_to_ae(init_articles_edited(), ds)
