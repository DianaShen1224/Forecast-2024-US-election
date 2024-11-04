#### Preamble ####
# Purpose: Simulates a dataset of 2024 US election poll of polls.
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 3 November 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `lubridate` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj

#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Data expected structure ####
# Simulated Data Harris:
# - Columns: pollscore, end_date, pollster, numeric_grade, national_poll, recency, state, population, sample_size, pct, candidate, sample_size_weight, recency_weight, combined_weight
# - pollscore should be between -1.5 and 2
# - end_date should be between 2024-07-21 and 2024-11-2
# - pollster should be one of: "Pollster A", "Pollster B", "Pollster C", "Pollster D".
# - numeric_grade should be between 0.5 and 3
# - national_poll should be one of: 0 and 1.
# - state should be valid US state abbreviations
# - population should be one of: "lv", "rv"
# - recency should greater than 0.
# - candidate should be one of: "Donald Trump", "Kamala Harris"
# - pct should be between 30 and 80
# - sample_size should be between 0 and 2300

#### Simulate data ####
# Define states, candidates, and other factors
states <- c("National", "Arizona", "Georgia", "Michigan", "Nevada", "North Carolina", "Pennsylvania", "Wisconsin")
candidates <- c("Kamala Harris", "Donald Trump")
pollsters <- c("Pollster A", "Pollster B", "Pollster C", "Pollster D")
populations <- c("rv", "lv")

simulated_data <- data.frame(
  end_date =  sample(seq(as.Date('2024-07-21'), as.Date('2024-11-02'), by="day"), 
                     700, replace=TRUE),
  state = factor(sample(states, size = 700, replace = TRUE)),
  pollster = factor(sample(pollsters, size = 700, replace = TRUE)),
  population = factor(sample(populations, size = 700, replace = TRUE)),
  sample_size = sample(1:2300, size = 700, replace = TRUE),
  numeric_grade = runif(700, min = 0.5, max = 3),
  pollscore = runif(700, min = -1.5, max = 2),
  pct = round(runif(700, 30, 80), 1)
) |>
  mutate(
    candidate_name = factor(sample(candidates, size = 700, replace = TRUE)),
    national_poll = factor(if_else(state == "National", 1, 0)),
    recency = as.numeric(difftime(as.Date("2024-11-05"), end_date, units = "days")),
  )

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
