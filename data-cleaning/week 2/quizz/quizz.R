## Q1

library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "8724cc6ed785a92ac46d",
                   secret = "398564378fcd1b4a4f0e14546780ddc948f12681")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content <- content(req)
for (i in 1:length(content)) {
  print(paste(i, ":", content[[i]]$name))
}
content[[11]]$created_at

## Q2
acs <- read.csv("data/acs.csv")

## Q3
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
content <- readLines(con)
nchar(content[10])
nchar(content[20])
nchar(content[30])
nchar(content[100])

## Q5
x <- read_fwf(file = "data/sst_df.for", skip=4, fwf_widths(c(12, 7, 4, 9, 4, 9, 4, 9, 4)))
sum(x[,4])
