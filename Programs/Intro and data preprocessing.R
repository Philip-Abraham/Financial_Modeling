## Exploring the credit data
# After being given loan_data, you are particularly interested about the defaulted 
# loans in the data set. You want to get an idea of the number, and percentage of 
# defaults. Defaults are rare, so you always want to check what the proportion of 
# defaults is in a loan dataset. 

# Loan Data
loan_data <- readRDS("loan_data_ch1.rds")
# Default information is stored in the response variable loan_status, where 1 
# represents a default, and 0 represents non-default

# View the structure of loan_data
str(loan_data)

# Load the gmodels package 
library(gmodels)

# Call CrossTable() on loan_status
CrossTable(loan_data$loan_status)

# Call CrossTable() with x argument loan_data$grade and 
# y argument loan_data$loan_status. We only want row-wise proportions, 
# so set prop.r to TRUE, but prop.c , prop.t and prop.chisq to FALSE (default 
# values here are TRUE, and this would lead to inclusion of column proportions, 
# table proportions and chi-square contributions for each cell. We do not need 
# these here.)
CrossTable(loan_data$grade, loan_data$loan_status, prop.r = TRUE, 
           prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# The proportion of defaults increase with worse credit scores


## Histograms
# Explore continuous variables to identify potential outliers or unexpected data 
# structures

# Create histogram of loan_amnt: hist_1
hist_1 <- hist(loan_data$loan_amnt)

# Print locations of the breaks in hist_1
# Knowing the location of the breaks is important because if they are poorly 
# chosen, the histogram may be misleading
hist_1$breaks

# Change number of breaks and add labels: hist_2
hist_2 <- hist(loan_data$loan_amnt, breaks = 200, xlab = "Loan amount", 
               main = "Histogram of the loan amount")
# Note that there are some high peaks at round values: 5000, 10000, 15000,...
# People tend to borrow round numbers


## Outliers
# Now it's time to look at the structure of the variable age
hist(loan_data$age)
# There is a lot of blank space on the right-hand side of the plot. This is an 
# indication of possible outliers. You will look at a scatterplot to verify this. 
# If you find any outliers you will delete them

# Plot the age variable
plot(loan_data$age, ylab="Age")
# The oldest person in this data set is older than 122 years!

# The oldest person in this data set is older than 122 years! Get the index of this outlier
# Save the outlier's index to index_highage
index_highage <- which(loan_data$age > 122)

# Create data set new_data with outlier deleted
new_data <- loan_data[-index_highage, ]

# Make bivariate scatterplot of age and annual income
plot(loan_data$age, loan_data$annual_inc, xlab = "Age", ylab = "Annual Income")
# The person with the huge annual wage of $6 million appeared to be 144 years old. 
# This must be a mistake, so you will definitely delete this observation from the data


## Deleting missing data
# You saw before that the interest rate (int_rate) in the data set loan_data 
# depends on the customer. Unfortunately some observations are missing interest 
# rates. You now need to identify how many interest rates are missing and then 
# delete them

# Look at summary of loan_data
summary(loan_data$int_rate)

# Get indices of missing interest rates: na_index
na_index <- which(is.na(loan_data$int_rate))

# Remove observations with missing interest rates: loan_data_delrow_na
loan_data_delrow_na <- loan_data[-c(na_index), ]

# Make copy of loan_data
loan_data_delcol_na <- loan_data

# Delete interest rate column from loan_data_delcol_na
loan_data_delcol_na$int_rate <- NULL


## Replacing missing data
# Rather than deleting the missing interest rates, you may want to replace them instead

# Compute the median of int_rate
median_ir <- median(loan_data$int_rate, na.rm = TRUE)

# Make copy of loan_data
loan_data_replace <- loan_data

# Replace missing interest rates with median
loan_data_replace$int_rate[na_index] <- median_ir

# Check if the NAs are gone
summary(loan_data_replace$int_rate)


## Keeping missing data
# In some situations, the fact that an input is missing is important information 
# in itself. NAs can be kept in a separate "missing" category using coarse 
# classification.
# Coarse classification allows you to simplify your data and improve the 
# interpretability of your model. Coarse classification requires you to bin your 
# responses into groups that contain ranges of values. You can use this binning 
# technique to place all NAs in their own bin.

# Coarse Classification
loan_data$ir_cat <- rep(NA, length(loan_data$int_rate))

loan_data$ir_cat[which(loan_data$int_rate <= 8)] <- "0-8"
loan_data$ir_cat[which(loan_data$int_rate > 8 & loan_data$int_rate <= 11)] <- "8-11"
loan_data$ir_cat[which(loan_data$int_rate > 11 & loan_data$int_rate <= 13.5)] <- "11-13.5"
loan_data$ir_cat[which(loan_data$int_rate > 13.5)] <- "13.5+"
loan_data$ir_cat[which(is.na(loan_data$int_rate))] <- "Missing"

loan_data$ir_cat <- as.factor(loan_data$ir_cat)

# Look at your new variable using plot()
plot(loan_data$ir_cat)


## Splitting the data set - training and test sets

# Set seed of 567
set.seed(567)

# Store row numbers for training set: index_train
index_train <- sample(1:nrow(loan_data), 2 / 3 * nrow(loan_data))

# Create training set: training_set
training_set <- loan_data[index_train, ]

# Create test set: test_set
test_set <- loan_data[-index_train, ]


## Creating a confusion matrix
# Since we don't have a model yet to run for prediction we will for now artificially
# create test results.
set.seed(567)
model_pred <- abs(round(rnorm(nrow(test_set),sd=.35),0))

# Create confusion matrix
conf_matrix <- table(test_set$loan_status, model_pred)
conf_matrix

# Compute classification accuracy
(conf_matrix[1,1]+conf_matrix[2,2])/
  (conf_matrix[1,1]+conf_matrix[1,2]+conf_matrix[2,1]+conf_matrix[2,2])

# Compute sensitivity - (percentage accuracy of defaulters)
(conf_matrix[2,2])/
  (conf_matrix[2,1]+conf_matrix[2,2])
