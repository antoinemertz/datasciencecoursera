library(tm)
library(dplyr)
library(tidytext)
library(ggplot2)
library(wordcloud)

twitter <- readLines("../data/us/en_US.twitter.txt")
blogs <- readLines("../data/us/en_US.blogs.txt")
news <- readLines("../data/us/en_US.news.txt")
profanity.words <- read.csv("../data/profanity_words.csv", header = FALSE)

set.seed(1234) #for reproducibility
size.sample <- 0.05 #only taking 5% of the data.

# creating samples for each dataset
# twitter.sample <- sample(twitter, length(twitter) * size.sample)
# blogs.sample <- sample(blogs, length(blogs) * size.sample)
# news.sample <- sample(news, length(news) * size.sample)

twitter.sample = twitter
blogs.sample = blogs
news.sample = news

# cleaning
twitter.sample <- iconv(twitter.sample,to = "ASCII",sub = "")
blogs.sample <- iconv(blogs.sample,to = "ASCII",sub = "")
news.sample <- iconv(news.sample,to = "ASCII",sub = "")

docs <- Corpus(VectorSource(c(twitter.sample, blogs.sample, news.sample)))

# Remove hashtags
removeHashtags <- function(x) {
  gsub("#[[:alnum:]]*", "", x)
}
docs <- tm_map(docs, removeHashtags)
# Convertir le texte en minuscule
docs <- tm_map(docs, content_transformer(tolower))
# Supprimer votre propre liste de mots non desires
docs <- tm_map(docs, removeWords, profanity.words$V1)
# Supprimer les nombres
docs <- tm_map(docs, removeNumbers)
# Supprimer les mots vides anglais
docs <- tm_map(docs, removeWords, stopwords("english"))
# Supprimer les ponctuations
docs <- tm_map(docs, removePunctuation)
# Supprimer les espaces vides supplementaires
docs <- tm_map(docs, stripWhitespace)
# Supprimer les URLs
# remove urls
removeURL <- function(x) {
  gsub(pattern = "http[[:alnum:]]*", replacement = "", x = x)
}
docs <- tm_map(docs, removeURL)

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

## n-gram models
BigramTokenizer <- function(x) {
  unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
}

tdm_bigram <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
inspect(removeSparseTerms(tdm_bigram[, 1:10], 0.1))
