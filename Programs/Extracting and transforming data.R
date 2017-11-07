## Extract one column from one instrument
# The quantmod package provides several helper functions to extract the open, high, 
# low, close, volume, and adjusted close columns from an object, based on the column name.
# you can learn more about all the extractor functions from:
library(quantmod)
help("OHLC.Transformations")

# In this exercise, you will explore two of these extractor functions by using 
# them on an xts object named DC that contains OHLC (open, high, low, close) data. 
DC <- getSymbols(Symbols = "SPY", auto.assign = FALSE)

# Look at the head of DC
head(DC)

# Extract the close column
dc_close <- Cl(DC)

# Look at the head of dc_close
head(dc_close)

# Extract the volume column
dc_volume <- Vo(DC)

# Look at the head of dc_volume
head(dc_volume)


## Extract multiple columns from one instrument
