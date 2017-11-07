## Introducing getSymbols()
# By default, getSymbols() imports the data as a xts object
# You will use it to import QQQ data from Yahoo! Finance. QQQ is an 
# exchange-traded fund that tracks the Nasdaq 100 index, and Yahoo! Finance is 
# the default data source for getSymbols().

# Load the quantmod package
library(quantmod)

# Import QQQ data from Yahoo! Finance
getSymbols(Symbols = "QQQ", src = "yahoo", auto.assign = TRUE)

# Look at the structure of the object getSymbols created
str(QQQ)

# Look at the first few rows of QQQ
head(QQQ)

# Look at the last few rows of QQQ
tail(QQQ)


## Data Sources
# In this exercise, you will import data from Google Finance and FRED. Google 
# Finance is a source similar to Yahoo! Finance. FRED is an online database of 
# economic time series data created and maintained by the Federal Reserve Bank of 
# St. Louis.

# Import QQQ data from Google Finance
getSymbols(Symbols = "QQQ", src = "google", auto.assign = TRUE)

# Look at the structure of QQQ
str(QQQ)

# Import GDP data from FRED
getSymbols(Symbols = "GDP", src = "FRED", auto.assign = TRUE)

# Look at the structure of GDP
str(GDP)


## Make getSymbols() return the data it retrieves
# getSymbols() automatically created an object for you, based on the symbol you 
# provided. Sometimes you may want to assign the data to an object yourself, 
# so you need getSymbols() to return the data instead. Two ways of doing that.

# Load the quantmod package
library(quantmod)

# Assign SPY data to 'spy' using auto.assign argument
spy <- getSymbols(Symbols = "SPY", auto.assign = FALSE)

# Look at the structure of the 'spy' object
str(spy)

# Assign JNJ data to 'jnj' using env argument
jnj <- getSymbols(Symbols = "JNJ", env = NULL)

# Look at the structure of the 'jnj' object
str(jnj)


## Introducing Quandl()
# Quandl package provides access to the Quandl databases via one simple 
# function: Quandl(). 
# Quandl() returns a data.frame by default, and 
# Quandl() will not automatically assign the data to an object.

# Load the Quandl package
library(Quandl)
Quandl.api_key("aCdxyYPJkbyix_csKqW8")

# Import GDP data from FRED
gdp <- Quandl(code = "FRED/GDP")

# Look at the structure of the object returned by Quandl
str(gdp)


## Return data type
# The Quandl() function returns a data.frame by default, but it can return other 
# object classes too. "raw" (a data.frame),
# "ts" (time-series objects from the stats package),
# "zoo",
# "xts", and
# "timeSeries"

# Import GDP data from FRED as xts
gdp_xts <- Quandl(code = "FRED/GDP", type = "xts")

# Look at the structure of gdp_xts
str(gdp_xts)

# Import GDP data from FRED as zoo
gdp_zoo <- Quandl(code = "FRED/GDP", type = "zoo")

# Look at the structure of gdp_zoo
str(gdp_zoo)


## Find stock ticker from Google Finance
# Before you can import data from any internet data source, you need to know the 
# instrument identifier. These can generally be found on the website of the data 
# source provider. In this exercise, you'll need to search Google Finance to find 
# the ticker symbol for Pfizer stock. Looking up instrument identifiers online 
# will be important when you want to work with data from a new instrument.
# Note that some data series may not be available for download from certain 
# providers. This may be true even if you can see the data displayed on their 
# website in tables and/or charts. getSymbols() will throw an error if the data 
# is not available for download.

# Create an object containing the Pfizer ticker symbol
symbol <- "PFE"

# Use getSymbols to import the data
getSymbols(Symbols = symbol, src = "google", auto.assign = TRUE)

# Look at the first few rows of data
head(PFE)


## Download exchange rate data from Oanda
# Oanda.com provides historical foreign exchange data for many currency pairs. 

# List of currencies provided by Oanda.com
quantmod::oanda.currencies

# Create a currency_pair object
currency_pair <- "GBP/CAD"

# Load British Pound to Canadian Dollar exchange rate data
getSymbols(currency_pair,src="oanda")

# Examine object using str()
str(GBPCAD)

# Oanda only provides historical data for the past 180 days
# Try to load data from 190 days ago
getSymbols(currency_pair, from = Sys.Date() - 190, to = Sys.Date(), src = "oanda")


## Find and download US Civilian Unemployment Rate data from FRED
# In this exercise, you will find the FRED symbol for the United States civilian 
# unemployment rate. Then you will use the series name to download the data directly 
# from FRED

# Assign the FRED series name to an object called series_name. To find the FRED 
# series name, go to the FRED website and search for "United States civilian 
# unemployment rate"
series_name <- "UNRATE"

# Load the data using getSymbols
library(quantmod)
getSymbols(Symbols = series_name, src = "FRED")

# Create a quandl_code object
quandl_code <- "FRED/UNRATE"

# Load the data using Quandl
library(Quandl)
unemploy_rate <- Quandl(code = quandl_code)
