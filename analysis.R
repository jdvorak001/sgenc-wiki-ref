library(readr)
library(tibble)
library(dplyr)

# load processing functions
source("./init_dataset.R", echo = FALSE)
source("./summarise.R", echo = FALSE)

# load original dataset and list of articles which contained edits
ds <- init_dataset("./rstudio_data")
ae <- add_page_id_to_ae(init_articles_edited(), ds)


get_difference <- function(from, to, ds, ae){
  # from / to = datum rok-měsíc-den, ds = proměnná s datasetem (ds), ae = články co jsi editoval (viz. csv)
  documents_in_range <- ds %>% filter(date_harvested > from & date_harvested < to) %>% distinct(page_id, .keep_all = TRUE)
  document_before_range <- ds %>% filter(date_harvested < from) %>% distinct(page_id, .keep_all = TRUE)
  
  return(documents_in_range %>% filter(!page_id %in% ae$page_id) %>% filter(!page_id %in% document_before_range$page_id))
}

