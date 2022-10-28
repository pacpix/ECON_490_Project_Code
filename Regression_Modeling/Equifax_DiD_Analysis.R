# Equifax_DiD_Analysis.R
# Purpose: Run DiD regressions for Equifax stock data
# Julia Stachofsky


# Package imported for setting working directory
install.packages("rstudioapi")

# Set directory to location of script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Function for configuring dataset dummy variable for simple DiD
configureDatasetOneDiD <- function(csv_name, start_date)
{
  # Import CSV
  stock_data = read.csv(csv_name)
  
  # Create dummy variable for breach announcement
  stock_data$Breach_Announced = ifelse(as.Date(stock_data$Date) >= start_date, 1, 0)
  
  # Interaction term for DiD
  stock_data$BreachDiD = stock_data$Equifax * stock_data$Breach_Announced
  
  return(stock_data)
}

# Function for configuring dataset dummy variables based on desired date ranges for two DiD models
configureDatasetTwoDiD <- function(csv_name, start_date, end_date)
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

# Funcion builds one term difference in difference regression model for dataset
buildRegressionModelOneDiD <- function(dataset)
{
  # lm R function for fitting linear models
  didreg = lm(Close_Price ~ Equifax + Breach_Announced + BreachDiD, data = dataset)
  return(didreg)
}

# Funcion builds two term difference in difference regression model for dataset
buildRegressionModelTwoDiD <- function(dataset)
{
  # lm R function for fitting linear models
  didreg = lm(Close_Price ~ Equifax + Initial_Period + Delayed_Period + InitialDiD + DelayedDiD, data = dataset )
  return(didreg)
}

# Configure datasets for regressions
spy_simple_dataset <- configureDatasetOneDiD("Formatted_Export_spy.csv", as.Date("2017-09-08"))
tru_simple_dataset <- configureDatasetOneDiD("Formatted_Export_tru.csv", as.Date("2017-09-08"))
spy_wk_dataset <- configureDatasetTwoDiD("Formatted_Export_spy.csv", as.Date("2017-09-08"), as.Date("2017-09-15"))
spy_mo_dataset <- configureDatasetTwoDiD("Formatted_Export_spy.csv", as.Date("2017-09-08"), as.Date("2017-10-08"))
tru_wk_dataset <- configureDatasetTwoDiD("Formatted_Export_tru.csv", as.Date("2017-09-08"), as.Date("2017-09-15"))
tru_mo_dataset <- configureDatasetTwoDiD("Formatted_Export_tru.csv", as.Date("2017-09-08"), as.Date("2017-10-08"))

# Create DiD regression models
spy_simple_did <- buildRegressionModelOneDiD(spy_simple_dataset)
tru_simple_did <- buildRegressionModelOneDiD(tru_simple_dataset)
spy_wk_did <- buildRegressionModelTwoDiD(spy_wk_dataset)
spy_mo_did <- buildRegressionModelTwoDiD(spy_mo_dataset)
tru_wk_did <- buildRegressionModelTwoDiD(tru_wk_dataset)
tru_mo_did <- buildRegressionModelTwoDiD(tru_mo_dataset)

# Print summary statistics for regression models
print("SPY Simple")
summary(spy_simple_did)
print("TRU Simple")
summary(tru_simple_did)
print("SPY One Week")
summary(spy_wk_did)
print("SPY One Month")
summary(spy_mo_did)
print("TRU One Week")
summary(tru_wk_did)
print("TRU One Month")
summary(tru_mo_did)

