## author: course
library(caret)
library(ggplot2)
library(ISLR)
data(Wage)

# training set, validation set and testing set
Wage <- subset(Wage, select = -c(logwage))
inBuild <- createDataPartition(y = Wage$wage, p = 0.7, list = F)
valication <- Wage[-inBuild, ]
buildData <- Wage[inBuild, ]
inTrain <- createDataPartition(y = buildData$wage, p = 0.7, list = F)
training <- buildData[inTrain, ]
testing <- buildData[-inTrain, ]

# build 2 models on training set and compare them on testing set
model1 <- train(wage ~., data = training, method = 'glm')
model2 <- train(wage ~., data = training, method = 'rf', trControl = trainControl(method = 'cv'), number = 3)
predictions1 <- predict(model1, testing)
predictions2 <- predict(model2, testing)
print(qplot(predictions1, predictions2, color = wage, data = testing))

# combined model train on above 2 predictions
predictionsDF <- data.frame(predictions1, predictions2, wage = testing$wage)
modelCombined <- train(wage ~., data = predictionsDF, method = 'gam')
predictionsCombined <- predict(modelCombined, predictionsDF)
# compare all 3 models on testing set
sqrt(sum((predictions1 - testing$wage)^2))
sqrt(sum((predictions2 - testing$wage)^2))
sqrt(sum((predictionsCombined - testing$wage)^2))

# now on validation set
pred1 <- predict(model1, validation)
pred2 <- predict(model2, validation)
predDF <- data.frame(pred1, pred2, wage = validation$wage)
predCombined <- predict(modelCombined, predDF)
sqrt(sum((pred1 - validation$wage)^2))
sqrt(sum((pred2 - validation$wage)^2))
sqrt(sum((predCombined - validation$wage)^2))