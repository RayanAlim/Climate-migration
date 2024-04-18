#### Preamble ####
# Purpose: Cleans the raw data from the Internal Displacement Monitoring Centre (IDMC) from 2008 to 2022 Data
# Author: Rayan Awad Alim
# Date: 6 April 2023 
# Contact: rayan.alim@utoronto.ca
# License: MIT

#### Workspace setup ####


# Install Packages if not downloaded:
install_if_missing <- function(package_name) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    install.packages(package_name)
    suppressMessages(library(package_name, character.only = TRUE))
  }
}

install_if_missing("readxl")
install_if_missing("here")
install_if_missing("dplyr")
install_if_missing("ggplot2")
install_if_missing("tidyr")
install_if_missing("caret")
install_if_missing("readr")


#Load
library(readxl)
library(here)
library(dplyr)
library(ggplot2)
library(tidyr)
library(caret)
library(readr)


#### Clean data ####

IDMC_raw <-
  read_excel(
    here(
      "data",
      "raw_data",
      "IDMC_Internal_Displacement_Conflict-Violence_Disasters.xlsx"
    )
  )

# Renaming columns to add underscores
IDMC_raw <- IDMC_raw %>%
  rename(
    ISO3 = ISO3,
    Name = Name,
    Year = Year,
    Conflict_Stock_Displacement = `Conflict Stock Displacement`,
    Conflict_Stock_Displacement_Raw = `Conflict Stock Displacement (Raw)`,
    Conflict_Internal_Displacements = `Conflict Internal Displacements`,
    Conflict_Internal_Displacements_Raw = `Conflict Internal Displacements (Raw)`,
    Disaster_Internal_Displacements = `Disaster Internal Displacements`,
    Disaster_Internal_Displacements_Raw = `Disaster Internal Displacements (Raw)`,
    Disaster_Stock_Displacement = `Disaster Stock Displacement`,
    Disaster_Stock_Displacement_Raw = `Disaster Stock Displacement (Raw)`
  )

# Checking for missing values
colSums(is.na(IDMC_raw))

# Removing rows with missing values
IDMC_processed <- na.omit(IDMC_raw)


# Displacement total over the years
year_vec <- unique(IDMC_processed$Year)
sum_df <-
  data.frame(
    Year = integer(),
    Total_Conflict_Displacement = integer(),
    Total_Disaster_Displacement = integer(),
    Total_Displacement = integer()
  )

for (x in year_vec) {
  conf_stock_tot <-
    sum(IDMC_processed$Conflict_Stock_Displacement_Raw[IDMC_processed$Year == x])
  disa_stock_tot <-
    sum(IDMC_processed$Disaster_Stock_Displacement_Raw[IDMC_processed$Year == x])
  total_disp <- conf_stock_tot + disa_stock_tot
  
  
  # Creating a df for the sums
  year_sum_df <- data.frame(
    Year = x,
    Total_Conflict_Displacement = conf_stock_tot,
    Total_Disaster_Displacement = disa_stock_tot,
    Total_Displacement = total_disp
  )
  
  # Merging with sum_df
  sum_df <- rbind(sum_df, year_sum_df)
}


#### Save data ####
write_csv(IDMC_processed, "data/analysis_data/IDMC_processed.csv")
