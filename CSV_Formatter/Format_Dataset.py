"""
Format_Dataset.py
Purpose: Takes Yahoo finance closing prices csv and creates a new CSV to use for R data analysis
Last Edit: 5/2/2019 Justin Stachofsky
"""

# Library imports
import csv                          # Python CSV library
import sys                          # sys used for CLI arguments and error messages

# File Imports
from DataPoint import DataPoint     # DataPoint class file

# Handle program flow
def main():
    
    # Checking for valid CLI argument
    if (sys.argv[1] != 'spy') and (sys.argv[1] !=  'tru'):
        sys.exit("Invalid input, please use 'spy' or 'tru'")

    # Create list of DataPoint objects
    datapoints = create_datapoint_objects('Yahoo_Finance_Export.csv')

    # Create new CSV from DataPoint objects
    create_new_csv(datapoints, sys.argv[1])


# Returns a list of DataPoint objects for a CSV file
def create_datapoint_objects(csv_name):
    
    with open(csv_name) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter = ',')
        datapoint_list = []

        for row in csv_reader:
            datapoint = DataPoint(row[0], row[1], row[2], row[3], row[4], row[5], row[6])
            datapoint_list.append(datapoint)

    return datapoint_list

# Creates a new CSV with individual line for Equifax stock and control stock per date
# Unformatted CSV has all stocks on one date line
def create_new_csv(datapoints, stock):

    with open('Formatted_Export_' + stock + '.csv', mode = 'w') as csv_file:
        csv_writer = csv.writer(csv_file, delimiter = ',', quotechar = '"', quoting = csv.QUOTE_MINIMAL)
        
        # Write header row
        csv_writer.writerow(['Date', 'Close_Price', 'Percent_Change', 'Equifax'])

        # Data starts at row 2
        i = 2

        # Iterate through objects and create rows in new csv
        # Create row for EFX, and row for either SPY or TRU depending on parameter
        while i < len(datapoints):
            csv_writer.writerow([datapoints[i].date, datapoints[i].efx_close, datapoints[i].efx_percent, 1])
            if stock == 'spy':
                csv_writer.writerow([datapoints[i].date, datapoints[i].spy_close, datapoints[i].spy_percent, 0])
            elif stock == 'tru':
                csv_writer.writerow([datapoints[i].date, datapoints[i].tru_close, datapoints[i].tru_percent, 0])
            i+=1

# Start program exection at main 
if __name__== "__main__":
  main()

