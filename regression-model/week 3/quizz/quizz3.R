library(dplyr)

data("mtcars")
head(mtcars)

model1 = lm(mpg ~ as.factor(cyl) + wt, data = mtcars)
summary(model1)

model2 = lm(mpg ~ as.factor(cyl), data = mtcars)
summary(model2)

model3 = lm(mpg ~ as.factor(cyl) * wt, data = mtcars)
summary(model3)
anova(model1, model3, test = "Chisq")

x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)
hatvalues(lm(y~x))

x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)
model <- lm(y ~ x)
hatvalues(model)
dfbetas(model)
