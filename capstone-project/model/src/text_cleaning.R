TextCleaning <- function(docs) {
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
  docs <- tm_map(docs, removeWords, stopwords("english"))
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
