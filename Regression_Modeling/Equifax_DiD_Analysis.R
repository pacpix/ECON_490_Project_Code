# Equifax_DiD_Analysis.R
# Purpose: Run DiD regressions for Equifax stock data
# Last Edit: 3/30/2019 Justin Stachofsky


# Package imported for setting working directory
install.packages("rstudioapi")

# Set directory to location of script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Function for configuring dataset dummy variables based on desired date ranges
configureDataset <- function(csv_name, start_date, end_date)
{
  # Import CSV
  stock_data = read.csv(csv_name)
  
  # Create dummy for initial after breach period and dummy for period after
  stock_data$Initial_Period = ifelse(as.Date(stock_data$Date) >= start_date & as.Date(stock_data$Date) <= end_date, 1, 0)
  stock_data$Delayed_Period = ifelse(as.Date(stock_data$Date) > end_date, 1, 0)
  
  # Interaction terms for DiD
  stock_data$InitialDiD = stock_data$Equifax * stock_data$Initial_Period
  stock_data$DelayedDiD = stock_data$Equifax * stock_data$Delayed_Period
  
  return(stock_data)
  
}

# Funcion builds difference in difference regression model for dataset
buildDiDRegressionModel <- function(dataset)
{
  # lm R function for fitting linear models
  didreg = lm(Close.Price ~ Equifax + Initial_Period + Delayed_Period + InitialDiD + DelayedDiD, data = dataset )
  
  return(didreg)
}

# Configure datasets for SPY and TRU regressions
spy_wk_dataset <- configureDataset("Formatted_Export_spy.csv", as.Date("2017-09-07"), as.Date("2017-09-14"))
spy_mo_dataset <- configureDataset("Formatted_Export_spy.csv", as.Date("2017-09-07"), as.Date("2017-10-07"))
tru_wk_dataset <- configureDataset("Formatted_Export_tru.csv", as.Date("2017-09-07"), as.Date("2017-09-14"))
tru_mo_dataset <- configureDataset("Formatted_Export_tru.csv", as.Date("2017-09-07"), as.Date("2017-10-07"))

# Create regression models for SPY and TRU datasets
spy_wk_did <- buildDiDRegressionModel(spy_wk_dataset)
spy_mo_did <- buildDiDRegressionModel(spy_mo_dataset)
tru_wk_did <- buildDiDRegressionModel(tru_wk_dataset)
tru_mo_did <- buildDiDRegressionModel(tru_mo_dataset)

# Print summary statistics for regression models
print("SPY One Week")
summary(spy_wk_did)
print("SPY One Month")
summary(spy_mo_did)
print("TRU One Week")
summary(tru_wk_did)
print("TRU One Month")
summary(tru_mo_did)

