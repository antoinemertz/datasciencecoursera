# load the data
pm25 <- readRDS("summarySCC_PM25.rds")

# load library
library(dplyr)

# total emissions by year for the Baltimore city (fips == "24510")
pm25.baltimore <- pm25 %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# make plot
png('plot2.png')
with(pm25.baltimore, plot(year, Emissions, type = "b", pch = 20, main = "PM25 emissions by year in Baltimore city"))
dev.off()