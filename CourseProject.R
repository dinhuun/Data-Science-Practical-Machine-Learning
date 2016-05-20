library(caret)
library(gbm)
library(ggplot2)
set.seed(1)

# loading
trainData <- read.csv('pml-training.csv', na.strings = c('NA', ''))	# 19622x160
testData <- read.csv('pml-testing.csv', na.strings = c('NA', ''))	# 20x160

# cleaning
trainData <- trainData[ , -c(1:7)]	# 19622x153
testData <- testData[ , -c(1:7)]	# 20x153
trainData <- trainData[ , colSums(is.na(trainData)) == 0] # 19622x53
testData <- testData[ , colSums(is.na(testData)) == 0, ] # 20x53

# splitting
inTrain <- createDataPartition(y = trainData$classe, p = 0.75, list = F)
training <- trainData[inTrain, ]	# 14718x53
validation <- trainData[-inTrain, ]	# 4904x53
testing <- testData # 20x53

# plotting
featurePlot(x = training[ , c('total_accel_belt', 'total_accel_arm', 'total_accel_dumbbell', 'total_accel_forearm')], y = training$classe, plot = 'pairs')
qplot(total_accel_belt, total_accel_arm, color = classe, data = training)
qplot(total_accel_arm, total_accel_dumbbell, color = classe, data = training)
qplot(total_accel_arm, total_accel_forearm, color = classe, data = training)
qplot(total_accel_belt, total_accel_dumbbell, color = classe, data = training)

# learning
pre <- c('center', 'scale') # add 'pca' with a faster computer
con <- trainControl(method = 'cv', number = 5)

modelRF <- train(training$classe ~., data = training, method = 'rf', preProcess = pre, trControl = con)
predictionsRF <- predict(modelRF, validation)

modelBS <- train(training$classe ~., data = training, method = 'gbm', preProcess = pre, trControl = con, verbose = F)
predictionsBS <- predict(modelBS, validation)

dataCombined <- data.frame(predictionsRF, predictionsBS, classe = validation$classe)
modelCombined <- train(classe ~., dataCombined)
predictionsCombined <- predict(modelCombined, dataCombined)

l <- list(predictionsRF, predictionsBS, predictionsCombined)
accuracies <- function(p) {
    confusionMatrix(p, validation$classe)$overall['Accuracy']
}
print(sapply(l, accuracies))
# 0.9926591		0.9626835		0.9926591
# combined model offers no improvement over random forests model. We will use the latter to predict the testing set

predictionsTest <- predict(modelRF, testing)
predictionsTest
# [1] B A B A A E D B A A B C B A E E A B B B
# Levels: A B C D E