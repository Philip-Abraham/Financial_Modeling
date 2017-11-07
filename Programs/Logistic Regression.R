# After being given loan_data, you are particularly interested about the defaulted 
# loans in the data set. You want to get an idea of the number, and percentage of 
# defaults. Defaults are rare, so you always want to check what the proportion of 
# defaults is in a loan dataset. 

# Loan Data
loan_data <- readRDS("loan_data_ch2.rds")
# Default information is stored in the response variable loan_status, where 1 
# represents a default, and 0 represents non-default

# ## Splitting the data set - training and test sets
# Set seed of 567
set.seed(567)

# Store row numbers for training set: index_train
index_train <- sample(1:nrow(loan_data), 2 / 3 * nrow(loan_data))

# Create training set: training_set
training_set <- loan_data[index_train, ]

# Create test set: test_set
test_set <- loan_data[-index_train, ]


## Basic logistic regression
# Build a glm model with variable ir_cat as a predictor
log_model_cat <- glm(loan_status ~ ir_cat, family = "binomial", data = training_set)

# Print the parameter estimates 
log_model_cat
# For the interest rates that are between 8% and 11% compared to the reference 
# category with interest rates between 0% and 8%, the odds in favor of default 
# change by a multiple of (e^0.5414) = 1.718

# Look at the different categories in ir_cat using table()
table(loan_data$ir_cat)


## Multiple variables in a logistic regression model
# The interpretation of a single parameter still holds when including several 
# variables in a model. When you do include several variables and ask for the 
# interpretation when a certain variable changes, it is assumed that the other 
# variables remain constant, or unchanged.

# Build the logistic regression model
log_model_multi <- glm(loan_status ~ age+ir_cat+grade+loan_amnt+annual_inc, 
                       family = "binomial", data = training_set)

# Obtain significance levels using summary()
summary(log_model_multi)
# The parameter estimates for loan_amount and annual_inc are Of the same order, 
# however, annual_inc is statistically significant where loan_amount is not


## Predicting the probability of default
# After having obtained all the predictions for the test set elements, it is 
# useful to get an initial idea of how good the model is at discriminating by 
# looking at the range of predicted probabilities. A small range means that 
# predictions for the test set cases do not lie far apart, and therefore the model 
# might not be very good at discriminating good from bad customers. 
# With low default percentages, you will notice that in general, very low 
# probabilities of default are predicted. 
log_model_small <- glm(loan_status ~ age+ir_cat, family = "binomial", 
                       data = training_set)
# Obtain significance levels using summary()
summary(log_model_small)

# Build the logistic regression model
predictions_all_small <- predict(log_model_small, newdata = test_set, 
                                 type = "response")

# Look at the range of the object "predictions_all_small"
range(predictions_all_small)
# The range for predicted probabilities of default was rather small

## Making more discriminative models
# Building bigger models (which basically means: including more predictors) can 
# expand the range of your predictions. Whether this will eventually lead to better 
# predictions still needs to be validated and depends on the quality of the newly 
# included predictors

# construct a logistic regression model using all available predictors in the data set
log_model_full <- glm(loan_status ~ ., family = "binomial", data = training_set)

# Make PD-predictions for all test set elements using the the full logistic regression model
predictions_all_full <- predict(log_model_full, newdata = test_set, 
                                type = "response")

# Look at the predictions range
range(predictions_all_full)


## Specifying a cut-off
# The way you specify a probability cut-off can make the difference in obtaining a 
# good confusion matrix

# cut-off of 15%
# Make a binary predictions-vector using a cut-off of 15%
pred_cutoff_15 <- ifelse(predictions_all_full > 0.15, 1, 0)

# Construct a confusion matrix
conf_matrix_15 <- table(test_set$loan_status,pred_cutoff_15)

# cut-off of 20%
# Make a binary predictions-vector using a cut-off of 15%
pred_cutoff_20 <- ifelse(predictions_all_full > 0.20, 1, 0)

