## Week 3 Quiz
### Question 1
For this quiz we will be using several R packages. R package versions change over time, the right answers have been checked using the following versions of the packages.

AppliedPredictiveModeling: v1.1.6

caret: v6.0.47

ElemStatLearn: v2012.04-0

pgmm: v1.1

rpart: v4.1.8

If you aren't using these versions of the packages, your answers may not exactly match the right answer, but hopefully should be close.

Load the cell segmentation data from the AppliedPredictiveModeling package using the commands:
```
library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)
```
1. Subset the data to a training set and testing set based on the Case variable in the data set.

2. Set the seed to 125 and fit a CART model with the rpart method using all predictor variables and default caret settings.

3. In the final model what would be the final model prediction for cases with the following variable values:
<ol type = "a">
  <li> TotalIntench2 = 23,000; FiberWidthCh1 = 10; PerimStatusCh1 = 2</li>
  <li>TotalIntench2 = 50,000; FiberWidthCh1 = 10; VarIntenCh4 = 100</li>
  <li>TotalIntench2 = 57,000; FiberWidthCh1 = 8; VarIntenCh4 = 100</li>
  <li>FiberWidthCh1 = 8; VarIntenCh4 = 100; PerimStatusCh1 = 2</li>
  </ol>

#### Answer
* <ol type = "a">
  <li>PS</li>
  <li>WS</li>
  <li>PS</li>
  <li>WS</li>
  </ol>
</br>
* <ol type = "a">
  <li>PS</li>
  <li>WS</li>
  <li>PS</li>
  <li>Not possible to predict (answered)</li>
  </ol>
</br>
* <ol type = "a">
  <li>PS</li>
  <li>Not possible to predict</li>
  <li>PS</li>
  <li>Not possible to predict</li>
  </ol>
</br>
* <ol type = "a">
  <li>Not possible to predict</li>
  <li>WS</li>
  <li>PS</li>
  <li>PS</li>
  </ol>
  
```
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

predictions('TotalIntench2', 'FiberWidthCh1', 'PerimStatusCh1', 23000, 10, 2)
#          PS        WS
# 1 0.2130178 0.7869822

predictions('TotalIntench2', 'FiberWidthCh1', 'VarIntenCh4', 50000, 10, 100)
#          PS        WS
# 1 0.2130178 0.7869822

predictions('TotalIntench2', 'FiberWidthCh1', 'VarIntenCh4', 57000, 8, 100)
#          PS         WS
# 1 0.9395973 0.06040268

predictions('FiberWidthCh1', 'VarIntenCh4', 'PerimStatusCh1', 8, 100, 2)
#          PS         WS
# 1 0.9395973 0.06040268
```

### Question 2
If K is small in a K-fold cross validation is the bias in the estimate of out-of-sample (test set) accuracy smaller or bigger? If K is small is the variance in the estimate of out-of-sample (test set) accuracy smaller or bigger. Is K large or small in leave one out cross validation? 

#### Answer

* The bias is smaller and the variance is bigger. Under leave one out cross validation K is equal to one.

* The bias is smaller and the variance is smaller. Under leave one out cross validation K is equal to the sample size.

* The bias is larger and the variance is smaller. Under leave one out cross validation K is equal to the sample size. (answered)

* The bias is larger and the variance is smaller. Under leave one out cross validation K is equal to one.

