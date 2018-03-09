data("mtcars")
library(dplyr)
library(ggplot2)

mtcars <- mtcars %>%
  mutate(vs = factor(vs)) %>%
  mutate(gear = factor(gear)) %>%
  mutate(carb = factor(carb)) %>%
  mutate(am = factor(am, labels = c("auto", "manual")))

ggplot(mtcars) +
  geom_boxplot(aes(x=am, y=mpg, fill=am)) +
  ggtitle("Miles per gallon according to automative type") +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(mtcars, aes(mpg)) +
  geom_density(aes(fill="both"), alpha=0.4) +
  geom_density(aes(fill=am), alpha=0.4) +
  ggtitle("MPG density according to automative type") +
  theme(plot.title = element_text(hjust = 0.5))

t_test <- t.test(mpg ~ am, data=mtcars)
t_test

complete_model <- lm(mpg ~ ., data=mtcars)
best_model <- step(complete_model)

best <- lm(mpg ~ cyl + disp + wt + am, data=mtcars)
summary(best)

yhat <- data.frame(real = mtcars$mpg, fitted = best$fitted.values)
ggplot(yhat, aes(x=fitted, y=real)) +
  geom_point() +
  geom_abline(intercept=0, slope=1) +
  ggtitle("Real values vs fitted values") +
  theme(plot.title = element_text(hjust = 0.5))

