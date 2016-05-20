## author: course
library(caret)
library(ggplot2)
library(ISLR)
data(Wage)

Wage <- subset(Wage, select = -c(logwage))
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = F)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]
# dim(training) = 898, dim(testing) = 11

# model1 and its looks
model1 <- train(wage ~ age + jobclass + education, data = training, method = 'lm')
finalModel1 <- model1$finalModel
print(summary(finalModel1))
plot(finalModel1, 1, pch = 19, cex = 0.5, col = '#00000010')
readline(prompt = 'Press [enter] to continue')
print(qplot(finalModel1$fitted, finalModel1$residuals, data = training, color = race))
readline(prompt = 'Press [enter] to continue')
plot(finalModel1$residuals, pch = 19)
readline(prompt = 'Press [enter] to continue')

predictions <- predict(model1, testing)
print(qplot(wage, predictions, data = testing, color = year))
readline(prompt = 'Press [enter] to continue')

# using all features
model2 <- train(wage ~., data = training, method = 'lm')
predictions2 <- predict(model2, testing)
print(qplot(wage, predictions, data = testing))
