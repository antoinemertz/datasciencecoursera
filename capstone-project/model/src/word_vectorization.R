library(wordVectors)

WordVectorization <- function(train_file, output_file, word_vectors_size, min_occurence, maxlen, sentences, unique_words, next_words) {
  words_vectors <- train_word2vec(train_file = train_file,
                                  output_file = output_file,
                                  vectors = word_vectors_size,
                                  force = TRUE,
                                  min_count = min_occurence)@.Data
  
  x <- array(0L, dim = c(nrow(sentences), maxlen, word_vectors_size))
  y <- array(0L, dim = c(nrow(sentences), nrow(words_vectors)))
  
  pb <- txtProgressBar(min = 1, max = nrow(sentences), style = 3)
  
  for (i in 1:nrow(sentences)) {
    x[i,,] <- t(sapply(sentences[i,], function(x) {words_vectors[rownames(words_vectors) == x,]}))
    y[i,which(next_words[i] == rownames(words_vectors))] <- 1
    Sys.sleep(0.005)
    # update progress bar
    setTxtProgressBar(pb, i)
  }
  
  return(list(x = x, y = y, words_vectors = words_vectors))
}
