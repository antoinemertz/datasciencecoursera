## Q1

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, destfile = "data/acs.csv", method = "curl")
acs = read.csv("data/acs.csv")

split.names <- strsplit(names(acs), "wgtp")
split.names[[123]]

## Q2
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url, "data/gdp.csv", method = "curl")
gdp <- read.csv("data/gdp.csv", skip = 4, nrow = 215)
gdp <- gdp[gdp$X != "",]
gdp <- gdp %>%
  select(X, X.1, X.3, X.4) %>%
  rename(CountryCode = X, rankingGDP = X.1,
         Long.Name = X.3, gdp = X.4)
gdp$gdp <- gsub(",", "",gdp$gdp)
mean(as.numeric(gdp$gdp), na.rm = TRUE)

## Q3
grep("^United", gdp$Long.Name)

## Q4
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

is.fiscal.year.end <- grepl("fiscal year end", tolower(df$Special.Notes))
is.june <- grepl("june", tolower(df$Special.Notes))
table(is.fiscal.year.end, is.june)

## Q5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
grepl("^2012")