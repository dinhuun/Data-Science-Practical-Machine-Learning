library(caret)
library(ElemStatLearn)
data(SAheart)
set.seed(8484)

train = sample(1:dim(SAheart)[1], size = dim(SAheart)[1]/2, replace = F)
trainSA = SAheart[train, ]
testSA = SAheart[-train, ]

set.seed(13234)
model <- train(chd ~ tobacco + ldl + typea + obesity + alcohol + age, data = trainSA, method = 'glm', family = 'binomial')
predictionsTrain <- predict(model, trainSA)
predictionsTest <- predict(model, testSA)

missClass = function(values, prediction){
	sum(((prediction > 0.5)*1) != values)/length(values)
}
print(missClass(testSA$chd, predictionsTest))
# 0.3116883
print(missClass(trainSA$chd, predictionsTrain))
# 0.2727273