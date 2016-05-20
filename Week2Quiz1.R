library(AppliedPredictiveModeling)
data(AlzheimerDisease)

adData <- data.frame(diagnosis, predictors)
trainIndex <- createDataPartition(diagnosis, p = 0.5, list = F)
training <- adData[trainIndex, ]
testing <- adData[-trainIndex, ]