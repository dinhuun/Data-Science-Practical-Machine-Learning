## Week 4 Quiz
### Question 1
For this quiz we will be using several R packages. R package versions change over time, the right answers have been checked using the following versions of the packages.

AppliedPredictiveModeling: v1.1.6

caret: v6.0.47

ElemStatLearn: v2012.04-0

pgmm: v1.1

rpart: v4.1.8

gbm: v2.1

lubridate: v1.3.3

forecast: v5.6

e1071: v1.6.4

If you aren't using these versions of the packages, your answers may not exactly match the right answer, but hopefully should be close.

Load the vowel.train and vowel.test data sets:
```
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 
```
Set the variable y to be a factor variable in both the training and test set. Then set the seed to 33833. Fit (1) a random forest predictor relating the factor variable y to the remaining variables and (2) a boosted predictor using the "gbm" method. Fit these both with the train() command in the caret package.

What are the accuracies for the two approaches on the test data set? What is the accuracy among the test set samples where the two methods agree?

#### Answer
* <ul type = none>
  <li>RF Accuracy = 0.6082</li>
  <li>GBM Accuracy = 0.5152</li>
  <li>Agreement Accuracy = 0.5325</li>
  </ul>
</br>
* <ul type = none>
  <li>RF Accuracy = 0.9987</li>
  <li>GBM Accuracy = 0.5152</li>
  <li>Agreement Accuracy = 0.9985</li>
  </ul>
</br>
* <ul type = none>
  <li>RF Accuracy = 0.6082</li>
  <li>GBM Accuracy = 0.5152</li>
  <li>Agreement Accuracy = 0.6361 (answered, closest)</li>
  </ul>
</br>
* <ul type = none>
  <li>RF Accuracy = 0.3233</li>
  <li>GBM Accuracy = 0.8371</li>
  <li>Agreement Accuracy = 0.9983</li>
  </ul>
  
```
library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
set.seed(33833)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

modelRF <- train(y ~., data = vowel.train, method = 'rf')
predictionsRF <- predict(modelRF, vowel.test) # class factor
cmRF <- confusionMatrix(predictionsRF, vowel.test$y)
print(cmRF$overall['Accuracy'])
# 0.6147186 

modelBoosting <- train(y ~., data = vowel.train, method = 'gbm', verbose = F)
predictionsBoosting <- predict(modelBoosting, vowel.test) # class factor
cmBoosting <- confusionMatrix(predictionsBoosting, vowel.test$y)
print(cmBoosting$overall['Accuracy'])
# 0.5974026

indexAgreed <- predictionsRF == predictionsBoosting
cmAgreed <- confusionMatrix(predictionsRF[indexAgreed], vowel.test$y[indexAgreed]) 
print(cmAgreed$overall['Accuracy'])
# 0.631829, within where thay agree, the 2 models predict slightly better
```

### Question 2
Load the Alzheimer's data using the following commands
```
library(caret)
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,] 
```
Set the seed to 62433 and predict diagnosis with all the other variables using a random forest ("rf"), boosted trees ("gbm") and linear discriminant analysis ("lda") model. Stack the predictions together using random forests ("rf"). What is the resulting accuracy on the test set? Is it better or worse than each of the individual predictions?

#### Answer

* Stacked Accuracy: 0.76 is better than random forests and boosting, but not lda.

* Stacked Accuracy: 0.76 is better than lda but not random forests or boosting.

* Stacked Accuracy: 0.80 is better than all three other methods. (answered)

* Stacked Accuracy: 0.80 is better than random forests and lda and the same as boosting.

```
library(caret)
library(gbm)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)

set.seed(3433)
adData = data.frame(diagnosis, predictors)
inTrain = createDataPartition(adData$diagnosis, p = 0.75)[[1]]
training = adData[inTrain, ]
testing = adData[-inTrain, ]

set.seed(62433)
modelRF <- train(diagnosis ~., data = training, method = 'rf')
predictionsRF <- predict(modelRF, testing)  # class factor

modelBoosting <- train(diagnosis ~., data = training, method = 'gbm', verbose = F)
predictionsBoosting <- predict(modelBoosting, testing)  # class factor

modelLDA <- train(diagnosis ~., data = training, method = 'lda')
predictionsLDA <- predict(modelLDA, testing)  # class factor

dataCombined <- data.frame(predictionsRF, predictionsBoosting, predictionsLDA, diagnosis = testing$diagnosis)
modelCombined <- train(diagnosis ~., data = dataCombined, method = 'rf')
predictionsCombined <- predict(modelCombined, dataCombined) # class factor

l <- list(predictionsRF, predictionsBoosting, predictionsLDA, predictionsCombined)
accuracies <- function(p) {
	confusionMatrix(p, testing$diagnosis)$overall['Accuracy']
}
sapply(l, accuracies)
#  Accuracy  Accuracy  Accuracy  Accuracy 
# 0.7682927 0.7926829 0.7682927 0.8048780
```

### Question 3
Load the concrete data with the commands:
```
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
```
Set the seed to 233 and fit a lasso model to predict Compressive Strength. Which variable is the last coefficient to be set to zero as the penalty increases? (Hint: it may be useful to look up ?plot.enet).

#### Answer

* CoarseAggregate

* Water

* Age

* Cement (answered)

```
library(caret)
library(AppliedPredictiveModeling)
data(concrete)

set.seed(3523)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 0.75)[[1]]
training <- concrete[inTrain, ]
testing <- concrete[-inTrain, ]

set.seed(233)
model <- train(CompressiveStrength ~., data = training, method = 'lasso')
plot.enet(model$finalModel, xvar = 'penalty', use.color = T)
```

### Question 4
Load the data on the number of visitors to the instructors blog from here:
[https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv)
Using the commands:
```
library(lubridate) # For year() function below
dat = read.csv("~/Desktop/gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)
```
Fit a model using the bats() function in the forecast package to the training time series. Then forecast this model for the remaining time points. For how many of the testing points is the true value within the 95% prediction interval bounds?

#### Answer
* 95%
 
* 93%

* 94%

* 96% (answered)
  
```
library(forecast)
library(lubridate)
data <- read.csv('gaData.csv')
training <- data[year(data$date) < 2012, ]
testing <- data[year(data$date) > 2011, ]
tsTrain <- ts(training$visitsTumblr)

model <- bats(tsTrain)
forecasted <- forecast(model, level = 95, h = nrow(testing))  	# class forecast
str(forecasted)

withinRange <- sum(forecasted$lower <= testing$visitsTumblr & testing$visitsTumblr <= forecasted$upper)
withinRange/nrow(testing) * 100
# 96.17021
```

### Question 5
Load the concrete data with the commands:
```
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
```
Set the seed to 325 and fit a support vector machine using the e1071 package to predict Compressive Strength using the default settings. Predict on the testing set. What is the RMSE?

#### Answer
* 6.72 (answered)

* 35.59

* 6.93

* 107.44

```
library(e1071)
library(AppliedPredictiveModeling)
data(concrete)

set.seed(3523)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 0.75)[[1]]
training <- concrete[inTrain, ]
testing <- concrete[-inTrain, ]

set.seed(325)
model <- svm(CompressiveStrength ~., data = training)
predictions <- predict(model, testing)  # class numeric
accuracy(predictions, testing$CompressiveStrength)  # class matrix
#                 ME     RMSE      MAE       MPE     MAPE
# Test set 0.1682863 6.715009 5.120835 -7.102348 19.27739
```