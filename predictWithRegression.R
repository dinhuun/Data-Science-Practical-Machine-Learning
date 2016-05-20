## author: course
library(caret)
data(faithful)
set.seed(333)

inTrain <- createDataPartition(y = faithful$waiting, p = 0.5, list = F)
training <- faithful[inTrain, ]
testing <- faithful[-inTrain, ]
# names(training) = 'waiting', 'eruptions'

# plot for observation, then fit linear model1
plot(training$waiting, training$eruptions, pch = 19, col = 'blue', xlab = 'waiting', ylab = 'duration')
model1 <- lm(eruptions ~ waiting, data = training)
print(summary(model1))

# see how it works out on the training set
plot(training$waiting, training$eruptions, pch = 19, col = 'blue', xlab = 'waiting', ylab = 'duration')
lines(training$waiting, model1$fitted, lwd = 3)

# see how it works out on the testing set
plot(testing$waiting, testing$eruptions, pch = 19, col = 'blue', xlab = 'waiting', ylab = 'duration')
predictions1 <- predict(model1, testing)
lines(testing$waiting, predictions1, lwd = 3)

# errors
errorTraining <- sqrt(sum((model1$fitted - training$eruptions)^2))
errorTesting <- sqrt(sum((predictions1 - testing$eruptions)^2))
print(errorTraining)
print(errorTesting)

# prediction intervals
predictions1Int <- predict(model1, testing, interval = 'prediction')
ord <- order(testing$waiting)
plot(testing$waiting, testing$eruptions, pch = 19, col = 'blue', xlab = 'waiting', ylab = 'duration')
matlines(testing$waiting[ord], predictions1Int[ord, ], type = 'l', col = c(1,2,2), lty = c(1,1,1), lwd = 3)

# using caret package
model2 <- train(eruptions ~ waiting, data = training, method = 'lm')
summary(model2$finalModel)
predictions2 <- predict(model2, testing)
print(predictions1 == predictions2)
