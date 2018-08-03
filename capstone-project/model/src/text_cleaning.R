library(tm)

CorpusCleaning <- function(docs, stop_words = TRUE) {
  # Remove hashtags
  removeHashtags <- function(x) {
    gsub("#[[:alnum:]]*", "", x)
  }
  docs <- tm_map(docs, removeHashtags)
  # Convert upper letters to lower
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove profanity words
  docs <- tm_map(docs, removeWords, profanity.words$V1)
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english stop words
  if (stop_words) {
    docs <- tm_map(docs, removeWords, stopwords("english"))
  }
  # Remove punctuation
  docs <- tm_map(docs, removePunctuation)
  # Remove useless white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Remove URLs
  removeURL <- function(x) {
    gsub(pattern = "http[[:alnum:]]*", replacement = "", x = x)
  }
  docs <- tm_map(docs, removeURL)
  # Remove useless white spaces
  docs <- tm_map(docs, stripWhitespace)
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove punctuation
  docs <- tm_map(docs, removePunctuation)
  return(docs)
}

TextCleaning <- function(string, profanity.words = read.csv("../data/profanity_words.csv", header = FALSE)) {
  
  string <- iconv(string,to = "ASCII",sub = "")
  
  # Remove hashtags
  removeHashtags <- function(x) {
    gsub("#[[:alnum:]]*", "", x)
  }
  string <- removeHashtags(string)
  # Convert upper letters to lower
  string <- tolower(string)
  # Remove profanity words
  string <- removeWords(string, profanity.words$V1)
  # Remove numbers
  string <- removeNumbers(string)
  # Remove english stop words
  # docs <- tm_map(docs, removeWords, stopwords("english"))
  # Remove punctuation
  string <- removePunctuation(string)
  # Remove useless white spaces
  string <- stripWhitespace(string)
  # Remove URLs
  removeURL <- function(x) {
    gsub(pattern = "http[[:alnum:]]*", replacement = "", x = x)
  }
  string <- removeURL(string)
  
  string <- gsub(x = string, pattern = "\b", replacement = " ")
  string <- gsub(x = string, pattern = "\020", replacement = " ")
  string <- gsub(x = string, pattern = "\035", replacement = " ")
  string <- gsub(x = string, pattern = "\032", replacement = " ")
  string <- gsub(x = string, pattern = "\037", replacement = " ")
  
  return(string)
}