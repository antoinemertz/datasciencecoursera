# load the data
pm25 <- readRDS("summarySCC_PM25.rds")

# load library
library(dplyr)

# total emissions by yearin US
pm25.by.year <- pm25 %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# make plot
png('plot1.png')
with(pm25.by.year, plot(year, Emissions, type = "b", pch = 20, main = "PM25 emissions by year"))
dev.off()