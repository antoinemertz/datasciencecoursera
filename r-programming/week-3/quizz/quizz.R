library(datasets)
data(iris)

round(mean(iris[iris$Species == "virginica",]$Sepal.Length))

apply(iris[, 1:4], 2, mean)

data(mtcars)

sapply(split(mtcars$mpg, mtcars$cyl), mean)
with(mtcars, tapply(mpg, cyl, mean))
tapply(mtcars$mpg, mtcars$cyl, mean)

round(abs(mean(mtcars$hp[mtcars$cyl == 4]) - mean(mtcars$hp[mtcars$cyl == 8])))
