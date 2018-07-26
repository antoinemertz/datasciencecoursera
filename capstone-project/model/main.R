cat("Load libraries...", "\n")
library(text2vec)
library(tm)
library(ngram)
library(dplyr)
library(tidytext)
library(ggplot2)
library(wordcloud)
library(stringr)
library(keras)
#install_keras()

cat("Load functions...", "\n")
source('src/text_cleaning.R')
source('src/build_ngram.R')

cat("Load data...", "\n")
twitter <- readLines("../data/us/en_US.twitter.txt")
blogs <- readLines("../data/us/en_US.blogs.txt")
news <- readLines("../data/us/en_US.news.txt")
profanity.words <- read.csv("../data/profanity_words.csv", header = FALSE)

set.seed(1234) # for reproducibility
size.sample <- 0.05 # only taking x% of the data.

# creating samples for each dataset
twitter <- sample(twitter, length(twitter) * size.sample)
blogs <- sample(blogs, length(blogs) * size.sample)
news <- sample(news, length(news) * size.sample)

cat("Clean data...", "\n")
twitter <- iconv(twitter,to = "ASCII",sub = "")
blogs <- iconv(blogs,to = "ASCII",sub = "")
news <- iconv(news,to = "ASCII",sub = "")

docs <- Corpus(VectorSource(c(twitter, blogs, news)))

docs <- TextCleaning(docs)

cat("Concatenate data...", "\n")
my_str <- stripWhitespace(paste(as.character(unlist(docs)), collapse = " "))

my_str <- gsub(x = my_str, pattern = "\b", replacement = " ")
my_str <- gsub(x = my_str, pattern = "\020", replacement = " ")
my_str <- gsub(x = my_str, pattern = "\035", replacement = " ")
my_str <- gsub(x = my_str, pattern = "\032", replacement = " ")
my_str <- gsub(x = my_str, pattern = "\037", replacement = " ")

my_str <- substr(my_str, 1, nchar(my_str)/100)

my_words <- strsplit(my_str, " ")[[1]]

# min_occurence <- 1
# 
# my_words <- (data.frame(words = my_words) %>%
#                group_by(words) %>%
#                mutate(n = n()) %>%
#                ungroup() %>%
#                mutate(words = as.character(words)) %>%
#                mutate(words = ifelse(n > min_occurence, words, "unkwn")))$words

cat("Corpus length:", length(my_words), "words", "\n")

# List of unique characters in the corpus
words <- unique(my_words)
cat("Unique words:", length(words), "\n")

maxlen <- 5 # Length of extracted words sequences

step <- 3 # We sample a new sequence every `step` words

cat("Create sequences...", "\n")
next_words <- seq(maxlen + 1, length(my_words), by = step)
sentences <- matrix(sapply(unlist(lapply(next_words, function(x) {seq(x-maxlen, x-1, by=1)})), function(x) {my_words[x]}),
                    ncol = maxlen, byrow = TRUE)
next_words <- sapply(next_words, function(x) {my_words[x]})

cat("Number of sequences: ", nrow(sentences), "\n")

# Dictionary mapping unique characters to their index in `chars`

# Next, one-hot encode the characters into binary arrays.
cat("Vectorization...", "\n")

model = train_word2vec(train_file = "output.txt",
                       output_file = "output_vectors.bin",
                       vectors=50, force=TRUE)


# create the vocab
tokens <- space_tokenizer(my_str)
it = itoken(tokens, progressbar = FALSE)
vocab <- create_vocabulary(it)

vectorizer <- vocab_vectorizer(vocab)

tcm <- create_tcm(it, vectorizer, skip_grams_window = 1)

word_vectors_size <- 50

glove <- GlobalVectors$new(word_vectors_size = word_vectors_size, vocabulary = words, x_max = 10)

word_vectors_main <- glove$fit_transform(tcm, n_iter = 10)
word_vectors <- glove$components

x <- array(0L, dim = c(nrow(sentences), maxlen, word_vectors_size))
y <- array(0L, dim = c(nrow(sentences), length(words)))

pb <- txtProgressBar(min = 1, max = nrow(sentences), style = 3)

for (i in 1:nrow(sentences)) {
  x[i,,] <- t(sapply(sentences[i,], function(x) {word_vectors[, which(colnames(word_vectors) == x)]}))
  y[i,which(next_words[i] == words)] <- 1
  Sys.sleep(0.005)
  # update progress bar
  setTxtProgressBar(pb, i)
}

model <- keras_model_sequential() %>% 
  layer_lstm(units = 128, input_shape = c(maxlen, word_vectors_size)) %>% 
  layer_dense(units = length(words), activation = "linear")

optimizer <- optimizer_rmsprop(lr = 0.01)

model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer
)

sample_next_char <- function(preds, temperature = 1.0) {
  preds <- as.numeric(preds)
  #preds <- log(preds) / temperature
  #exp_preds <- exp(preds)
  #preds <- exp_preds / sum(exp_preds)
  which.max(preds)
}

epoch <- 1
temperature <- 1.0


for (epoch in 1:10) {
  cat("epoch", epoch, "\n")
  
  # Fit the model for 1 epoch on the available training data
  model %>% fit(x, y, batch_size = 128, epochs = 1)
  
  # Select a text seed at random
  start_index <- sample(1:(length(my_words) - maxlen - 1), 1)  
  seed_text <- my_words[start_index:(start_index + maxlen - 1)]
  
  cat("--- Generating with seed:", seed_text, "\n\n")
  
  cat("------ temperature:", temperature, "\n")
  cat(seed_text, "\n")
  
  generated_text <- seed_text
  
  i <- 1
  
  sampled <- array(0, dim = c(1, maxlen, 50))
  sampled[1,,] <- t(sapply(generated_text, function(x) {word_vectors[,x]}))
  
  preds <- model %>% predict(sampled, verbose = 0)
  next_index <- sample_next_char(preds[1,], temperature)
  next_word <- words[next_index]
  cat("Next word predicted:", next_word, "\n")
  cat("True next word:", my_words[start_index + maxlen], "\n")
}
