#### Preamble ####
# Purpose: Simulates displacement data by country, year and displacent reason- wither conflict or climate
# Author: Rayan Awad Alim
# Date: 18 April 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A


#### Workspace setup ####
library(tidyverse)
library(dplyr)


#### Simulate data ####

# Load necessary library

# Define a vector of countries and ISO codes
countries <- data.frame(
  ISO3 = c(
    "AFG",
    "BDI",
    "BEN",
    "BGD",
    "BRA",
    "CMR",
    "COD",
    "COL",
    "ETH",
    "GTM",
    "HND"
  ),
  Name = c(
    "Afghanistan",
    "Burundi",
    "Benin",
    "Bangladesh",
    "Brazil",
    "Cameroon",
    "Dem. Rep. Congo",
    "Colombia",
    "Ethiopia",
    "Guatemala",
    "Honduras"
  )
)

# Generate simulated data
set.seed(2312)
simulated_data <-
  expand.grid(ISO3 = countries$ISO3, Year = 2020:2022)
simulated_data <- merge(simulated_data, countries, by = "ISO3")

simulated_data <- simulated_data %>%
  mutate(
    Conflict_Stock_Displacement_Raw = round(runif(n(), 5000, 6000000)),
    Disaster_Stock_Displacement_Raw = round(runif(n(), 5000, 3000000)),
    Conflict_Internal_Displacements_Raw = round(runif(n(), 1000, 4000000)),
    Disaster_Internal_Displacements_Raw = round(runif(n(), 1000, 1500000))
  )

# Calculate total displacements
simulated_data <- simulated_data %>%
  mutate(
    Total_Displacement = Conflict_Stock_Displacement_Raw + Disaster_Stock_Displacement_Raw,
    Displacement_By_Conflict = Conflict_Stock_Displacement_Raw + Conflict_Internal_Displacements_Raw,
    Displacement_By_Disaster = Disaster_Stock_Displacement_Raw + Disaster_Internal_Displacements_Raw
  ) %>%
  select(Name,
         Year,
         Total_Displacement,
         Displacement_By_Conflict,
         Displacement_By_Disaster)

# Print the head of the dataset to check
head(simulated_data)


#### Save Simulated Data ####
write_csv(simulated_data, "data/analysis_data/simulated_data.csv")
