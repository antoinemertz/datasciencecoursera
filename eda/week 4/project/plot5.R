# load the data
pm25 <- readRDS("summarySCC_PM25.rds")

# load library
library(dplyr)
library(ggplot2)

# total emissions from motor vehicle in Baltimore City (fips == "24510")
pm25.road.baltimore <- pm25 %>%
  filter(fips == "24510") %>%
  filter(type == "ON-ROAD") %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# make plot
png('plot5.png')
pm25.road.baltimore %>%
  ggplot(aes(x = year, y = Emissions)) +
  geom_line() +
  ggtitle("PM25 emissions from motor vehicle in Baltimore city") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()