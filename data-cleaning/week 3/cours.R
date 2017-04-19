fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/restaurants.csv", method = "curl")
restData <- read.csv(file = "data/reastaurants.csv")
summary(restData)
str(restData)
colSums(is.na(restData))
table(restData$zipCode %in% c(21231, 21211))
restData[restData$zipCode %in% c(21231, 21211),]

data("UCBAdmissions")
df = as.data.frame(UCBAdmissions)
xtabs(Freq ~ Gender + Admit, data=df)



x = sample(1:100, 5, replace = FALSE)
seq(along = x)
restData$zipGroup <- cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroup, restData$zipCode)


data("mtcars")
mtcars <- as.data.frame(mtcars)
library(reshape2)
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id = c("carname", "gear", "cyl"), measure.vars = c("mpg", "hp"))
dcast(carMelt, cyl ~ variable, mean)


data("InsectSprays")
InsectSprays <- as.data.frame(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)
sprCount <- split(InsectSprays$count, InsectSprays$spray)
unlist(lapply(sprCount, sum))
library(plyr)
ddply(InsectSprays, .(spray), summarize, sum=sum(count))


library(dplyr)
chicago <- readRDS("./data/chicago.rds")

chicago %>%
  select(city:dptp) %>%
  head(3L)

chicago %>%
  select(-(city:dptp)) %>%
  head(3L)

chicago %>%
  filter(pm25tmean2 > 30 & tmpd > 80) %>%
  head(3L)

chicago %>%
  arrange(date) %>%
  head(3L)

chicago %>%
  arrange(desc(date)) %>%
  head(3L)

chicago <- chicago %>%
  rename(pm25 = pm25tmean2, dewpoint = dptp)
chicago %>% head(3L)

chicago <- chicago %>%
  mutate(pm25detrend = pm25-mean(pm25,na.rm=TRUE))
chicago %>% head(3L)

chicago %>%
  mutate(tempcat = factor(ifelse((1*tmpd) > 80,"cold","hot"))) %>%
  group_by(tempcat) %>%
  summarise(pm25 = mean(pm25,na.rm=TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))


url1 <- "https://dl.dropboxusercontent.com/u/7710864/ata/reviews-apr29.csv"
url2 <- "https://dl.dropboxusercontent.com/u/7710864/ata/solutions-apr29.csv"
download.file(url1, "./data/reviews.csv",method="curl")
download.file(url2, "./data/solutions.csv",method="curl")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
mergedData <- merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = TRUE)
