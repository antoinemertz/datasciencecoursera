cat("Load libraries...", "\n")
library(tm)
library(wordVectors)
library(dplyr)
library(keras)
# install_keras()

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

my_str <- c(twitter, blogs, news)
my_str <- paste(my_str, collapse = " ")

cat("Clean data...", "\n")
my_str <- TextCleaning(my_str)

cat("Concatenate data...", "\n")
my_str <- substr(my_str, 1, nchar(my_str)/100)

my_words <- strsplit(my_str, " ")[[1]]

min_occurence <- 1

# my_words <- (data.frame(words = my_words) %>%
#                group_by(words) %>%
#                mutate(n = n()) %>%
#                ungroup() %>%
#                mutate(words = as.character(words)) %>%
#                mutate(words = ifelse(n > min_occurence, words, "unkwn")))$words
# 
# my_str <- paste(my_words, collapse = " ")

train_file <- "output.txt"

writeLines(my_str, "output.txt")

cat("Corpus length:", length(my_words), "words", "\n")

# List of unique characters in the corpus
unique_words <- unique(my_words)
cat("Unique words:", length(unique_words), "\n")

maxlen <- 5 # Length of extracted words sequences
step <- 3 # We sample a new sequence every `step` words

cat("Create sequences...", "\n")
sequences <- CreateSequences(my_words, maxlen, steps)
sentences <- sequences$sentences
next_words <- sequences$next_words

cat("Number of sequences: ", nrow(sentences), "\n")

# Dictionary mapping unique characters to their index in `chars`

# Next, one-hot encode the characters into binary arrays.
cat("Vectorization...", "\n")
word_vectors_size <- 50
train_file <- "output.txt"
output_file <- "output_vectors.bin"

train_data <- WordVectorization(train_file, output_file, word_vectors_size,
                                min_occurence, maxlen, sentences, unique_words, next_words)
x <- train_data$x
y <- train_data$y

model <- keras_model_sequential() %>% 
  layer_lstm(units = 128, input_shape = c(maxlen, word_vectors_size)) %>% 
  layer_dense(units = length(unique_words), activation = "softmax")

optimizer <- optimizer_rmsprop(lr = 0.01)

model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer
)

model %>% fit(x, y, batch_size = 128, epochs = 1)



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
  
  sampled <- array(0, dim = c(1, maxlen, word_vectors_size))
  sampled[1,,] <- t(sapply(generated_text, function(x) {words_vectors[rownames(words_vectors) == x,]}))
  
  preds <- model %>% predict(sampled, verbose = 0)
  next_index <- sample_next_char(preds[1,], temperature)
  next_word <- unique_words[next_index]
  cat("Next word predicted:", next_word, "\n")
  cat("True next word:", my_words[start_index + maxlen], "\n")
}
