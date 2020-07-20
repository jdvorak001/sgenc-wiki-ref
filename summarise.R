library(ggplot2)

get_articles_by_date <- function(source, date){
  # return all articles in source which match date
  return(source %>% filter(date_harvested==date) %>% nrow())
}

summarise_article_count <- function(source, from,to){
  # calculate article counts in source using given from-to date range 
  date_range <- as.Date(seq(from=as.Date(from), to=as.Date(to), by="day"))
  article_count <- c()
  for (x in as.list(date_range)){
    article_count <- c(article_count, get_articles_by_date(source, as.Date(x)))
  }
  return(tibble(date_range,article_count))
}

