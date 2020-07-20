library(readr)
library(tibble)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(tidyr)


graph <-function(ds,ae){
  # call this to draw the graph
  
  # create new column which contains info about whether given harvest contained edited articles or not
  merge <- add_row(ds %>% add_column(contains_edited=TRUE), 
                   ds %>% filter(!page_id %in% ae$page_id) %>%
                    add_column(contains_edited=FALSE)
                   ) 
  
  # calculate n of occurences for each grouped variable
  plot_data <- merge %>% group_by(date_harvested, contains_edited) %>% count(date_harvested)
  
  # draw plot
  return(ggplot(data = plot_data, aes(x=date_harvested, y = n, color=contains_edited)) + 
    geom_line() +
    scale_color_discrete(name = "Vysvětlivky", labels = c("Bez editací", "Všechny odkazy")) +
    labs(title="Vývoj počtu odkazů", x = "datum", y = "Počet odkazů")
  )
}

graph_labels <- function(ds,ae){
  # call this to draw the graph
  
  # create new column which contains info about whether given harvest contained edited articles or not
  merge <- add_row(ds %>% add_column(contains_edited=TRUE), 
                   ds %>% filter(!page_id %in% ae$page_id) %>%
                     add_column(contains_edited=FALSE)
  ) 
  
  # calculate n of occurences for each grouped variable
  plot_comments <- merge %>% group_by(date_harvested, contains_edited) %>% count(date_harvested) %>% add_column(comment=NA)
  plot_comments <- plot_comments %>% mutate(comment=replace(comment, date_harvested == "2020-05-08" & contains_edited==TRUE, "První kontakt s wikipedisty"))
  plot_comments <- plot_comments %>% mutate(comment=replace(comment, date_harvested == "2020-06-11" & contains_edited==TRUE, "Poslední rozhovor"))
  plot_comments <- plot_comments %>% mutate(comment=replace(comment, date_harvested == "2020-06-24" & contains_edited==TRUE, "Provedení experimentu"))
  
  
  ggplot(data = plot_comments, aes(x=date_harvested, y = n)) + 
    geom_area(aes(x=date_harvested, y = n, fill = factor(contains_edited, levels = c(TRUE, FALSE))), position = "identity") +
    # geom_line(aes(x=date_harvested, y = n, color = factor(contains_edited, levels = c(TRUE, FALSE))), name = "legenda") + 
    scale_fill_discrete(name = "Legenda", labels = c("Bez editací", "Veškeré odkazy")) + 
    scale_x_date(date_breaks = "1 month", date_labels = "%m", labels = c(1, 2, 3, 4, 5, 6, 7)) + 
    geom_point(data = drop_na(plot_comments),aes(x=date_harvested, y = n)) + 
    geom_label_repel(data = drop_na(plot_comments),aes(x=date_harvested, y = n, label = comment),  direction = "y") +
    # scale_y_continuous(limits = c(0, 175), breaks = seq(0, 175, 25)) +
    labs(title="Monitorování zpětných odkazů", x = "Datum", y = "Počet článků")  + 
    coord_cartesian(ylim = c(75, 175))
}

graph_labels(ds, ae)



