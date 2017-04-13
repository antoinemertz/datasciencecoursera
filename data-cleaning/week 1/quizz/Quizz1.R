url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(url=url, destfile="data/house_idaho.csv", method = "curl")
house.idaho = read.csv("data/house_idaho.csv")
sum(house.idaho$VAL == 24, na.rm = TRUE)


##

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

library(xlsx)
download.file(url=url, destfile="data/ngap.xlsx", method = "curl")
dat = xlsx::read.xlsx("data/ngap.xlsx", sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
sum(dat$Zip*dat$Ext,na.rm=T)


##

url = "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

library(XML)
restau.baltimore = XML::xmlTreeParse(url, useInternalNodes = TRUE)
rootNode = xmlRoot(restau.baltimore)
zipcodes = as.numeric(xpathSApply(rootNode, "//zipcode", xmlValue))
sum(zipcodes == 21231)


##

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

library(data.table)
download.file(url=url, destfile="data/acs_us_communities.csv", method = "curl")
DT = fread("data/acs_us_communities.csv")

system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(c(mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15)))
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(c(rowMeans(DT)[DT$SEX==1], rowMeans(DT)[DT$SEX==2]))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
