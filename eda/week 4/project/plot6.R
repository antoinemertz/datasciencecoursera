# load the data
pm25 <- readRDS("summarySCC_PM25.rds")

# load library
library(dplyr)
library(ggplot2)

# compare total emissions from motor vehicle in Baltimore City (fips == "24510") and in Los Angeles County (fips == "06037")
pm25.compare <- pm25 %>%
  filter((fips == "24510") | (fips == "06037")) %>%
  filter(type == "ON-ROAD") %>%
  group_by(fips, year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  mutate(city = ifelse(fips == "24510", "Baltimore", ifelse(fips == "06037", "Los Angeles", NA))) %>%
  as.data.frame()

# sixth plot
png('plot6.png')
pm25.compare %>%
  ggplot(aes(x = year, y = Emissions, color = city)) +
  geom_line() +
  ggtitle("Motor Vehicle Emissions in Baltimore vs. Los Angeles") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()