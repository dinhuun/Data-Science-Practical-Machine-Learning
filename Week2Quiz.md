## Week 2 Quiz
### Question 1
Load the Alzheimer’s disease data using the commands:
```
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
```
Which of the following commands will create non-overlapping training and test sets with about 50% of the observations assigned to each?

#### Answer
*
```
adData = data.frame(diagnosis, predictors)
train = createDataPartition(diagnosis, p = 0.50, list = FALSE)
test = createDataPartition(diagnosis, p = 0.50, list = FALSE)
```

*
```
adData = data.frame(diagnosis, predictors)
trainIndex = createDataPartition(diagnosis, p = 0.50)
training = adData[trainIndex, ]
testing = adData[-trainIndex, ]
```

*
```
adData = data.frame(predictors)
trainIndex = createDataPartition(diagnosis, p = 0.5, list = FALSE)
training = adData[trainIndex, ]
testing = adData[-trainIndex, ]
```

*
```
adData = data.frame(diagnosis, predictors)
trainIndex = createDataPartition(diagnosis, p = 0.5, list = FALSE)
training = adData[trainIndex, ]
testing = adData[-trainIndex, ] (answered)
```

### Question 2
Load the cement data using the commands:
```
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[inTrain, ]
testing = mixtures[-inTrain, ]
```
Make a plot of the outcome (CompressiveStrength) versus the index of the samples. Color by each of the variables in the data set (you may find the cut2() function in the Hmisc package useful for turning continuous covariates into factors). What do you notice in these plots?

#### Answer

* There is a non-random pattern in the plot of the outcome versus index that is perfectly explained by the Age variable so there may be a variable missing.

* There is a non-random pattern in the plot of the outcome versus index that is perfectly explained by the FlyAsh variable.

* The outcome variable is highly correlated with FlyAsh.

* There is a non-random pattern in the plot of the outcome versus index that does not appear to be perfectly explained by any predictor suggesting a variable may be missing. (answered)

```
library(Hmisc)
index <- 1:length(training$CompressiveStrength)
for (column in 1:8) {
	qplot(index, training$CompressiveStrength, color = cut2(training[ , column]))
	readline(prompt = 'Press [enter] to continue')
}
```

### Question 3
Load the cement data using the commands:
```
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[inTrain, ]
testing = mixtures[-inTrain, ]
```
Make a histogram and confirm the SuperPlasticizer variable is skewed. Normally you might use the log transform to try to make the data more symmetric. Why would that be a poor choice for this variable?

#### Answer

* The log transform does not reduce the skewness of the non-zero values of SuperPlasticizer

* The SuperPlasticizer data include negative values so the log transform can not be performed.

* The log transform produces negative values which can not be used by some classifiers.

* There are values of zero so when you take the log() transform those values will be -Inf. (answered)

```
hist(training$Superplasticizer, breaks = 50)
hist(log(training$Superplasticizer + 1), breaks = 50)
```

### Question 4
Load the Alzheimer's disease data using the commands:
```
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
library(caret)
set.seed(3433)
adData = data.frame(diagnosis, predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[inTrain, ]
testing = adData[-inTrain, ]
```
Find all the predictor variables in the training set that begin with IL. Perform principal components on these variables with the preProcess() function from the caret package. Calculate the number of principal components needed to capture 90% of the variance. How many are there?

#### Answer

* 7

* 10

* 8

* 9 (answered)

```
columnsIL <- grep('^IL', colnames(training), value = T, ignore.case = T)
pcaPreProcess <- preProcess(training[ , columnsIL], method = 'pca', thresh = 0.9)
pcaPreProcess
```

### Question 5
Load the Alzheimer's disease data using the commands:
```
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
library(caret)
set.seed(3433)

adData = data.frame(diagnosis, predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[inTrain, ]
testing = adData[-inTrain, ]
```
Create a training data set consisting of only the predictors with variable names beginning with IL and the diagnosis. Build two predictive models, one using the predictors as they are and one using PCA with principal components explaining 80% of the variance in the predictors. Use method="glm" in the train function.
What is the accuracy of each method in the test set? Which is more accurate?

#### Answer

* Non-PCA Accuracy: 0.72, PCA Accuracy: 0.71

* Non-PCA Accuracy: 0.75, PCA Accuracy: 0.71

* Non-PCA Accuracy: 0.72, PCA Accuracy: 0.65

* Non-PCA Accuracy: 0.65, PCA Accuracy: 0.72 (answered)

```
columnsIL <- grep('^IL', colnames(training), value = T, ignore.case = T)
data <- data.frame(diagnosis, predictors[ , columnsIL])
inTrain <- createDataPartition(data$diagnosis, p = 3/4)[[1]]
training <- data[inTrain, ]
testing <- data[-inTrain, ]

model1 <- train(training$diagnosis ~., data = training, method = 'glm')
predictions1 <- predict(model1, testing)
c1 <- confusionMatrix(predictions1, testing$diagnosis)

model2 <- train(training$diagnosis ~., data = training, method = 'glm', preProcess = 'pca', trControl = trainControl(preProcOptions = list(thresh = 0.8)))
predictions2 <- predict(model2, testing)
c2 <- confusionMatrix(predictions2, testing$diagnosis)

c1
c2
```