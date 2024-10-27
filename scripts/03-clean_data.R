#### Preamble ####
# Purpose: Cleans the raw polling data for the 2024 U.S. presidential election and prepares it for multi-level regression with post-stratification (MRP) analysis
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Ensure the raw data file `president_polls_1027.csv` is located in the `data/01-raw_data/` directory, and that necessary packages are installed.

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)

#### Clean data ####
# Load the raw polling data
raw_data <- read_csv("data/01-raw_data/president_polls.csv")

#### Clean data ####
cleaned_data <- 
  raw_data %>%
  clean_names() %>%
  # Select relevant columns for analysis
  select(
    pollster, numeric_grade, state, candidate_name, pct, sample_size, 
    population, methodology, start_date, end_date
  ) %>%
  # Filter for Kamala Harris only, as we're interested in her percentage support
  filter(candidate_name == "Kamala Harris") %>%
  # Drop rows with missing values in essential columns
  drop_na(numeric_grade, pct, sample_size, end_date) %>%
  # Standardize state names and handle national vs. state-specific polls
  mutate(
    state = if_else(state == "--", NA_character_, state),
    national_poll = if_else(is.na(state), 1, 0)  # 1 for national, 0 for state-specific
  ) %>%
  # Convert start_date and end_date to Date format
  mutate(
    start_date = mdy(start_date),
    end_date = mdy(end_date)
  ) %>%
  # Calculate recency weight using exponential decay (more recent polls get higher weight)
  mutate(
    days_since_poll = as.numeric(difftime(Sys.Date(), end_date, units = "days")),
    recency_weight = exp(-days_since_poll / 30)  # Adjust decay rate as needed
  ) %>%
  # Apply sample size weight, capped at a maximum of 2,300 responses
  mutate(sample_size_weight = pmin(sample_size / 2300, 1)) %>%
  # Finalize relevant columns for modeling and remove unneeded columns
  select(pollster, numeric_grade, state, pct, sample_size, 
         population, methodology, recency_weight, sample_size_weight, national_poll)

#### Save cleaned data ####
write_csv(cleaned_data, "data/02-analysis_data/cleaned_harris_support.csv")

