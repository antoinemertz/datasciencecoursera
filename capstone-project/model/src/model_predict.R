library(dplyr)
source("src/text_cleaning.R")
source("src/model_train.R")

ModelPrediction <- function(text) {
  text <- TextCleaning(text)
  words <- strsplit(text, " ")[[1]]
  maxlen <- length(words)
  
  word_vectors_size <- 100
  min_occurence <- 1
  
  training <- ModelTrain(train_file = "output.txt", output_file = "output_vectors.bin", maxlen = maxlen, steps = 3,
                         word_vectors_size = word_vectors_size, min_occurence = min_occurence)
  cat("Model fitted...", "\n")
  model <- training$model
  words_vectors <- training$words_vectors
  x <- training$x
  y <- training$y
  class_weight <- training$class_weight
  
  prediction <- function(x) {
    if (x %in% rownames(words_vectors)) {
      return(words_vectors[rownames(words_vectors) == x,])
    } else {
      return(words_vectors[1,])
    }
  }
  
  sampled <- array(0L, dim = c(1, maxlen, word_vectors_size))
  sampled[1,,] <- t(sapply(words, prediction))
  
  preds <- data.frame(proba = (model %>% predict(sampled, verbose = 0))[1,], words = rownames(words_vectors)) %>%
    arrange(desc(proba))
  
  return(list(model = model, sampled = sampled, words_vectors = words_vectors, x = x, y = y, words  = words, maxlen = maxlen, word_vectors_size = word_vectors_size, preds = preds, class_weight = class_weight))
}