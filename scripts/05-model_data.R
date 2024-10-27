#### Preamble ####
# Purpose: Model Harris's support in the 2024 U.S. presidential election using weighted and unweighted linear models.
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Cleaned data file `cleaned_harris_support.csv` should be available in the `data/02-analysis_data/` directory.

#### Workspace setup ####
library(dplyr)
library(ggplot2)
library(lubridate)

#### Step 1: Load cleaned data ####
data <- read.csv("data/02-analysis_data/cleaned_harris_support.csv")

# Ensure `end_date` exists and is in Date format or set it to today's date if missing
if (!"end_date" %in% names(data)) {
  data$end_date <- Sys.Date()
} else {
  data$end_date <- as.Date(data$end_date)
}
data <- data %>% filter(!is.na(end_date))

#### Step 2: Calculate weights ####
# 2.1 Recency Weight
data <- data %>%
  mutate(
    days_since_poll = as.numeric(difftime(Sys.Date(), end_date, units = "days")),
    recency_weight = ifelse(days_since_poll < 30, exp(-days_since_poll / 15), exp(-days_since_poll / 30))
  )

# 2.2 Sample Size Weight (cap at 2,300 responses)
data <- data %>%
  mutate(sample_size_weight = pmin(sample_size / 2300, 1))

# 2.3 Poll Frequency by Pollster
data <- data %>%
  group_by(pollster) %>%
  mutate(
    recent_poll_count = sum(days_since_poll < 30),
    poll_frequency_weight = ifelse(recent_poll_count > 4, 4 / recent_poll_count, 1)
  ) %>%
  ungroup()

# 2.4 Pollster Quality Weight
data <- data %>%
  mutate(pollster_quality_weight = numeric_grade / 4)


# 2.5 Combined Weight
data <- data %>%
  mutate(combined_weight = recency_weight * sample_size_weight * poll_frequency_weight * pollster_quality_weight)

# Verify combined weight creation
if (!"combined_weight" %in% names(data)) {
  stop("Error: `combined_weight` was not created successfully.")
}

#### Step 3: Model preparation ####
# Filter to ensure no missing values in key columns
data <- data %>% filter(!is.na(pct), !is.na(recency_weight), !is.na(sample_size_weight), !is.na(numeric_grade))

# Select specific states for analysis (modify states as needed)
selected_states <- c("Pennsylvania", "Nevada", "North Carolina", "Wisconsin", "Michigan", "Georgia", "Arizona")
data <- data %>% filter(state %in% selected_states)

#### Step 4: Check for Multicollinearity ####
# Calculate correlation matrix to check for highly correlated predictors
correlation_matrix <- cor(data %>% select(national_poll, recency_weight, sample_size_weight, numeric_grade, poll_frequency_weight, pollster_quality_weight))

# If necessary, remove or modify predictors based on high correlations (0.8 or higher)

#### Step 5: Build Models ####
# 5.1 Unweighted Linear Model
model_unweighted <- lm(pct ~ national_poll + recency_weight + sample_size_weight + numeric_grade, data = data)

# 5.2 Weighted Linear Model
model_weighted <- lm(pct ~ national_poll + recency_weight + sample_size_weight + numeric_grade, 
                     data = data, weights = combined_weight)

#### Step 6: Generate Predictions ####
# Predictions for unweighted model
data$pred_unweighted <- predict(model_unweighted, newdata = data)

# Predictions for weighted model
data$pred_weighted <- predict(model_weighted, newdata = data)


#### Step 7: Save Models ####
# Save unweighted model
saveRDS(model_unweighted, file = "models/model_unweighted.rds")

# Save weighted model
saveRDS(model_weighted, file = "models/model_weighted.rds")
