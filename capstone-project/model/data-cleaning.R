library(tm)
library(ngram)
library(dplyr)
library(tidytext)
library(ggplot2)
library(wordcloud)

source('src/text_cleaning.R')
source('src/build_ngram.R')

twitter <- readLines("../data/us/en_US.twitter.txt")
blogs <- readLines("../data/us/en_US.blogs.txt")
news <- readLines("../data/us/en_US.news.txt")
profanity.words <- read.csv("../data/profanity_words.csv", header = FALSE)

set.seed(1234) # for reproducibility
size.sample <- 0.25 # only taking x% of the data.

# creating samples for each dataset
twitter <- sample(twitter, length(twitter) * size.sample)
blogs <- sample(blogs, length(blogs) * size.sample)
news <- sample(news, length(news) * size.sample)

# cleaning
twitter <- iconv(twitter,to = "ASCII",sub = "")
blogs <- iconv(blogs,to = "ASCII",sub = "")
news <- iconv(news,to = "ASCII",sub = "")

docs <- Corpus(VectorSource(c(twitter, blogs, news)))

docs <- TextCleaning(docs)

my_str <- stripWhitespace(paste(as.character(unlist(docs)), collapse = " "))

load(file = '../data/clean-corpus.RData')

dtm <- DocumentTermMatrix(docs)
word_freq <- dtm %>%
  tidy() %>%
  select(-c(document)) %>%
  group_by(term) %>%
  summarize(n = sum(count)) %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  filter(row_number() < 501) %>%
  as.data.frame()

# top word
word_freq %>%
  arrange(desc(n)) %>%
  filter(row_number() < 21) %>%
  mutate(word = factor(term, levels = term[order(n, decreasing = TRUE)])) %>%
  ggplot(aes(x = word, weight = n)) +
    geom_bar() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

wordcloud(words = word_freq$term, freq = word_freq$n, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))

## n-gram creation

BiGram(my_str, '../data/2-gram.csv')

TriGram(my_str, '../data/3-gram.csv')

FourGram(my_str, '../data/4-gram.csv')

FiveGram(my_str, '../data/5-gram.csv')

