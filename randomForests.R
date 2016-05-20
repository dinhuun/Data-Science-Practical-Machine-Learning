## author: course
library(caret)
library(ggplot2)
data(iris)

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = F)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

model <- train(Species ~., data = training, model = 'rf', prox = T) # use random forests model
print(model)
finalModel <- model$finalModel
print(getTree(finalModel, k = 2)) # looking at the 2nd tree

irisP <- classCenter(training[ , c(3,4)], training$Species, finalModel$prox)
irisP <- as.data.frame(irisP)
irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, color = Species, data = training)
print(p + geom_point(aes(x = Petal.Width, y = Petal.Length, color = Species), size = 5, shape = 4, data = irisP))
readline(prompt = 'Press [enter] to continue')

predictions <- predict(model, testing)
table(predictions, testing$Species)
predictedRight <- predictions == testing$Species
print(qplot(Petal.Width, Petal.Length, color = predictedRight, data = testing, main = 'Predictions on Testing Set'))
