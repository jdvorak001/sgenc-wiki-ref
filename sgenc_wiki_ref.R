setwd("/home/debian/data")
#install.packages("httr")
#install.packages("jsonlite")
#install.packages("foreach")
library("httr")
library("jsonlite")
library("foreach")

vyhledavany_vyraz <- c("sociologicka_encyklopedie_url", "sociologicka_encyklopedie_fraze", "maly_sociologicky_slovnik_fraze", "slovnik_ceskych_sociologu_fraze", "slovnik_institucionalniho_zazemi_ceske_sociologie_fraze", "velky_sociologicky_slovnik_fraze")
vyhledavany_vyraz_api <- c("%22encyklopedie.soc.cas.cz%22","%22sociologick%C3%A1%20encyklopedie%22", "%22mal%C3%BD%20sociologick%C3%BD%20slovn%C3%ADk%22", "%22Slovn%C3%ADk%20%C4%8Desk%C3%BDch%20sociolog%C5%AF%22", "%22Slovn%C3%ADk%20institucion%C3%A1ln%C3%ADho%20z%C3%A1zem%C3%AD%20%C4%8Desk%C3%A9%20sociologie%22","%22Velk%C3%BD%20sociologick%C3%BD%20slovn%C3%ADk%22")
sledovane_vyrazy_dataframe <- data.frame(vyhledavany_vyraz, vyhledavany_vyraz_api)
st=format(Sys.time(), "%Y-%m-%d_%H:%M:%S")
#nazev_json <- paste("json_",st)
#nazev_csv <- paste("csv_",st)
#dir.create(nazev_json)
#dir.create(nazev_csv)
dir.create(st)
setwd(st)
for(i in 1:nrow(sledovane_vyrazy_dataframe)){
  url <- paste0("https://cs.wikipedia.org/w/api.php?action=query&format=json&list=search&utf8=1&srsearch=",sledovane_vyrazy_dataframe$vyhledavany_vyraz_api[i],"&srlimit=500")
  response <- GET(url)
  json <- fromJSON(rawToChar(response$content))
  write_json(json,paste(sledovane_vyrazy_dataframe$vyhledavany_vyraz[i],"_",st,".json",sep = ""))
  article_titles <- json$query$search$title
  article_id <- json$query$search$pageid
  article_text_mention <- json$query$search$snippet
  article_data_frame <- data.frame(article_titles, article_id, article_text_mention)
  write.csv(article_data_frame, paste(sledovane_vyrazy_dataframe$vyhledavany_vyraz[i],"_",st, ".csv", sep = ""))
}
url <- paste0("https://cs.wikipedia.org/w/api.php?action=query&list=exturlusage&euquery=encyklopedie.soc.cas.cz&euprotocol=https&eunamespace=*&eulimit=500")
response <- GET(url)
json <- fromJSON(rawToChar(response$content))
write_json(json,paste("ext_usage.json",sep = ""))
page_id <- json$query$exturlusage$pageid
title <- json$query$exturlusage$title
url <- json$query$exturlusage$url
ext_usage_data_frame <- data.frame(page_id, title, url)
write.csv(ext_usage_data_frame, paste("ext_usage.csv", sep = ""))
setwd('..')
