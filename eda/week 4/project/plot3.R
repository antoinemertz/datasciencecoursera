# load the data
pm25 <- readRDS("summarySCC_PM25.rds")

# load library
library(dplyr)
library(ggplot2)

# total emissions according to the type of sources by year for the Baltimore city (fips == "24510")
pm25.by.sources <- pm25 %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# make plot
png('plot3.png')
pm25.by.sources %>%
  ggplot(aes(x = year, y = Emissions, color = type)) +
  geom_line() +
  ggtitle("PM25 emissions by year in Baltimore city according to type sources") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()