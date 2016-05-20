library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
set.seed(33833)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

modelRF <- train(y ~., data = vowel.train, method = 'rf')
predictionsRF <- predict(modelRF, vowel.test) # class factor
cmRF <- confusionMatrix(predictionsRF, vowel.test$y)
print(cmRF$overall['Accuracy'])
# 0.6147186 

modelBoosting <- train(y ~., data = vowel.train, method = 'gbm', verbose = F)
predictionsBoosting <- predict(modelBoosting, vowel.test) # class factor
cmBoosting <- confusionMatrix(predictionsBoosting, vowel.test$y)
print(cmBoosting$overall['Accuracy'])
# 0.5974026

indexAgreed <- predictionsRF == predictionsBoosting
cmAgreed <- confusionMatrix(predictionsRF[indexAgreed], vowel.test$y[indexAgreed]) 
print(cmAgreed$overall['Accuracy'])
# 0.631829, where thay agree, the 2 models predict slightly better