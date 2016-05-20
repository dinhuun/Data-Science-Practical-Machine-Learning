library(e1071)
library(AppliedPredictiveModeling)
data(concrete)

set.seed(3523)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 0.75)[[1]]
training <- concrete[inTrain, ]
testing <- concrete[-inTrain, ]

set.seed(325)
model <- svm(CompressiveStrength ~., data = training)
predictions <- predict(model, testing)	# class numeric
acc <- accuracy(predictions, testing$CompressiveStrength)	# class matrix
print(acc)
#                 ME     RMSE      MAE       MPE     MAPE
# Test set 0.1682863 6.715009 5.120835 -7.102348 19.27739