# Q1
n = 9
avg = 1100
std = 30
alpha = 0.05
cu = round(avg + qt(1-alpha/2, df = (n-1)) * (std / sqrt(n)))
cl = round(avg - qt(1-alpha/2, df = (n-1)) * (std / sqrt(n)))
print(paste0("Answer: [", cl, ", ", cu, "]"))

# Q2
n = 9
avg = 0
xbarre = -2
alpha = 0.05
cu = 0
ans = round(cu - (xbarre - avg) / (qt(1-alpha/2, df = (n-1)) / sqrt(n)), 2)
print(paste0("Answer: ", ans))

# Q3
n = 9
avg = 0
xbarre = -2
alpha = 0.05
cu = 0
ans = round(cu - (xbarre - avg) / (qt(1-alpha/2, df = (n-1)) / sqrt(n)), 2)
print(paste0("Answer: ", ans))

# Q4
n_x = 9 # old system
n_y = 9 # new system
var_y <- 0.60
var_x <- 0.68
avg_y <- 3
avg_x <- 5
alpha = 0.05

# calculate pooled standard deviation
std_p <- sqrt(((n_x - 1) * var_x + (n_y - 1) * var_y)/(n_x + n_y - 2))

cu <- (avg_y - avg_x) + qt(1-alpha/2, df=n_y+n_x-2) * std_p * sqrt(1 / n_x + 1 / n_y)
cl <- (avg_y - avg_x) - qt(1-alpha/2, df=n_y+n_x-2) * std_p * sqrt(1 / n_x + 1 / n_y)
print(paste0("Answer: [", cl, ", ", cu, "]"))

# Q5
# because t_0.95 < t_0.975

# Q6
n1 <- n2 <- 100
xbar1 <- 4
xbar2 <- 6
s1 <- 0.5
s2 <- 2
xbar2 - xbar1 + c(-1, 1) * qnorm(0.975) * sqrt(s1^2/n1 + s2^2/n2)

# Q7
n1 <- n2 <- 9
x1 <- -3 ##treated
x2 <- 1 ##placebo
s1 <- 1.5 ##treated
s2 <- 1.8 ##placebo
s <- sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2)/(n1 + n2 - 2))
(x1 - x2) + c(-1, 1) * qt(0.95, n1 + n2 - 2) * s * sqrt(1/n1 + 1/n2)