#### Preamble ####
# Purpose: Downloads and saves the data from FiveThirtyeight,com
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 27 October 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)

#### Download data ####
#### Acquire ####
raw_elections_data <- read_csv(
  file = "https://projects.fivethirtyeight.com/polls/data/president_polls.csv",
  show_col_types = FALSE,
  col_names = TRUE  
)

#### Save data ####
write_csv(
  x = raw_elections_data,
  file = "~/2024 US Election Forecast/data/01-raw_data/raw_election_24.csv"
)

head(raw_elections_data)
raw_elections_data<-read.csv("~/2024 US Election Forecast/data/01-raw_data/raw_election_24.csv")
