## author: course
library(caret)
library(ggplot2)
library(ISLR)
data(Wage)

Wage <- subset(Wage, select = -c(logwage))
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = F)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]

model <- train(wage ~., data = training, method = 'gbm', verbose = F) # method gbm does boosting with trees
print(model)
predictions <- predict(model, testing)
print(qplot(predictions, testing$wage))