### Question 3
Load the olive oil data using the commands:
```
library(pgmm)
data(olive)
olive = olive[,-1]
```
(NOTE: If you have trouble installing the pgmm package, you can download the -code-olive-/code- dataset here: [olive_data.zip](https://d396qusza40orc.cloudfront.net/predmachlearn/data/olive_data.zip). After unzipping the archive, you can load the file using the -code-load()-/code- function in R.)

These data contain information on 572 different Italian olive oils from multiple regions in Italy. Fit a classification tree where Area is the outcome variable. Then predict the value of area for the following data frame using the tree command with all defaults
```
newdata = as.data.frame(t(colMeans(olive)))
```
What is the resulting prediction? Is the resulting prediction strange? Why or why not?

#### Answer

* 2.783. It is strange because Area should be a qualitative variable - but tree is reporting the average value of Area as a numeric variable in the leaf predicted for newdata (answered)

* 0.005291005 0 0.994709 0 0 0 0 0 0. There is no reason why the result is strange.

* 0.005291005 0 0.994709 0 0 0 0 0 0. The result is strange because Area is a numeric variable and we should get the average within each leaf.

* 4.59965. There is no reason why the result is strange.

```
library(pgmm)
data(olive)

training <- olive
testing <- as.data.frame(t(colMeans(olive)))

model <- train(Area ~., data = training, method = 'rpart')
predict(model, testing)
# 2.783282
```

### Question 4
Load the South Africa Heart Disease Data and create training and test sets with the following code:
```
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
```
Then set the seed to 13234 and fit a logistic regression model (method="glm", be sure to specify family="binomial") with Coronary Heart Disease (chd) as the outcome and age at onset, current alcohol consumption, obesity levels, cumulative tabacco, type-A behavior, and low density lipoprotein cholesterol as predictors. Calculate the misclassification rate for your model using this function and a prediction on the "response" scale:
```
missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
```
What is the misclassification rate on the training set? What is the misclassification rate on the test set?

#### Answer
* <ul type = none>
  <li>Test Set Misclassification: 0.35</li>
  <li>Training Set: 0.31</li>
 </ul>
 
* <ul type = none>
  <li>Test Set Misclassification: 0.38</li>
  <li>Training Set: 0.25</li>
  </ul>

* <ul type = none>
  <li>Test Set Misclassification: 0.31</li>
  <li>Training Set: 0.27 (answered)</li>
  </ul>

* <ul type = none>
  <li>Test Set Misclassification: 0.32</li>
  <li>Training Set: 0.30</li>
  </ul>
  
```
library(caret)
library(ElemStatLearn)
data(SAheart)
set.seed(8484)

train = sample(1:dim(SAheart)[1], size = dim(SAheart)[1]/2, replace = F)
trainSA = SAheart[train, ]
testSA = SAheart[-train, ]

set.seed(13234)
model <- train(chd ~ tobacco + ldl + typea + obesity + alcohol + age, data = trainSA, method = 'glm', family = 'binomial')
predictionsTrain <- predict(model, trainSA)
predictionsTest <- predict(model, testSA)

missClass = function(values, prediction){
	sum(((prediction > 0.5)*1) != values)/length(values)
}
missClass(testSA$chd, predictionsTest)
# 0.3116883
missClass(trainSA$chd, predictionsTrain)
# 0.2727273
```

### Question 5
Load the vowel.train and vowel.test data sets:
```
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
```
Set the variable y to be a factor variable in both the training and test set. Then set the seed to 33833. Fit a random forest predictor relating the factor variable y to the remaining variables. Read about variable importance in random forests here: [http://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr](http://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr) The caret package uses by default the Gini importance.

Calculate the variable importance using the varImp function in the caret package. What is the order of variable importance?

#### Answer
* <ul type = none>
  <li>The order of the variables is:</li>
  <li>x.1, x.2, x.3, x.8, x.6, x.4, x.5, x.9, x.7,x.10</li>
  </ul>

* <ul type = none>
  <li>The order of the variables is:</li>
  <li>x.10, x.7, x.9, x.5, x.8, x.4, x.6, x.3, x.1,x.2</li>
  </ul>

* <ul type = none>
  <li>The order of the variables is:</li>
  <li>x.2, x.1, x.5, x.8, x.6, x.4, x.3, x.9, x.7,x.10</li>
  </ul>

* <ul type = none>
  <li>The order of the variables is:</li>
  <li>x.2, x.1, x.5, x.6, x.8, x.4, x.9, x.3, x.7,x.10 (answered)</li>
  </ul>
  
```
library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
set.seed(33833)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

model <- randomForest(y ~ ., data = vowel.train)
order(varImp(model), decreasing = T)
varImp(model)
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
```