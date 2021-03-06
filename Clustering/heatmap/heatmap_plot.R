# ---
# title: "Progression Heatmap Data Preprocessing & Plotting"
# author: "Venus Lau; Yen-Hsiang (Brian) Lee"
# date: "19/02/2020"
# updated: "23/02/2020"
# ---


# getwd()

##########
# Preprocessing: formatting table for heatmap
# ---

library(tidyverse)

# data<-read.table("data/COVID-19_Singapore_Heatmap-table.tsv", header = TRUE, sep = "\t")
data <- read.csv("data/COVID-19_Singapore_Heatmap-table.csv")

data_long <- data %>% gather(key=date, value=status, X1.18.2020:X2.26.2020)

data_long$date <- gsub('X', '0', data_long$date)
data_long$date <- gsub('\\.', '\\/', data_long$date)

write.csv(data_long, "data/COVID-19_Singapore_Heatmap_long_26-02-2020.csv")

##########

##########
# Plotting

library(ggplot2)
library(viridis)
library(plotly)

data <- read.csv("Clustering/data/COVID-19_Singapore_Heatmap_long_26-02-2020.csv")
data$date <- factor(data$date, levels=unique(data$date))
data$case <- factor(data$case, levels=unique(data$case))

data$status_word=ifelse(data$status == 0,"Unexposed",
                         ifelse(data$status == 1,"Exposed",
                                ifelse(data$status == 2,"Symptomatic",
                                       ifelse(data$status == 3,"Hospitalized","Discharged"))))

write.csv(data, "data/COVID-19_Singapore_Heatmap_plot.csv")

p1 <- ggplot(
  data, 
  # aes(x = date, y = case, fill = status_word,
  aes(x = date, y = case, fill = status,
      text = paste("Case: ", case_detailed,
                   "<br>Date: ", date,
                   "<br>Status: ", status_word,
                   "<br>Cluster: ", cluster,
                   "<br>Citizenship: ", citizenship))) +
  geom_tile() +
  xlab(label = "Date") +
  ylab(label = "Cases") +
  ggtitle("COVID-19 Progression Amongst Singapore Cases") +
  labs(fill = "Status") + #tile fill legend label
  theme(plot.title = element_text(hjust = 0.5)) + #centre main title
  theme(axis.text.x = element_text(angle = 60, hjust = 0.6, size = 8),
        axis.ticks.x = element_blank(), #remove x axis ticks
        axis.ticks.y = element_blank()) + #remove y axis ticks
  # scale_fill_viridis_d(direction = -1) +
  scale_fill_viridis_c(direction = 1) +
  theme(panel.background = element_rect(fill = "white"))

ggplotly(p1,tooltip = 'text')

##########

p_static=ggplot(
  data, 
  # aes(x = date, y = case, fill = status_word,
  aes(x = date, y = case, fill = status_word,
      text = paste("Case: ", case_detailed,
                   "<br>Date: ", date,
                   "<br>Status: ", status_word,
                   "<br>Cluster: ", cluster,
                   "<br>Citizenship: ", citizenship))) +
  geom_tile() +
  xlab(label = "Date") +
  ylab(label = "Cases") +
  ggtitle("COVID-19 Progression Amongst Singapore Cases") +
  labs(fill = "Status") + #tile fill legend label
  theme(plot.title = element_text(hjust = 0.5)) + #centre main title
  theme(axis.text.x = element_text(angle = 60, hjust = 0.6, size = 8),
        axis.ticks.x = element_blank(), #remove x axis ticks
        axis.ticks.y = element_blank()) + #remove y axis ticks
  # scale_fill_viridis_d(direction = -1) +
  scale_fill_viridis_d(direction = -1,breaks=c("Unexposed","Exposed","Symptomatic","Hospitalized","Discharged")) +
  theme(panel.background = element_rect(fill = "white"),
        axis.text.y = element_text(size=6),
        axis.text.x = element_text(hjust=1))

p_static

ggsave("Clustering/heatmap/heatmap_static.png",plot=p_static, device="png",width = 12,height = 8,units="in")


 