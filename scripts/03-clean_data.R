#### Preamble ####
# Purpose: Cleans the raw 2024 US election poll of polls data recorded as of 2 November 2024.
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 2 November 2024
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites:  
# - The `tidyverse`, `janitor`,`lubridate` packages must be installed and loaded
# - 02-download_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)
#### Clean data ####
raw_data <- read_csv("data/01-raw_data/raw_election_24.csv")

cleaned_data <- raw_data |>
  clean_names()

# Filter data to Harris estimates based on high-quality polls after she declared
just_harris_high_quality <- cleaned_data |>
  # Select relevant columns for analysis
  select(
    pollster, numeric_grade, state, candidate_name, pct, sample_size, pollscore,
    population, end_date
  )|>filter(population %in% c("lv", "rv"))|>
  # Drop rows with missing values in essential columns
  drop_na(numeric_grade, pct, sample_size, end_date)|>
  filter(
    candidate_name == "Kamala Harris",
    numeric_grade >= 2 # mean of numeric_grade is 2.175, median is 1.9 
  ) |>
  mutate(
    state = if_else(is.na(state) | state == "--", "National", state),
    national_poll = if_else(state == "National", 1, 0)  # 1 for national, 0 for state-specific
  ) |> mutate(
    end_date = mdy(end_date)
  )|>
  filter(end_date >= as.Date("2024-07-21"))|>
  mutate(
    recency = as.numeric(difftime(as.Date("2024-11-05"), end_date, units = "days"))
  ) |>
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    candidate_name = factor(candidate_name),
    population = factor(population),  # Only if appropriate
    national_poll = factor(national_poll)
  )

just_trump_high_quality <- cleaned_data|>
  # Select relevant columns for analysis
  select(
    pollster, numeric_grade, state, candidate_name, pct, sample_size, pollscore,
    population, end_date
  )|>filter(population %in% c("lv", "rv"))|>
  # Drop rows with missing values in essential columns
  drop_na(numeric_grade, pct, sample_size, end_date)|>
  filter(
    candidate_name == "Donald Trump",
    numeric_grade >= 2 # mean of numeric_gradeis 2.175, median is 1.9 
  ) |>
  mutate(
    state = if_else(is.na(state) | state == "--", "National", state),
    national_poll = if_else(state == "National", 1, 0)  # 1 for national, 0 for state-specific
  ) |> mutate(
    end_date = mdy(end_date)
  )|>
  filter(end_date >= as.Date("2024-07-21"))|>
  # Calculate recency weight using exponential decay (more recent polls get higher weight)
  mutate(
    recency = as.numeric(difftime(as.Date("2024-11-05"), end_date, units = "days"))
  ) |>
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    candidate_name = factor(candidate_name),
    population = factor(population),  # Only if appropriate
    national_poll = factor(national_poll)
  )
#### Save data ####
write_csv(just_harris_high_quality, "data/02-analysis_data/analysis_data_Harris.csv")
write_csv(just_trump_high_quality, "data/02-analysis_data/analysis_data_Trump.csv")
write_parquet(just_harris_high_quality, "data/02-analysis_data/analysis_data_Harris.parquet")
write_parquet(just_trump_high_quality, "data/02-analysis_data/analysis_data_Trump.parquet")
