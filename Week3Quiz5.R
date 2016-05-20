library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
set.seed(33833)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

model <- randomForest(y ~ ., data = vowel.train)
print(order(varImp(model), decreasing = T))
print(varImp(model))

#  [1]  2  1  5  6  8  4  9  3  7 10
#      Overall
# x.1  89.12864
# x.2  91.24009
# x.3  33.08111
# x.4  34.24433
# x.5  50.25539
# x.6  43.33148
# x.7  31.88132
# x.8  42.92470
# x.9  33.37031
# x.10 29.59956
