library(caret)
library(AppliedPredictiveModeling)
data(concrete)

set.seed(3523)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 0.75)[[1]]
training <- concrete[inTrain, ]
testing <- concrete[-inTrain, ]

set.seed(233)
model <- train(CompressiveStrength ~., data = training, method = 'lasso')
plot.enet(model$finalModel, xvar = 'penalty', use.color = T)