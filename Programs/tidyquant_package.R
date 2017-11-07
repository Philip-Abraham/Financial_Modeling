# The tidyquant package is focused on retrieving, manipulating, and scaling 
# financial data analysis in the easiest way possible

library(tidyquant)

# Use the tidyquant function, tq_get() to get the stock price data for Apple.
apple <- tq_get("AAPL", get = "stock.prices", 
                from = "2007-01-03", to = "2017-06-05")

# Take a look at the data frame it returned.
head(apple)

# Plot the stock price over time.
plot(apple$date, apple$adjusted, type = "l")

# Calculate daily returns for the adjusted stock price using tq_mutate(). 
# This function "mutates" your data frame by adding a new column onto it. Here, 
# that new column is the daily returns.
apple <- tq_mutate(data = apple,
                   ohlc_fun = Ad,
                   mutate_fun = dailyReturn)

# Sort the returns from least to greatest
sorted_returns <- sort(apple$daily.returns)

# Plot the sorted returns. You can see that Apple had a few days of losses >10%, 
# and a number of days with gains of >5%.
plot(sorted_returns)
