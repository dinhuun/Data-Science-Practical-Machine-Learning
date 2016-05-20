library(caret)
library(rattle)
library(rpart)
library(AppliedPredictiveModeling)
data(segmentationOriginal)
set.seed(125)

subset <- split(segmentationOriginal, segmentationOriginal$Case)

# use this model and its decision tree to get answer
model1 <- train(Class ~., data = subset$Train, method = 'rpart')
fancyRpartPlot(model1$finalModel)

# use this model to get probability of PS and probability of WS
model2 <- rpart(Class ~., data = subset$Train)
predictions <- function(a, b, c, x, y, z) {
	sample <- segmentationOriginal[0, ]
	sample[1, a] <- x
	sample[1, b] <- y
	sample[1, c] <- z
	predict(model2, sample, type = 'prob')
}

print(predictions('TotalIntench2', 'FiberWidthCh1', 'PerimStatusCh1', 23000, 10, 2))
#         PS        WS
#1 0.2130178 0.7869822

print(predictions('TotalIntench2', 'FiberWidthCh1', 'VarIntenCh4', 50000, 10, 100))
#         PS        WS
#1 0.2130178 0.7869822

print(predictions('TotalIntench2', 'FiberWidthCh1', 'VarIntenCh4', 57000, 8, 100))
#         PS         WS
#1 0.9395973 0.06040268

print(predictions('FiberWidthCh1', 'VarIntenCh4', 'PerimStatusCh1', 8, 100, 2))
#         PS         WS
#1 0.9395973 0.06040268