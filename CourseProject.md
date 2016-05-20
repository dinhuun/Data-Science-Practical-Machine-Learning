## Course Project
### Background
Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har) (see the section on the Weight Lifting Exercise Dataset).

### Data
The training data for this project are available here:
[https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv)

The test data are available here:
[https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv)

The data for this project come from this source: [http://groupware.les.inf.puc-rio.br/har](http://groupware.les.inf.puc-rio.br/har). If you use the document you create for this class for any purpose please cite them as they have been very generous in allowing their data to be used for this kind of assignment.

### What you should submit
The goal of your project is to predict the manner in which they did the exercise. This is the ```classe``` variable in the training set. You may use any of the other variables to predict with. You should create a report describing how you built your model, how you used cross validation, what you think the expected out of sample error is, and why you made the choices you did. You will also use your prediction model to predict 20 different test cases.

### Processing
#### Loading
```
trainData <- read.csv('pml-training.csv', na.strings = c('NA', ''))
testData <- read.csv('pml-testing.csv', na.strings = c('NA', ''))
str(trainData)  # 19622x160
str(testData)   # 20x160
```
The ```trainData``` set is a data frame of 19622 observations and 160 variables, the last of which is ```classe```. The ```testData``` set is a data frame of 20 observations and 160 variables, the last of which is ```problem_id```.

#### Cleaning
The first 7 variables obviously hold no predicting power on variable ```classe``` and are discarded. Variables with ```NA``` observations are also discarded. Without further knowledge about these physical exercises, we keep the remaining variables.
```
trainData <- trainData[ , -c(1:7)]	# 19622x153
testData <- testData[ , -c(1:7)]    # 20x153
trainData <- trainData[ , colSums(is.na(trainData)) == 0] # 19622x53
testData <- testData[ , colSums(is.na(testData)) == 0, ]  # 20x53
```

#### Splitting
Since the number of observations in ```trainData``` is large enough, 75% of ```trainData``` is set for training and 25% of ```trainData``` is set for validation.
```
library(caret)
library(gbm)
set.seed(1)
inTrain <- createDataPartition(trainData, p = 0.75, list = F)
training <- trainData[inTrain, ]    # 14718x53
validation <- trainData[-inTrain, ] # 4904x53
testing <- testData # 20x153
```

### Plotting
We look at the training data from a few angles.
```
library(ggplot2)
featurePlot(x = training[ , c('total_accel_belt', 'total_accel_arm', 'total_accel_dumbbell',
            'total_accel_forearm')], y = training$classe, plot = 'pairs')
qplot(total_accel_belt, total_accel_arm, color = classe, data = training)
qplot(total_accel_arm, total_accel_dumbbell, color = classe, data = training)
qplot(total_accel_arm, total_accel_forearm, color = classe, data = training)
qplot(total_accel_belt, total_accel_dumbbell, color = classe, data = training)
```
Of these plots, the last one offers the most definite clustering, though not enough to give any clue.

### Learning
This is a classification problem, so we try a random forests model, a boosting model and a combined model. Then we apply all three models on validation set and compare their accuracies. Since the variables range widely, we do a little preprocessing plus some control.
```
pre <- c('center', 'scale') # add 'pca' if you have some computing power
con <- trainControl(method = 'cv', number = 5)
```

#### Random Forests Model
```
modelRF <- train(training$classe ~., data = training, method = 'rf',  preProcess = pre, trControl = con)
predictionsRF <- predict(modelRF, validdation)
confusionMatrix(predictionsRF, validation$classe)$overall
#  Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull AccuracyPValue  McnemarPValue 
# 0.9926591      0.9907136      0.9898514      0.9948533      0.2844617      0.0000000            NaN
```
With that little preprocessing, this model built quickly and its predictions are accurate. Without, it built overnight and its predictions were even more accurate (Accuracy = 0.9946982).

#### Boosting Model
```
modelBS <- train(training$classe ~., data = training, method = 'gbm', preProcess = pre, trControl = con, verbose = F)
predictionsBS <- predict(modelBS, validation)
confusionMatrix(predictionsBS, validation$classe)$overall
#  Accuracy       Kappa AccuracyLower AccuracyUpper  AccuracyNull AccuracyPValue  McnemarPValue
# 0.9624796   0.9525253     0.9567765     0.9676233     0.2844617      0.0000000      0.4826484
```
This model built more quickly and its predictions are less accurate than those by random forests model.

#### Combined Model
```
dataCombined <- data.frame(predictionsRF, predictionsBS, classe = validation$classe)
modelCombined <- train(classe ~., dataCombined)
predictionsCombined <- predict(modelCombined, dataCombined)
confusionMatrix(predictionsCombined, validation$classe)$overall
#  Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull AccuracyPValue  McnemarPValue 
# 0.9926591      0.9907136      0.9898514      0.9948533      0.2844617      0.0000000            NaN
```
The combined model offers no improvement over the random forests model. 

### Testing
We will use the random forests model to predict the variable ```classe``` for the testing set.
```
predictionsTest <- predict(modelRF, testing)
predictionsTest
# [1] B A B A A E D B A A B C B A E E A B B B
# Levels: A B C D E
```
These 20 predictions are then used as answers to the 20 questions in the course project quiz. This completes the course project.