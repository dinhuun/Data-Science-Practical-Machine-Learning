## author: course
library(caret)
library(kernlab)
data(spam)

inTrain <- createDataPartition(y = spam$type, p = 0.75, list = F)
training <- spam[inTrain, ]
testing <- spam[-inTrain, ]

# find top 2 pricipal components with correlation matrix
M <- abs(cor(training[ , -58]))
diag(M) <- 0
which(M > 0.8, arr.ind = T)
names(spam)[c(34,32)]
plot(spam[ ,34], spam[ , 32])

# plot top 2 principal components
smallSpam <- spam[ , c(34,32)]
prComp <- prcomp(smallSpam)
plot(prComp$x[ ,1], prComp$x[ ,2])
prComp$rotation

# find and plot top 2 principal components with kernlab
typeColor <- (spam$type == 'spam')*1 + 1
prComp <- prcomp(log10(spam[ , -58] + 1))
plot(prComp$x[ ,1], prComp$x[ ,2], col = typeColor, xlab = 'PC1', ylab = 'PC2')

# find and plot top 2 principal components with caret package
preProc <- preProcess(log10(spam[ ,-58] + 1), method = 'pca', pcaComp = 2)
spamPC <- predict(preProc, log10(spam[ , -58] + 1))
plot(spamPC[ ,1], spamPC[ ,2], col = typeColor)

## preProcess and train() separately
# train on training set
preProc <- preProcess(log10(training[ ,-58] + 1), method = 'pca', pcaComp = 2)
trainPC <- predict(preProc, log10(training[ , -58] + 1))
model1 <- train(training$type ~., data = trainPC, method = 'glm')

# predict on testing set
testPC <- predict(preProc, log10(testing[ , -58] + 1))
predictions1 <- predict(model1, testPC)
c1 <- confusionMatrix(predictions1, testing$type)
print(c1)

# combine preProcess into train(), which will be automatically applied to testing set
model2 <- train(training$type ~., data = training, method = 'glm', preProcess = 'pca')
predictions2 <- predict(model2, testing)
c2 <- confusionMatrix(predictions2, testing$type)
print(c2)



