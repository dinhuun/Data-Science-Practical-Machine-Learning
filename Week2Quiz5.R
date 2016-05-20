library(AppliedPredictiveModeling)
data(AlzheimerDisease)
library(caret)
set.seed(3433)

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

print(c1)
print(c2)