# Construct a confusion matrix
conf_matrix_20 <- table(test_set$loan_status,pred_cutoff_20)


## Comparing two cut-offs 15% and 20%

# 15%
# Compute classification accuracy
AC15 <- (conf_matrix_15[1,1]+conf_matrix_15[2,2])/
  (conf_matrix_15[1,1]+conf_matrix_15[1,2]+conf_matrix_15[2,1]+conf_matrix_15[2,2])
# Compute Sensitivity - (percentage accuracy of defaulters)
SE15 <- (conf_matrix_15[2,2])/
  (conf_matrix_15[2,1]+conf_matrix_15[2,2])
# Compute Specificity - (percentage accuracy of non-defaulters)
SP15 <- (conf_matrix_15[1,1])/
  (conf_matrix_15[1,1]+conf_matrix_15[1,2])

# 20%
# Compute classification accuracy
AC20 <- (conf_matrix_20[1,1]+conf_matrix_20[2,2])/
  (conf_matrix_20[1,1]+conf_matrix_20[1,2]+conf_matrix_20[2,1]+conf_matrix_20[2,2])
# Compute Sensitivity - (percentage accuracy of defaulters)
SE20 <- (conf_matrix_20[2,2])/
  (conf_matrix_20[2,1]+conf_matrix_20[2,2])
# Compute Specificity - (percentage accuracy of non-defaulters)
SP20 <- (conf_matrix_20[1,1])/
  (conf_matrix_20[1,1]+conf_matrix_20[1,2])

# Summary
df <- data.frame(Accuracy = c(AC15,AC20), Sensitivity = c(SE15,SE20),
           Specificity = c(SP15, SP20))
row.names(df) <- c("15%", "20%")
df
# Moving from a cut-off of 15% to 20%:
# Accuracy increases, sensitivity decreases and specificity increases


## Comparing link functions for a given cut-off
# You will fit a model using each of the three link functions (logit, probit and 
# cloglog), make predictions for the test set, classify the predictions in the 
# appropriate group (default versus non-default) for a given cut-off, make a 
# confusion matrix and compute the accuracy and sensitivity for each of the models 
# given the cut-off value. And finally, you will try to identify the model that 
# performs best in terms of accuracy given the cut-off value.

# Fit the logit, probit and cloglog-link logistic regression models
log_model_logit <- glm(loan_status ~ age + emp_cat + ir_cat + loan_amnt,
                       family = binomial(link = logit), data = training_set)
log_model_probit <- glm(loan_status ~ age + emp_cat + ir_cat + loan_amnt,
                        family = binomial(link = probit), data = training_set)

log_model_cloglog <-  glm(loan_status ~ age + emp_cat + ir_cat + loan_amnt,
                          family = binomial(link = cloglog), data = training_set)

# Make predictions for all models using the test set
predictions_logit <- predict(log_model_logit, newdata = test_set, type = "response")
predictions_probit <- predict(log_model_probit, newdata = test_set, type = "response")
predictions_cloglog <- predict(log_model_cloglog, newdata = test_set, type = "response")

# Use a cut-off of 14% to make binary predictions-vectors
cutoff <- 0.14
class_pred_logit <- ifelse(predictions_logit > cutoff, 1, 0)
class_pred_probit <- ifelse(predictions_probit > cutoff, 1, 0)
class_pred_cloglog <- ifelse(predictions_cloglog > cutoff, 1, 0)

# Make a confusion matrix for the three models
true_val <- test_set$loan_status
tab_class_logit <- table(true_val,class_pred_logit)
tab_class_probit <- table(true_val,class_pred_probit)
tab_class_cloglog <- table(true_val,class_pred_cloglog)

# Compute the classification accuracy for all three models
acc_logit <- sum(diag(tab_class_logit)) / nrow(test_set)
acc_probit <- sum(diag(tab_class_probit)) / nrow(test_set)
acc_cloglog <- sum(diag(tab_class_cloglog)) / nrow(test_set)

acc_logit
acc_probit
acc_cloglog
