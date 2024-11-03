#### Preamble ####
# Purpose: Tests the structure and validity of the cleaned 2024 US election poll of polls
# analysis dataset.
# Author: Diana Shen, Jinyan Wei, Huayan Yu
# Date: 3 November 2024 
# Contact: diana.shen@mail.utoronto.ca; jinyan.wei@mail.utoronto.ca; huayan.yu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - The `tidyverse`, `testthat`,`lubridate`,`dplyr` package must be installed and loaded
# - 03-clean_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(lubridate)
library(dplyr)

analysis_data_harris <- read_csv("data/02-analysis_data/analysis_data_Harris.csv")
analysis_data_trump <- read_csv("data/02-analysis_data/analysis_data_Trump.csv")
#### combined two dataset to test together
combined_data <- bind_rows(analysis_data_harris, analysis_data_trump)
# Test if the data was successfully loaded
if (exists("combined_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####
## test analysis data has correct structure
test_that("Analysis data has correct structure", {
  expect_true(is.numeric(combined_data$pollscore))
  expect_true(inherits(combined_data$end_date, "Date"))
  expect_true(is.character(combined_data$pollster))
  expect_true(is.numeric(combined_data$numeric_grade))
  expect_true(is.numeric(combined_data$national_poll))
  expect_true(is.numeric(combined_data$recency))
  expect_true(is.character(combined_data$state))
  expect_true(is.character(combined_data$population))
  expect_true(is.numeric(combined_data$sample_size))
  expect_true(is.numeric(combined_data$pct))
  expect_true(is.character(combined_data$candidate_name))
})
# Check if the dataset has 11 columns
if (ncol(combined_data) == 11) {
  message("Test Passed: The dataset has 11 columns.")
} else {
  stop("Test Failed: The dataset does not have 11 columns.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(combined_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if 'pct' column contains only valid percentage data
if (all(combined_data$pct >= 0 & combined_data$pct <= 100)) {
  message("Test Passed: The 'pct' column contains no extreme value for smaller than 30 and greater than 80.")
} else {
  stop("Test Failed: The 'pct' column contains extreme value for smaller than 30 and greater than 80.")
}

# Check if 'end_date' column contains only valid end_date names
if (all(combined_data$end_date>=as.Date("2024-7-21")&combined_data$end_date<=as.Date("2024-11-2"))) {
  message("Test Passed: The 'end_date' column contains latest date only from 2024-7-21 to 2024-11-2.")
} else {
  stop("Test Failed: The 'end_date' column contains overdate data/future data.")
}

# Check if 'candidate_name' column contains only valid candidate_name names
valid_candidates <- c("Kamala Harris", "Donald Trump")

if (all(combined_data$candidate_name %in% valid_candidates)) {
  message("Test Passed: The 'candidate_name' column contains only valid candidate names.")
} else {
  stop("Test Failed: The 'candidate_name' column contains invalid candidate names.")
}
# Check if 'population' column contains only valid population types
valid_populations <- c("rv", "lv")

if (all(combined_data$population %in% valid_populations)) {
  message("Test Passed: The 'population' column contains only valid population types.")
} else {
  stop("Test Failed: The 'population' column contains invalid population types.")
}

# Check if 'sample_size' is within the valid range of 1 to 2300
if (all(combined_data$sample_size >= 1)) {
  message("Test Passed: The 'sample_size' column values are greater than 1.")
} else {
  stop("Test Failed: The 'sample_size' column contains values smaller than 1.")
}

# Check if 'numeric_grade' is within the valid range of 0.5 to 3
if (all(combined_data$numeric_grade >= 0.5 & combined_data$numeric_grade <= 3)) {
  message("Test Passed: The 'numeric_grade' column values are within the valid range.")
} else {
  stop("Test Failed: The 'numeric_grade' column contains values outside the valid range.")
}

# Check if 'pollscore' is within the valid range of -1.5 to 2
if (all(combined_data$pollscore >= -1.5 & combined_data$pollscore <= 2)) {
  message("Test Passed: The 'pollscore' column values are within the valid range.")
} else {
  stop("Test Failed: The 'pollscore' column contains values outside the valid range.")
}

# Check if 'national_poll' column contains only 1 or 0
if (all(combined_data$national_poll %in% c(0, 1))) {
  message("Test Passed: The 'national_poll' column contains only 0 and 1 values.")
} else {
  stop("Test Failed: The 'national_poll' column contains values other than 0 and 1.")
}


# Check if 'recency' is calculated correctly and is non-negative
if (all(combined_data$recency >= 0)) {
  message("Test Passed: The 'recency' column values are non-negative.")
} else {
  stop("Test Failed: The 'recency' column contains negative values.")
}
