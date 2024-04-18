#### Preamble ####
# Purpose: Tests the proccessed IDMC data [IDMC_processed.csv found in Data file]
# Author: Rayan Awad Alim
# Date: 18 April 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: N/A


#### Workspace setup ####

# Install Packages if not downloaded:
install_if_missing <- function(package_name) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    install.packages(package_name)
    suppressMessages(library(package_name, character.only = TRUE))
  }
}

install_if_missing("ggplot2")
install_if_missing("skimr")
install_if_missing("factoextra")
install_if_missing("corrplot")
install_if_missing("tidyr")

#Load 
library(ggplot2)
library(skimr)
library(factoextra)
library(corrplot)

# Load Data
data <- read.csv(here("data", "analysis_data", "IDMC_processed.csv"))


#### Test data ####

# View the structure of the dataset
str(data)

# Check for missing values in the dataset
sum(is.na(data))

# Check for duplicate rows
anyDuplicated(data)

# Check duplicates for a specific key
anyDuplicated(data[c("ISO3", "Year")])

# Check if any internal displacement figures are greater than the total stock displacement
with(data, any(Conflict_Internal_Displacements_Raw > Conflict_Stock_Displacement_Raw | Disaster_Internal_Displacements_Raw > Disaster_Stock_Displacement_Raw))

# Check displacements are not be negative
with(data, any(Conflict_Stock_Displacement_Raw < 0, Disaster_Stock_Displacement_Raw < 0))

# Check if Year is within expected range
with(data, any(Year < 1990 | Year > 2023))  # Adjust range as necessary

# Check data types of each column
str(data)

# Convert data types if incorrect
data$Year <- as.integer(data$Year)  # Convert Year to integer if not already
data$ISO3 <- as.factor(data$ISO3)   # Convert ISO3 to factor 


# Descriptive statistics for the dataset
print("Descriptive Statistics:")
summary(data)

# Detailed summary using skimr
print("Detailed Summary:")
skim(data)

# Filter data for Afghanistan as an example
afg_data <- subset(data, ISO3 == "AFG")

# Plotting total displacements over time for Afghanistan
ggplot(afg_data, aes(x = Year, y = Conflict_Stock_Displacement_Raw + Disaster_Stock_Displacement_Raw)) +
  geom_line(group = 1, color = "cyan") +
  labs(title = "Total Displacement in Afghanistan Over Years", x = "Year", y = "Total Displacement")


# Boxplots to visually inspect for outliers
boxplot(data$Conflict_Stock_Displacement_Raw, main = "Conflict Stock Displacement")
boxplot(data$Disaster_Stock_Displacement_Raw, main = "Disaster Stock Displacement")

# Scatter plot for checking trends and anomalies
library(ggplot2)
ggplot(data, aes(x = Year, y = Conflict_Stock_Displacement_Raw, color = ISO3)) +
  geom_point() +
  geom_line() +
  labs(title = "Conflict Stock Displacement Over Years", x = "Year", y = "Displacement")

# Plotting to check consistency in reporting across years
ggplot(data, aes(x = Year, y = Disaster_Stock_Displacement_Raw, color = ISO3)) +
  geom_point() +
  geom_line() +
  labs(title = "Disaster Stock Displacement Over Years", x = "Year", y = "Displacement")

