library(caret)
library(AppliedPredictiveModeling)
data(concrete)
set.seed(1000)

inTrain <- createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training <- mixtures[ inTrain,]
testing <- mixtures[-inTrain,]

par(mfrow = c(2,1))
hist(training$Superplasticizer, breaks = 50)
hist(log(training$Superplasticizer + 1), breaks = 50)