## Q1

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, destfile = "data/acs.csv", method = "curl")
acs = read.csv("data/acs.csv")

library(dplyr)
df <- acs %>%
  mutate(agricultureLogical = (ACR == 3 & AGS == 6))
which(df$agricultureLogical)

## Q2

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url, destfile = "data/image.jpg", method = "curl")

library(jpeg)
image <- readJPEG("data/image.jpg", native = TRUE)
quantile(image, c(0.3, 0.8))

## Q3

url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url1, "data/gdp.csv", method = "curl")
download.file(url2, "data/educational.csv", method = "curl")
gdp <- read.csv("data/gdp.csv", skip = 4, nrow = 215)
gdp <- gdp[gdp$X != "",]
gdp <- gdp %>%
  select(X, X.1, X.3, X.4) %>%
  rename(CountryCode = X, rankingGDP = X.1,
         Long.Name = X.3, gdp = X.4)
educational <- read.csv("data/educational.csv")

df <- merge(gdp, educational, all = TRUE, by = "CountryCode")
sum(!is.na(unique(df$rankingGDP)))
df %>%
  arrange(desc(rankingGDP)) %>%
  filter(row_number() == 13)

## Q4

df %>%
  group_by(Income.Group) %>%
  summarise(mean(rankingGDP, na.rm = TRUE))

## Q5
breaks <- quantile(df$rankingGDP, probs = seq(0, 1, 0.2), na.rm = TRUE)
df$quantileGDP <- cut(df$rankingGDP, breaks = breaks)
table(df$quantileGDP, df$Income.Group)
