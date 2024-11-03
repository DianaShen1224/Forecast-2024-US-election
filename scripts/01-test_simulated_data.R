#### Preamble ####
# Purpose: Tests the structure and validity of the 2024 US election poll of polls
# simulated dataset.
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 3 November 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse`, `testthat`,`lubridate`,`arrow` package must be installed and loaded
# - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(lubridate)
library(arrow)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")
# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####
## test simulated data has correct structure

test_that("Simulated Harris data has correct structure", {
  expect_true(is.numeric(simulated_data$poll_score))
  expect_true(inherits(simulated_data$end_date, "Date"))
  expect_true(is.character(simulated_data$pollster))
  expect_true(is.numeric(simulated_data$numeric_grade))
  expect_true(is.numeric(simulated_data$national_poll))
  expect_true(is.numeric(simulated_data$recency))
  expect_true(is.character(simulated_data$state))
  expect_true(is.character(simulated_data$population))
  expect_true(is.numeric(simulated_data$sample_size))
  expect_true(is.numeric(simulated_data$pct))
  expect_true(is.character(simulated_data$candidate))
})

# Check if the dataset has 700 rows
if (nrow(simulated_data) == 700) {
  message("Test Passed: The dataset has 700 rows.")
} else {
  stop("Test Failed: The dataset does not have 700 rows.")
}

# Check if the dataset has 11 columns
if (ncol(simulated_data) == 11) {
  message("Test Passed: The dataset has 11 columns.")
} else {
  stop("Test Failed: The dataset does not have 11 columns.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if 'pct' column contains only valid percentage data
if (all(simulated_data$pct >= 0 & simulated_data$pct <= 100)) {
  message("Test Passed: The 'pct' column contains no impossible value ranged outside 0 to 100.")
} else {
  stop("Test Failed: The 'pct' column contains impossible value ranged outside 0 to 100.")
}

# Check if 'end_date' column contains only valid end_date names
if (all(simulated_data$end_date>=as.Date("2024-7-21")&simulated_data$end_date<=as.Date("2024-11-2"))) {
  message("Test Passed: The 'end_date' column contains latest date only from 2024-7-21 to 2024-11-2.")
} else {
  stop("Test Failed: The 'end_date' column contains overdate data/future data.")
}

# Check if 'state' column contains only valid state names
valid_states <- c("National", "Arizona", "Georgia", "Michigan", "Nevada", "North Carolina", "Pennsylvania", "Wisconsin")

if (all(simulated_data$state %in% valid_states)) {
  message("Test Passed: The 'state' column contains only valid U.S. state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}

# Check if 'candidate_name' column contains only valid candidate names
valid_candidates <- c("Kamala Harris", "Donald Trump")

if (all(simulated_data$candidate_name %in% valid_candidates)) {
  message("Test Passed: The 'candidate_name' column contains only valid candidate names.")
} else {
  stop("Test Failed: The 'candidat' column contains invalid candidate names.")
}
# Check if 'population' column contains only valid population types
valid_populations <- c("rv", "lv")

if (all(simulated_data$population %in% valid_populations)) {
  message("Test Passed: The 'population' column contains only valid population types.")
} else {
  stop("Test Failed: The 'population' column contains invalid population types.")
}

# Check if 'sample_size' is greater than 1
if (all(simulated_data$sample_size >= 1)) {
  message("Test Passed: The 'sample_size' column values are greater than 1.")
} else {
  stop("Test Failed: The 'sample_size' column contains values smaller than 1.")
}

# Check if 'numeric_grade' is within the valid range of 0.5 to 3
if (all(simulated_data$numeric_grade >= 0.5 & simulated_data$numeric_grade <= 3)) {
  message("Test Passed: The 'numeric_grade' column values are within the valid range.")
} else {
  stop("Test Failed: The 'numeric_grade' column contains values outside the valid range.")
}

# Check if 'pollscore' is within the valid range of -1.5 to 2
if (all(simulated_data$pollscore >= -1.5 & simulated_data$pollscore <= 2)) {
  message("Test Passed: The 'pollscore' column values are within the valid range.")
} else {
  stop("Test Failed: The 'pollscore' column contains values outside the valid range.")
}

# Check if 'national_poll' column contains only 1 or 0
if (all(simulated_data$national_poll %in% c(0, 1))) {
  message("Test Passed: The 'national_poll' column contains only 0 and 1 values.")
} else {
  stop("Test Failed: The 'national_poll' column contains values other than 0 and 1.")
}

# Check if 'pollster' column contains only valid pollster names
valid_pollsters <- c("Pollster A", "Pollster B", "Pollster C", "Pollster D")

if (all(simulated_data$pollster %in% valid_pollsters)) {
  message("Test Passed: The 'pollster' column contains only valid pollster names.")
} else {
  stop("Test Failed: The 'pollster' column contains invalid pollster names.")
}

# Check if 'recency' is calculated correctly and is non-negative
if (all(simulated_data$recency >= 0)) {
  message("Test Passed: The 'recency' column values are non-negative.")
} else {
  stop("Test Failed: The 'recency' column contains negative values.")
}

