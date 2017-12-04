x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)

model <- lm(y~x)
model
summary(model)

data("mtcars")
model <- lm(mpg ~ wt, mtcars)
model
summary(model)
prediction <- predict(model, newdata = data.frame(wt = mean(mtcars$wt)), interval="confidence")
prediction


prediction <- predict(model, newdata = data.frame(wt = 3000/1000), interval="prediction")
prediction

