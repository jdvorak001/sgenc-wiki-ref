library(readr)
library(tibble)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(tidyr)

graph_labels <- function(ds,ae){
  # funkce pro kreslení grafu
  

  merge <- add_row(ds %>% add_column(contains_edited=TRUE), 
                   ds %>% filter(!page_id %in% ae$page_id | date_harvested > "2020-04-20" & date_harvested < "2020-05-10") %>% 
                          add_column(contains_edited=FALSE)
  ) 
  

  plot_comments <- merge %>% group_by(date_harvested, contains_edited) %>% count(date_harvested) %>% add_column(comment=NA)
  plot_comments <- plot_comments %>% mutate(comment=replace(comment, date_harvested == "2020-05-08" & contains_edited==TRUE, "První kontakt s wikipedisty"))
  plot_comments <- plot_comments %>% mutate(comment=replace(comment, date_harvested == "2020-06-11" & contains_edited==TRUE, "Poslední rozhovor"))
  plot_comments <- plot_comments %>% mutate(comment=replace(comment, date_harvested == "2020-06-24" & contains_edited==TRUE, "Provedení experimentu"))
  
  
  ggplot(data = plot_comments, aes(x=date_harvested, y = n)) + 
    geom_area(aes(x=date_harvested, y = n, fill = factor(contains_edited, levels = c(TRUE, FALSE))), position = "identity") +
    scale_fill_discrete(name = "Legenda", labels = c("Veškeré odkazy", "Odkazy bez provedených editací")) + 
    scale_x_date(date_breaks = "1 month", date_labels = "%m", labels = c(1, 2, 3, 4, 5, 6, 7)) + 
    geom_point(data = drop_na(plot_comments),aes(x=date_harvested, y = n)) + 
    geom_label_repel(data = drop_na(plot_comments),aes(x=date_harvested, y = n, label = comment),  direction = "x", nudge_y = 15) +
    labs(title="Monitorování zpětných odkazů ze Wikipedie do Sociologické encyklopedie", x = "Časové rozmezí (12. 3. 2020 - 19. 7. 2020)", y = "Počet odkazů")  + 
    coord_cartesian(ylim = c(75, 175))
}

graph_labels(ds, ae)



