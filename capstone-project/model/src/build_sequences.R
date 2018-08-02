CreateSequences <- function(words, maxlen, steps) {
  next_words <- seq(maxlen + 1, length(words), by = steps)
  sentences <- matrix(sapply(unlist(lapply(next_words, function(x) {seq(x-maxlen, x-1, by=1)})),
                             function(x) {words[x]}),
                      ncol = maxlen, byrow = TRUE)
  next_words <- sapply(next_words, function(x) {words[x]})
  return(list(sentences = sentences, next_words = next_words))
}