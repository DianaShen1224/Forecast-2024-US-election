#### Preamble ####
# Purpose: Model Harris's support in the 2024 U.S. presidential election using weighted and unweighted linear models.
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Cleaned data file `cleaned_harris_support.csv` should be available in the `data/02-analysis_data/` directory.


#### Load cleaned data ####
library(dplyr)
library(arrow)

# Load Harris and Trump data
harris_data <- read_parquet("data/02-analysis_data/analysis_data_Harris.parquet")
trump_data <- read_parquet("data/02-analysis_data/analysis_data_Trump.parquet")

#### Calculate Weights ####
# Calculate weights for Harris data
harris_data <- harris_data %>%
  mutate(
    sample_size_weight = pmin(sample_size / 2300, 1),
    recency_weight = exp(-recency * 0.1)
  )  %>%
  mutate(combined_weight = recency_weight * sample_size_weight)

# Calculate weights for Trump data
trump_data <- trump_data %>%
  mutate(
    sample_size_weight = pmin(sample_size / 2300, 1),
    recency_weight = exp(-recency * 0.1)
  ) %>%
  mutate(combined_weight = recency_weight * sample_size_weight)


#### Build Models ####
# 1. Unweighted model for Harris
model_harris_unweighted <- lm(pct ~ national_poll + pollster + population + state, data = harris_data)

# 2. Weighted model for Harris
model_harris_weighted <- lm(pct ~ national_poll + pollster + population + state, data = harris_data, weights = combined_weight)

# 3. Unweighted model for Trump
model_trump_unweighted <- lm(pct ~ national_poll + pollster + population + state, data = trump_data)

# 4. Weighted model for Trump
model_trump_weighted <- lm(pct ~ national_poll + pollster + population + state, data = trump_data, weights = combined_weight)


#### Save Models ####
saveRDS(model_harris_unweighted, "models/model_harris_unweighted.rds")
saveRDS(model_harris_weighted, "models/model_harris_weighted.rds")
saveRDS(model_trump_unweighted, "models/model_trump_unweighted.rds")
saveRDS(model_trump_weighted, "models/model_trump_weighted.rds")

