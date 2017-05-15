# load the data
pm25 <- readRDS("summarySCC_PM25.rds")
sources <- readRDS("Source_Classification_Code.rds")

# load library
library(dplyr)
library(ggplot2)

# total emissions from coal combustion-related sources by year
sect <- sources$Short.Name
coal.sources <- sources[grepl("Coal", sect),]
scc.coal <- coal.sources$SCC

pm25.coal <- pm25 %>%
  filter(SCC %in% scc.coal) %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions)) %>%
  as.data.frame()

# make plot
png('plot4.png')
pm25.coal %>%
  ggplot(aes(x = year, y = Emissions)) +
  geom_line() +
  ggtitle("PM25 emissions from coal combustion-related sources") +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()