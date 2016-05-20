library(pgmm)
data(olive)

training <- olive
testing <- as.data.frame(t(colMeans(olive)))

model <- train(Area ~., data = training, method = 'rpart')
print(predict(model, testing))
# 2.783282