#### Preamble ####
# Purpose: Downloads and saves the data from FiveThirtyeight.com of 2024 US election poll of polls.
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 2 November 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Packages `tidyverse` must be installed and loaded
# Any other information needed? Make sure you are in the `starter_folder` rproj


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
  file = "data/01-raw_data/raw_election_24.csv"
)

