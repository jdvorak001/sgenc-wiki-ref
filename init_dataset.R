library(readr)
library(tibble)
library(dplyr)

init_dataset <- function(source_folder){
  filelist <- list.files(source_folder, full.names = TRUE)
  dataset <- tibble()
  for (file in filelist){
    new_data <- read_csv(file, 
                         col_types = cols(X1 = col_skip(), page_id = col_double(), 
                                          title = col_character(), url = col_character()))
  
    new_data <- new_data %>% add_column(date_harvested = rep(substr(file,16,26), times=nrow(new_data)), )
    dataset <- bind_rows(dataset, new_data)
  }

  dataset$date_harvested <- as.Date(dataset$date_harvested, "%Y-%m-%d")
  
  
  dataset <- dataset %>% filter(!grepl("^Diskuse s wikipedistou:", title))
  dataset <- dataset %>% filter(!grepl("^Diskuse ke kategorii", title))
  dataset <- dataset %>% filter(!grepl("^Diskuse k portálu:", title))
  dataset <- dataset %>% filter(!grepl("^Diskuse:", title))
  dataset <- dataset %>% filter(!grepl("^Wikipedie:", title))
  
  
  return(dataset)
}

init_articles_edited <-function(){
  articles_edited <- read_csv("rstudio_import/articles_edited_list.csv")
  return(articles_edited)
}

add_page_id_to_ae <- function(ae,ds){
  return(left_join(ae,ds %>% distinct(title,.keep_all = TRUE), "title") %>% select(page_id,title, wiki_url=url.x, soc_url=url.y, date_harvested))
}
