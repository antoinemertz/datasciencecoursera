# Q1
subject <- c(1,2,3,4,5)
baseline <- c(140,138,150,148,135)
week2 <- c(132,135,151,146,130)
examinations <- data.frame(subject, baseline, week2)
examinations
t.test(x = examinations$baseline, y = examinations$week2, paired = TRUE)

# Q2
n <- 9
mu <- 1100
sigma <- 30
quantile <- 1-0.05/2 # is 95% with 2.5% on both sides of the range
confidenceInterval = mu + c(-1, 1) * qt(quantile, df=n-1) * sigma / sqrt(n)
confidenceInterval

# Q3
n <- 4
x <- 3
test <- binom.test(x=x, n=n, alt="greater")
round(test$p.value,2)

# Q4
rate <- 1/100
errors <- 10
days <- 1787
test <-  poisson.test(errors, T = days, r = rate, alt="less")
round(test$p.value,2)

# Q5
n_y <- 9 # subjects treated
n_x <- 9 # subjects placebo
sigma_y <- 1.5 # kg/m2 std.dev. treated
sigma_x <- 1.8 # kg/m2 std.dev. placebo
moy_y <- -3 #  kg/m2 average difference treated
moy_x <- 1 # kg/m2 average difference placebo

sigma_p <- (((n_x - 1) * sigma_x^2 + (n_y - 1) * sigma_y^2)/(n_x + n_y - 2))
pval <- pt((moy_y - moy_x) / (sigma_p * (1 / n_x + 1 / n_y)^.5), df=n_y + n_x -2)
pval

# Q7
n <- 100 #subject
moy <- 0.01# m^3 brain volume loss mean
sigma <- 0.04# m^3 brain volume loss std. dev.
p <- 0.05 # sign level

pow <- power.t.test(n=n, delta=moy, sd=sigma , sig.level=p, type="one.sample", alt="one.sided")$power
round(pow, 2)

# Q8
moy <- 0.01# m^3 brain volume loss mean
sigma <- 0.04# m^3 brain volume loss std. dev.
p <- 0.05 # sign level
pow <- 0.9 #power

n <- power.t.test(power=pow, delta=moy, sd=sigma , sig.level=p, type="one.sample", alt="one.sided")$n
ceiling(n/10)*10