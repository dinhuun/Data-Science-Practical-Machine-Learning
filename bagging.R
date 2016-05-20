## author: course
# useful for nonlinear models
# often used with trees, an extension is random forests
# train() in package caret even has method = 'bagEarth', 'treebag', 'bagFDA' 

library(ElemStatLearn)
data(ozone, package = 'ElemStatLearn')

ozone <- ozone[order(ozone$ozone), ]
head(ozone)

ll <- matrix(NA, nrow = 10, ncol = 155)
for (i in 1:10) {
	ss <- sample(1:dim(ozone)[1], replace = T)
	ozone0 <- ozone[ss, ]
	ozone0 <- ozone[order(ozone0$ozone), ]
	loess0 <- loess(temperature ~ ozone, data = ozone0, span = 0.2)
	ll[i, ] <- predict(loess0, data.frame(ozone = 1:155))
}

plot(ozone$ozone, ozone$temperature, pch = 19, cex = 0.5)
for(i = 1:10) {
	lines(1:155, ll[i, ], color = 'grey', lwd = 2)
}
lines(1:155, apply(ll, 2, mean), color = 'red', lwd = 2)

# build bagging, predict and compare
# using ctree
predictors = data.frame(ozone = ozone$ozone)
temperature = ozone$temperature
treebag <- bag(predictors, temperature, B = 10, bagControl = bagControl(
fit = ctreeBag$fit, predict = ctreeBag$pred, aggregate = ctree$aggregate))
predictions1 <- predict(treebag$fits[[1]]$fit, predictors)
predictions2 <- predict(treebag, predictors)
plot(ozone$ozone, temperature, pch = 19, color = 'lightgrey')
points(ozone$ozone, predictions1, pch = 19, color = 'red')
points(ozone$ozone, predictions2, pch = 19, color = 'blue')