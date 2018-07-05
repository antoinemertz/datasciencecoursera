us_blog <- readLines("../data/us/en_US.blogs.txt")
us_twitter <- readLines("../data/us/en_US.twitter.txt")
us_news <- readLines("../data/us/en_US.news.txt")

#q1
file.info("data/en_US/en_US.blogs.txt")$size

#q2
length(us_twitter)

#q3

max(sapply(us_blog, nchar))
max(sapply(us_twitter, nchar))
max(sapply(us_news, nchar))

#q4
us_twitter_lower <- sapply(us_twitter, tolower)
sum(grepl(pattern = "love", x = us_twitter_lower)) / sum(grepl(pattern = "hate", x = us_twitter_lower))

#q5
us_twitter[grep(pattern = "biostats", x = us_twitter)]

#q6
length(grep(pattern = "A computer once beat me at chess, but it was no match for me at kickboxing", x = us_twitter))
