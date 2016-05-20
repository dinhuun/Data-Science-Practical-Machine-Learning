library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(1000)
library(Hmisc)

inTrain <- createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training <- mixtures[inTrain, ]
testing <- mixtures[-inTrain, ]

index <- 1:length(training$CompressiveStrength)
for (column in 1:8) {
	print(qplot(index, training$CompressiveStrength, color = cut2(training[ , column])))
	readline(prompt = 'Press [enter] to continue')
}