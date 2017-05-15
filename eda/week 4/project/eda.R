# Load the data
pm25 <- readRDS("data/summarySCC_PM25.rds")

# library
library(dplyr)
library(ggplot2)

# display the first lines
pm25 %>%
  head(3L)

# fast first look
str(pm25)

# sum by year
pm25.by.year <- pm25 %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# first plot
with(pm25.by.year, plot(year, Emissions, type = "b", pch = 20, main = "PM25 emissions by year"))

# for the Baltimore city (fips == "24510")
pm25.baltimore <- pm25 %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# second plot
with(pm25.baltimore, plot(year, Emissions, type = "b", pch = 20, main = "PM25 emissions by year in Baltimore city"))

# for the Baltimore city and according to the type of sources (fips == "24510")
pm25.by.sources <- pm25 %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# third plot
pm25.by.sources %>%
  ggplot(aes(x = year, y = Emissions, color = type)) +
  geom_line() +
  ggtitle("PM25 emissions by year in Baltimore city according to type sources") +
  theme(plot.title = element_text(hjust = 0.5))

# load other data source
sources <- readRDS("data/Source_Classification_Code.rds")

coal.sources <- sources[grepl("Coal", sect),]
scc.coal <- coal.sources$SCC

pm25.coal <- pm25 %>%
  filter(SCC %in% scc.coal) %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# fourth plot
pm25.coal %>%
  ggplot(aes(x = year, y = Emissions)) +
  geom_line() +
  ggtitle("PM25 emissions from coal combustion-related sources") +
  theme(plot.title = element_text(hjust = 0.5))

# emissions from motor vehicle in Baltimore City
pm25.road.baltimore <- pm25 %>%
  filter(fips == "24510") %>%
  filter(type == "ON-ROAD") %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

pm25.road.baltimore %>%
  ggplot(aes(x = year, y = Emissions)) +
  geom_line() +
  ggtitle("PM25 emissions from motor vehicle in Baltimore city") +
  theme(plot.title = element_text(hjust = 0.5))

# compare emissions from motor vehicle in Baltimore City and Los Angeles County (fips == "06037")
pm25.compare <- pm25 %>%
  filter((fips == "24510") | (fips == "06037")) %>%
  filter(type == "ON-ROAD") %>%
  group_by(fips, year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  mutate(city = ifelse(fips == "24510", "Baltimore", ifelse(fips == "06037", "Los Angeles", NA))) %>%
  as.data.frame()

pm25.compare %>%
  ggplot(aes(x = year, y = Emissions, color = city)) +
  geom_line() +
  ggtitle("Motor Vehicle Emissions in Baltimore vs. Los Angeles") +
  theme(plot.title = element_text(hjust = 0.5))
