## author: course
library(ggplot2)
data(iris)

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = F)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

# compare 2 methods lda and nb naive Bayes
modellda <- train(Species ~., data = training, method = 'lda')
predictionslda = predict(modellda, testing)
modelnb <- train(Species ~., data = training, method = 'nb')
predictionsnb = predict(modelnb, testing)
print(table(predictionslda, predictionsnb))
predictedSame <- predictionslda == predictionsnb
print(qplot(Petal.Width, Sepal.Width, color = predictedSame, data = testing))
