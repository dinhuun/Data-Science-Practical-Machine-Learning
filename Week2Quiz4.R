library(AppliedPredictiveModeling)
data(AlzheimerDisease)
library(caret)
set.seed(3433)

data <- data.frame(diagnosis, predictors)
inTrain <- createDataPartition(data$diagnosis, p = 3/4)[[1]]
training <- data[inTrain, ]
testing <- data[-inTrain, ]

columnsIL <- grep('^IL', colnames(training), value = T, ignore.case = T)
pcaPreProcess <- preProcess(training[ , columnsIL], method = 'pca', thresh = 0.9)
print(pcaPreProcess)
