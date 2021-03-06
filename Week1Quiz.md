## Week 1 Quiz
### Question 1
Which of the following are components in building a machine learning algorithm?

#### Answer
* Statistical inference

* Training and test sets (answered)

* Artificial intelligence

* Machine learning

* Asking the right question

### Question 2
Suppose we build a prediction algorithm on a data set and it is 100% accurate on that data set. Why might the algorithm not work well if we collect a new data set?

#### Answer

* We have too few predictors to get good out of sample accuracy.

* We may be using a bad algorithm that doesn't predict well on this kind of data.

* We have used neural networks which has notoriously bad performance.

* Our algorithm may be overfitting the training data, predicting both the signal and the noise. (answered)

### Question 3
What are typical sizes for the training and test sets?

#### Answer

* 50% in the training set, 50% in the testing set.

* 80% training set, 20% test set (answered)

* 0% training set, 100% test set.

* 90% training set, 10% test set

### Question 4
What are some common error rates for predicting binary variables (i.e. variables with two possible values like yes/no, disease/normal, clicked/didn't click)? Check the correct answer(s).

#### Answer

* R^2

* Predictive value of a positive (answered, TP/(TP + FP))

* Median absolute deviation

* Root mean squared error

* Correlation

### Question 5
Suppose that we have created a machine learning algorithm that predicts whether a link will be clicked with 99% sensitivity and 99% specificity. The rate the link is clicked is 1/1000 of visits to a website. If we predict the link will be clicked on a specific visit, what is the probability it will actually be clicked?

#### Answer

* 50%

* 9% (answered, 99/(99 + 999))

* 99%

* 99.9%