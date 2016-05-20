## author: course
library(caret) # contains rpart package, party package but not tree package
library(ggplot2)
library(rattle)
data(iris)

names(iris) # Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species
table(iris$Species) # setosa 50, versicolor 50, virginica 50

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = F)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

print(qplot(Petal.Width, Sepal.Width, color = Species, data = training))
model <- train(Species ~., data = training, method = 'rpart')
finalModel <- model$finalModel
print(summary(finalModel))
readline(prompt = 'Press [enter] to continue')

# plot dendrogram
plot(finalModel, uniform = T, main = 'Classification Tree')
text(finalModel, use.n = T, all = T, cex = 0.8)
readline(prompt = 'Press [enter] to continue')

# plot dendrogram with rattle
fancyRpartPlot(finalModel)

predictions <- predict(model, testing)
print(table(predictions, testing$Species))