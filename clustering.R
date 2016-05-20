## author: course
library(ggplot2)
data(iris)

inTrain <- createDataPartition(y = iris$Species, p = 0.7, list = F)
training <- iris[inTrain, ]
testing <- iris[-inTrain, ]

# K-means clustering
kMeans <- kmeans(subset(training, select = -c(Species)), centers = 3)
training$clusters <- as.factor(kMeans$cluster)
print(qplot(Petal.Width, Petal.Length, color = clusters, data = training))
table(kMeans$cluster, training$Species)

# use above clustering to build model and predict on training set
model <- train(clusters ~., data = subset(training, select = -c(Species)), method = 'rpart')
predictionsTrain <- predict(model, training)
print(table(predictionsTrain, training$Species))

# predict on testing set
predictionsTest <- predict(model, testing)
print(table(predictionsTest, testing$Species))