source("src/build_sequences.R")
source("src/word_vectorization.R")
library(keras)

install_keras()

ModelTrain <- function(train_file = "output.txt", output_file = "output_vectors.bin", maxlen = 5, steps = 3,
                       word_vectors_size = 100, min_occurence = 1) {
  
  cat("Load data...", "\n")
  my_str <- readLines(train_file)
  my_words <- strsplit(my_str, " ")[[1]]
  unique_words <- unique(my_words)
  
  cat("Create sequences...", "\n")
  sequences <- CreateSequences(words = my_words, maxlen = maxlen, steps = steps)
  sentences <- sequences$sentences
  next_words <- sequences$next_words
  
  cat("Vectorization...", "\n")
  train_file <- "output.txt"
  output_file <- "output_vectors.bin"
  
  train_data <- WordVectorization(train_file, output_file, word_vectors_size,
                                  min_occurence, maxlen, sentences, unique_words, next_words)
  x <- train_data$x
  y <- train_data$y
  words_vectors <- train_data$words_vectors
  class_weight <- train_data$class_weight
  
  cat("\n", "Create model...", "\n")
  model <- keras_model_sequential() %>% 
    layer_lstm(units = 128, input_shape = c(maxlen, word_vectors_size)) %>% 
    layer_dense(units = nrow(words_vectors), activation = "softmax")
  
  optimizer <- optimizer_rmsprop(lr = 0.01)
  
  model %>% compile(
    loss = "categorical_crossentropy", 
    optimizer = optimizer
  )
  
  cat("Fit model...", "\n")
  model %>% fit(x, y, batch_size = 128, epochs = 1, class_weight = class_weight)
  
  return(list(model = model, words_vectors = words_vectors, unique_words = unique_words, class_weight = class_weight))
}