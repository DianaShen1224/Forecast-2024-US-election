#### Preamble ####
# Purpose: Cleans the raw poll data recorded
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 27 October 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: not needed
# Any other information needed? not needed

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)
library(arrow)
#### Clean data ####
raw_data <- read_csv("data/01-raw_data/raw_election_24.csv")

cleaned_data <- raw_data |>
  clean_names()
summary(cleaned_data)##check summary statistics of raw cleaned data

# Filter data to Harris estimates based on high-quality polls after she declared
just_harris_high_quality <- cleaned_data |>
  # Select relevant columns for analysis
  select(
    pollster, numeric_grade, state, candidate_name, pct, sample_size, 
    population, methodology, start_date, end_date
  )|>
  # Drop rows with missing values in essential columns
  drop_na(numeric_grade, pct, sample_size, end_date)|>
  filter(
    candidate_name == "Kamala Harris",
    numeric_grade >= 2 # mean of numeric_gradeis 2.175, median is 1.9 
  ) |>
  mutate(
    state = if_else(state == "--", NA_character_, state),
    national_poll = if_else(is.na(state), 1, 0)  # 1 for national, 0 for state-specific
  ) |> mutate(
    start_date = mdy(start_date),
    end_date = mdy(end_date)
  )|>
  # Calculate recency weight using exponential decay (more recent polls get higher weight)
  mutate(
    recency = as.numeric(difftime(as.Date("2024-11-05"), end_date, units = "days")),
    recency_weight = exp(-recency*0.1)  # Adjust decay rate as needed
  ) |>
  # Apply sample size weight, capped at a maximum of 2,300 responses
  mutate(sample_size_weight = pmin(sample_size / 2300, 1))
just_harris_high_quality <- just_harris_high_quality %>%
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    candidate_name = factor(candidate_name),
    population = factor(population),  # Only if appropriate
    methodology = factor(methodology)
  )

just_trump_high_quality <- cleaned_data|>
  # Select relevant columns for analysis
  select(
    pollster, numeric_grade, state, candidate_name, pct, sample_size, 
    population, methodology, start_date, end_date
  )|>
  # Drop rows with missing values in essential columns
  drop_na(numeric_grade, pct, sample_size, end_date)|>
  filter(
    candidate_name == "Donald Trump",
    numeric_grade >= 2 # mean of numeric_gradeis 2.175, median is 1.9 
  ) |>
  mutate(
    state = if_else(state == "--", NA_character_, state),
    national_poll = if_else(is.na(state), 1, 0)  # 1 for national, 0 for state-specific
  ) |> mutate(
    start_date = mdy(start_date),
    end_date = mdy(end_date)
  )|>
  # Calculate recency weight using exponential decay (more recent polls get higher weight)
  mutate(
    recency = as.numeric(difftime(as.Date("2024-11-05"), end_date, units = "days")),
    recency_weight = exp(-recency*0.1)  # Adjust decay rate as needed
  ) |>
  # Apply sample size weight, capped at a maximum of 2,300 responses
  mutate(sample_size_weight = pmin(sample_size / 2300, 1)) 
just_trump_high_quality <- just_trump_high_quality %>%
  mutate(
    pollster = factor(pollster),
    state = factor(state),
    candidate_name = factor(candidate_name),
    population = factor(population),  # Only if appropriate
    methodology = factor(methodology)
  )
#### Save data ####
write_parquet(just_harris_high_quality, "data/02-analysis_data/analysis_data_Harris.parquet")
write_parquet(just_trump_high_quality, "data/02-analysis_data/analysis_data_Trump.parquet")
