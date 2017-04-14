## Read from MySQL
library(RMySQL)

uscs <- dbConnect(MySQL(), user = "genome", host = "genome-mysql.cse.ucsc.edu")

databases.list <- dbGetQuery(uscs, "show databases;")
dbDisconnect(uscs)

# focus on the db hg19
hg19 <- dbConnect(MySQL(), user = "genome", host = "genome-mysql.cse.ucsc.edu", db = "hg19")

tables.list <- dbListTables(hg19)

columns.list <- dbListFields(hg19, "affyU133Plus2")

dbGetQuery(hg19, "select count(*) from affyU133Plus2;")

affyU133Plus <- dbReadTable(hg19, "affyU133Plus2")

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3;")
affyMis <- fetch(query)
affyMisSmall <- fetch(query, n=10)
dbClearResult(query)

dbDisconnect(hg19)

## Web scrapping
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = TRUE)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "////td[@id='col-citedby']", xmlValue)

library(httr)
html <- GET(url)
content <- content(html, as="text")
parsedHtml <- htmlParse(content, asText = TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)
