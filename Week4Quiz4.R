library(forecast)
library(lubridate)
data <- read.csv('gaData.csv')
training <- data[year(data$date) < 2012, ]
testing <- data[year(data$date) > 2011, ]
tsTrain <- ts(training$visitsTumblr)

model <- bats(tsTrain)
forecasted <- forecast(model, level = 95, h = nrow(testing))	# class forecast
print(str(forecasted))

withinRange <- sum(forecasted$lower <= testing$visitsTumblr & testing$visitsTumblr <= forecasted$upper)
print(withinRange/nrow(testing) * 100)
# 96.17021