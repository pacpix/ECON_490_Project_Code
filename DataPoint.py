"""
DataPoint.py
Class for DataPoints from stock CSV
Last Edit: 3/28/2019 Justin Stachofsky

"""

class DataPoint:
    
    # Constructor
    def __init__(self, date, efx_close, spy_close, tru_close):
        self.date = date
        self.efx_close = efx_close
        self.spy_close = spy_close
        self.tru_close = tru_close

    
