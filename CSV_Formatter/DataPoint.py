"""
DataPoint.py
Class for DataPoints from stock CSV
Last Edit: 5/2/2019 Justin Stachofsky

"""

class DataPoint:
    
    # Constructor
    def __init__(self, date, efx_close, efx_percent, spy_close, spy_percent, tru_close, tru_percent):
        self.date = date
        self.efx_close = efx_close
        self.efx_percent = efx_percent
        self.spy_close = spy_close
        self.spy_percent = spy_percent
        self.tru_close = tru_close
        self.tru_percent = tru_percent
