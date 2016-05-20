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
predictionsRF <- predict(modelRF, testing)

modelBoosting <- train(diagnosis ~., data = training, method = 'gbm', verbose = F)
predictionsBoosting <- predict(modelBoosting, testing)

modelLDA <- train(diagnosis ~., data = training, method = 'lda')
predictionsLDA <- predict(modelLDA, testing)

dataCombined <- data.frame(predictionsRF, predictionsBoosting, predictionsLDA, diagnosis = testing$diagnosis)
modelCombined <- train(diagnosis ~., data = dataCombined, method = 'rf')
predictionsCombined <- predict(modelCombined, dataCombined)

l <- list(predictionsRF, predictionsBoosting, predictionsLDA, predictionsCombined)
accuracies <- function(p) {
	confusionMatrix(p, testing$diagnosis)$overall['Accuracy']
}
print(sapply(l, accuracies))
#  Accuracy  Accuracy  Accuracy  Accuracy 
# 0.7682927 0.7926829 0.7682927 0.8048780