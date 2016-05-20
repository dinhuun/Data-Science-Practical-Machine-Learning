## author: course
library(kernlab)
data(spam)
set.seed(333)

rows <- sample(dim(spam)[1], size = 10)
smallSpam <- spam[, ]
spamLabel <- (smallSpam$type == 'spam')*1 + 1
plot(smallSpam$capitalAve, col = spamLabel)

rule1 <- function(x) {
	prediction <- rep(NA, length(x))
	prediction[x < 2.4] <- 'nonspam'
	prediction[(x >= 2.4 & x <= 2.45)] <- 'spam'
	prediction[(x > 2.45 & x <= 2.7)] <- 'nonspam'
	prediction[x > 2.7] <- 'spam'
	return(prediction)
}
print(table(rule1(smallSpam$capitalAve), smallSpam$type))
print(sum(rule1(smallSpam$capitalAve) == smallSpam$type))