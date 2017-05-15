## Q1
library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)

## Q7
library(datasets)
library(ggplot2)
data(airquality)
airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)
qplot(Wind, Ozone, data = airquality, facets = . ~ factor(Month))

## Q10
data()
qplot(votes, rating, data = movies) + geom_smooth()
