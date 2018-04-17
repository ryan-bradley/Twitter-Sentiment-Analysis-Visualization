library(shiny)
library(shinyURL)
library(dplyr)
library(tidyr)
library(googleCharts)
library(googleVis)

terms_to_exclude = c("hiring", "job", "jobs", "careerarc")

#load_data <- function(data_file = "twitter-mentions.txt") {
load_data <- function(data_file = "twitter-tags.txt") {
  today_date = as.character(Sys.Date())
  data_file_location = paste0("~/PycharmProjects/HashtagSentiments/data/Twitter/",
                              today_date, "-", data_file)
  data <- read.delim(data_file_location, quote = "", sep = ":", header = FALSE)
  colnames(data) = c("Main_Dimension", "j1", "j2", "Sentiment")
  for (col in c("j1", "j2")) {
    data[[col]] <- NULL
  }
  
  data <- data %>% filter(Sentiment != "") %>%
    mutate(Main_Dimension = as.character(Main_Dimension),
           Sentiment = as.factor(Sentiment))
  
  sentiments = data %>% select(Sentiment) %>% unique()
  for (sentiment in sentiments$Sentiment) {
    data[[sentiment]] = ifelse(data$Sentiment == sentiment, 1, 0)
  }
  
  data$Sentiment <- NULL
  
  data <- data %>%
    group_by(Main_Dimension) %>%
    summarise_all(funs(sum)) %>%
    mutate(Total = `0` + `1`) %>%
    arrange(desc(Total)) %>%
    rename("Positive" = `1`,
           "Negative" = `0`) %>%
    filter(!(Main_Dimension %in% terms_to_exclude))
  
  data
}


