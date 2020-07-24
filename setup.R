
if (!file.exists("./rstudio_import")){
  # create source directory if it doesn't exit
  dir.create("./rstudio_import")
}

if (!file.exists("./rstudio_data")){
  # create source directory if it doesn't exit
  dir.create("./rstudio_data")
}


if (length(dir("./rstudio_data",all.files=TRUE)) <= 2){
 print("data folder is empty, initiating import...")
 #copy each ext_usage and add date stamp based on folder name
  folder_names <- list.files("./rstudio_import/")
  print(paste("Reorganising..."))
  for (folder in folder_names){
    file.copy(from = paste("./rstudio_import/", folder,"/ext_usage.csv", sep = ""),
              to = paste("./rstudio_data/",substr(folder, 0, 10),"_ext_usage.csv", sep = "")
    )
  }
}



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
library(tidyr)

source("./init_dataset.R", echo = FALSE)
source("./summarise.R", echo = FALSE)
source("./graph.R", echo = FALSE)
source("./analysis.R", echo = FALSE)

ds <- init_dataset("./rstudio_data")
ae <- add_page_id_to_ae(init_articles_edited(), ds)
