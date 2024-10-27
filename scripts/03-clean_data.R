#### Preamble ####
# Purpose: Cleans the raw poll data recorded
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 27 Octobor 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: not needed
# Any other information needed? not needed

#### Workspace setup ####
library(tidyverse)

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
    state = if_else(is.na(state), "National", state), # Hacky fix for national polls - come back and check
  ) |> mutate(
    start_date = mdy(start_date),
    end_date = mdy(end_date)
  )|>
  filter(end_date >= as.Date("2024-07-21")) |> # When Harris declared
  mutate(
    num_harris = round((pct / 100) * sample_size, 0) # Need number not percent for some models
  )|>
mutate(sample_size_weight = pmin(sample_size / 2300, 1)) |>
  # Finalize relevant columns for modeling and remove unneeded columns
  select(pollster, numeric_grade, state, pct, sample_size, 
         population, methodology, recency_weight, sample_size_weight, national_poll)

just_trump_high_quality <- cleaned_data cleaned_data |>
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
    state = if_else(is.na(state), "National", state), # Hacky fix for national polls - come back and check
  ) |> mutate(
    start_date = mdy(start_date),
    end_date = mdy(end_date)
  )|>
  filter(end_date >= as.Date("2024-07-21")) |> # When Harris declared
  mutate(
    num_harris = round((pct / 100) * sample_size, 0) # Need number not percent for some models
  )|>
  mutate(sample_size_weight = pmin(sample_size / 2300, 1)) |>
  # Finalize relevant columns for modeling and remove unneeded columns
  select(pollster, numeric_grade, state, pct, sample_size, 
         population, methodology, recency_weight, sample_size_weight, national_poll)

#### Save data ####
write_csv(just_harris_high_quality, "data/02-analysis_data/analysis_data_Harris.csv")
write_csv(just_harris_high_quality, "data/02-analysis_data/analysis_data_Trump.csv")