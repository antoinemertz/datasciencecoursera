setwd(dir = "/Users/antoinemertz/Documents/Perso/Perso/Coursera/Data Science - John Hopkins/")
library(readr)
hw1 <- read_csv(file = "hw1_data.csv")
View(x = hw1)

# Q11
colnames(hw1)

# Q12
hw1[1:2,]

# Q13
nrow(hw1)

# Q14
hw1[((nrow(hw1)-1):nrow(hw1)),]

# Q15
hw1$Ozone[47]

# Q16
sum(is.na(hw1$Ozone))

# Q17
mean(hw1$Ozone, na.rm = TRUE)

# Q18
mean(hw1[((hw1$Ozone > 31) & (hw1$Temp > 90)),]$Solar.R, na.rm = TRUE)

# Q19
mean(hw1[hw1$Month == 6,]$Temp, na.rm = TRUE)

# Q20
max(hw1[hw1$Month == 5,]$Ozone, na.rm = TRUE)
