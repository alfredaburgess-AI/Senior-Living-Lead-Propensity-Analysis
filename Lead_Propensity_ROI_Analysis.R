#########################################################
# Project: Senior Living Lead Propensity Analysis
# Author: Alfred Burgess
# Purpose: Marketing Channel ROI & Lead Intent Scoring
#
# Public/Portfolio Note:
# - Standardized missing values (NA) to ensure clean categorical summaries.
# - Implemented directory safeguards for reproducibility.
#########################################################

library(tidyverse)

# 1. Load Data with Standardized Missing Values
# Standardizing blanks and "NA" strings as true NA per reviewer feedback
data_path <- "Senior_Living_Lead_Intent_Dataset.csv"
leads_data <- read_csv(data_path, na = c("", "NA"), show_col_types = FALSE)

# 2. Guardrails: Create output directory if it doesn't exist
if (!dir.exists("visuals")) dir.create("visuals", recursive = TRUE)

# 3. Channel Performance Analysis
# Calculating average intent score and sample size (n) per channel
marketing_roi <- leads_data %>%
  group_by(Original_Traffic_Source) %>%
  summarise(
    avg_intent_score = mean(intent_score, na.rm = TRUE),
    lead_count = n(),
    .groups = "drop"
  ) %>%
  filter(!is.na(Original_Traffic_Source)) %>%
  arrange(desc(avg_intent_score))

# 4. Performance Visualization (Channel ROI)
# Using fct_reorder for a clean, descending bar chart
ggplot(marketing_roi, aes(x = reorder(Original_Traffic_Source, avg_intent_score), y = avg_intent_score)) +
  geom_bar(stat = "identity", fill = "#2c3e50") +
  coord_flip() +
  labs(
    title = "Lead Intent Score by Marketing Channel",
    subtitle = "Analysis of 900+ Anonymized CRM Records",
    x = "Marketing Source",
    y = "Average Intent Score (0.0 - 1.0)"
  ) +
  theme_minimal()

# 5. Save Visual for GitHub
ggsave("visuals/intent_by_source_clean.png", width = 8, height = 6)

message("R Script Execution Complete. Visuals saved to /visuals folder.")