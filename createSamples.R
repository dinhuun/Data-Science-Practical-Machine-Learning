## author: course
library(caret)
library(kernlab)
data(spam)

inTrain <- createDataPartition(y = spam$type, p = 0.75, list = F)
training <- spam[inTrain, ]
testing <- spam[-inTrain, ]

set.seed(32343)
model <- train(type ~., data = training, method = “glm”)
model$finalModel
predictions <- predict(model, newdata = testing)
predictions

set.seed(32323)
folds <- createFolds(y = spam$type, k = 10, list = T, returnTrain = F)
sapply(folds, length)

set.seed(32323)
folds <- createResample(y = spam$type, times = 10, list = T)
sapply(folds, length)

setseed(32323)
time <- 1:1000
folds <- createTimeSlices(y = time, initialWindo = 20, horizon = 10)
names(folds)
folds$train[[1]]
folds$test[[1]]