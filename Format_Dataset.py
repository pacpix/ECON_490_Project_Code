"""
Format_Dataset.py
Purpose: Takes Yahoo finance closing prices csv and creates a new CSV to use for R data analysis
Last Edit: 3/27/2019 Justin Stachofsky
"""

# Library imports
import csv      # Python CSV functionalities

# File Imports
from DataPoint import DataPoint

# Handle program flow
def main():
    
     datapoints = create_datapoint_objects()

     for datapoint in datapoints:
        print(datapoint.efx_close + " " + datapoint.spy_close + " "+ datapoint.tru_close + " " + datapoint.date)

def create_datapoint_objects():
    
    with open("Yahoo_Finance_Export.csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter =',')
        datapoint_list = []

        for row in csv_reader:
            datapoint = DataPoint(row[0], row[1], row[2], row[3])
            datapoint_list.append(datapoint)

    return datapoint_list

# Start program exection at main 
if __name__== "__main__":
  main()

