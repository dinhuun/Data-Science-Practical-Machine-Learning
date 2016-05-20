## author: course
library(caret)
library(ggplot2)
library(ISLR)
data(Wage)

Wage <- subset(Wage, select = -c(logwage))
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = F)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]
# dim(training) = 898, dim(testing) = 11

# looks at training set
print(featurePlot(x = training[ , c('age', 'education', 'jobclass')], y = training$wage, plot = 'pairs'))
readline(prompt = 'Press [enter] to continue')
print(qplot(age, wage, data = training))
readline(prompt = 'Press [enter] to continue')
print(qplot(age, wage, color = jobclass, data = training))
readline(prompt = 'Press [enter] to continue')
print(qplot(age, wage, color = education, data = training))