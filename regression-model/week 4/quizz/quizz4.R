library(MASS)
library(dplyr)
data("shuttle")
View(shuttle)
data("InsectSprays")
View(InsectSprays)

# q1
new_shuttle <- shuttle %>%
  mutate(autobin = ifelse(use == 'auto', 1, 0))
logfit <- glm(autobin ~ factor(wind) - 1, data = new_shuttle, family = "binomial")
coeff <- summary(logfit)$coeff[,1]
odds_coeff <- exp(coeff) # "head" is the reference
odds_ratio <- odds_coeff[1] / odds_coeff[2]
odds_ratio

# q2
new_shuttle <- shuttle %>%
  mutate(autobin = ifelse(use == 'auto', 1, 0))
logfit <- glm(autobin ~ factor(wind) + factor(magn) - 1, data = new_shuttle, family = "binomial")
coeff <- summary(logfit)$coeff[,1]
odds_coeff <- exp(coeff) # "head" is the reference
odds_ratio <- odds_coeff[1] / odds_coeff[2]
odds_ratio

# q3
new_shuttle <- shuttle %>%
  mutate(autobin = ifelse(use == 'auto', 1, 0))

fit1 <- glm(I(1 - autobin) ~ factor(wind) - 1, family = "binomial", data = new_shuttle)
summary(fit1)$coef
fit12<- glm(autobin ~ factor(wind) - 1, family = "binomial", data = new_shuttle)
summary(fit2)$coef

# q4
poissonfit <- glm(count ~ factor(spray), family = "poisson", data = InsectSprays)
exp(poissonfit$coefficients[1])/exp(poissonfit$coefficients[1]+poissonfit$coefficients[2])

# q5
fit1 <- glm(count ~ factor(spray) + offset(rep(10, nrow(InsectSprays))), family = "poisson", data = InsectSprays)
summary(fit1)$coef
fit12 <- glm(count ~ factor(spray) + offset(log(10) + rep(10, nrow(InsectSprays))), family = "poisson", data = InsectSprays)
summary(fit12)$coef

# q6
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)
plot(x,y)
knots <- 0
splineTerms <- sapply(knots, function(knot) (x > knot) * (x - knot))
xMat <- cbind(1, x, splineTerms)
fit <- lm(y ~ xMat - 1)
fit$coefficients[2]+fit$coefficients[3]
