#### Preamble ####
# Purpose: Model Harris's support in the 2024 U.S. presidential election using weighted and unweighted linear models.
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Cleaned data file `cleaned_harris_support.csv` should be available in the `data/02-analysis_data/` directory.


#### Load cleaned data ####
library(dplyr)

# Load Harris and Trump data
<<<<<<< HEAD
harris_data <- read.csv("data/02-analysis_data/analysis_data_Harris.csv")
trump_data <- read.csv("data/02-analysis_data/analysis_data_Trump.csv")
=======
>>>>>>> cce7356b4f7dc558466790ee5c1f91e6d51efaad
harris_data <- read_parquet("data/02-analysis_data/analysis_data_Harris.parquet")
trump_data <- read_parquet("data/02-analysis_data/analysis_data_Trump.parquet")

#### Calculate Weights ####
# Calculate weights for Harris data
harris_data <- harris_data %>%
  mutate(
    sample_size_weight = pmin(sample_size / 2300, 1),
<<<<<<< HEAD
    pollster_quality_weight = numeric_grade / 4
=======
>>>>>>> cce7356b4f7dc558466790ee5c1f91e6d51efaad
    pollster_quality_weight = numeric_grade / 4,
    recency_weight = exp(-recency * 0.1)
  ) %>%
  group_by(pollster) %>%
  mutate(
    recent_poll_count = sum(recency < 30),
    poll_frequency_weight = ifelse(recent_poll_count > 4, 4 / recent_poll_count, 1)
  ) %>%
  ungroup() %>%
<<<<<<< HEAD
  mutate(combined_weight = recency * sample_size_weight * poll_frequency_weight * pollster_quality_weight)
=======
>>>>>>> cce7356b4f7dc558466790ee5c1f91e6d51efaad
  mutate(combined_weight = recency_weight * sample_size_weight * poll_frequency_weight * pollster_quality_weight)

# Calculate weights for Trump data
trump_data <- trump_data %>%
  mutate(
    sample_size_weight = pmin(sample_size / 2300, 1),
<<<<<<< HEAD
    pollster_quality_weight = numeric_grade / 4
=======
>>>>>>> cce7356b4f7dc558466790ee5c1f91e6d51efaad
    pollster_quality_weight = numeric_grade / 4,
    recency_weight = exp(-recency * 0.1)
  ) %>%
  group_by(pollster) %>%
  mutate(
    recent_poll_count = sum(recency < 30),
    poll_frequency_weight = ifelse(recent_poll_count > 4, 4 / recent_poll_count, 1)
  ) %>%
  ungroup() %>%
  mutate(combined_weight = recency_weight * sample_size_weight * poll_frequency_weight * pollster_quality_weight)

<<<<<<< HEAD
#### Model Preparation ####
# Define selected states for filtering
selected_states <- c("Pennsylvania", "Nevada", "North Carolina", "Wisconsin", "Michigan", "Georgia", "Arizona")
  mutate(combined_weight = recency_weight * sample_size_weight * poll_frequency_weight * pollster_quality_weight)

# Filter Harris and Trump data by selected states
harris_data <- harris_data %>%
  filter(state %in% selected_states, !is.na(combined_weight))

trump_data <- trump_data %>%
  filter(state %in% selected_states, !is.na(combined_weight))
=======
>>>>>>> cce7356b4f7dc558466790ee5c1f91e6d51efaad

#### Build Models ####
# 1. Unweighted model for Harris
model_harris_unweighted <- lm(pct ~ national_poll + pollster + population, data = harris_data)

# 2. Weighted model for Harris
model_harris_weighted <- lm(pct ~ national_poll + pollster + population, data = harris_data, weights = combined_weight)

# 3. Unweighted model for Trump
model_trump_unweighted <- lm(pct ~ national_poll + pollster + population, data = trump_data)

# 4. Weighted model for Trump
model_trump_weighted <- lm(pct ~ national_poll + pollster + population, data = trump_data, weights = combined_weight)

#### Save Models ####
saveRDS(model_harris_unweighted, "models/model_harris_unweighted.rds")
saveRDS(model_harris_weighted, "models/model_harris_weighted.rds")
saveRDS(model_trump_unweighted, "models/model_trump_unweighted.rds")
saveRDS(model_trump_weighted, "models/model_trump_weighted.rds")

