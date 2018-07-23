BiGram <- function(string, file.save) {
  ng2 <- get.phrasetable(ngram(string, n = 2))
  n_grams <- strsplit(ng2$ngrams, " ")
  ng2 <- ng2 %>%
    mutate(first_word = sapply(n_grams, function(x) {x[1]})) %>%
    mutate(next_word = sapply(n_grams, function(x) {x[-1]})) %>%
    select(-c(ngrams))
  write.csv(ng2, file.save, row.names = FALSE)
  return(NULL)
}

TriGram <- function(string, file.save) {
  ng3 <- get.phrasetable(ngram(string, n = 3))
  n_grams <- strsplit(ng3$ngrams, " ")
  ng3 <- ng3 %>%
    mutate(first_word = sapply(n_grams, function(x) {x[1]})) %>%
    mutate(second_word = sapply(n_grams, function(x) {x[2]})) %>%
    mutate(next_word = sapply(n_grams, function(x) {x[3]})) %>%
    select(-c(ngrams))
  write.csv(ng3, file.save, row.names = FALSE)
  return(NULL)
}

FourGram <- function(string, file.save) {
  ng4 <- get.phrasetable(ngram(string, n = 4))
  n_grams <- strsplit(ng4$ngrams, " ")
  ng4 <- ng4 %>%
    mutate(first_word = sapply(n_grams, function(x) {x[1]})) %>%
    mutate(second_word = sapply(n_grams, function(x) {x[2]})) %>%
    mutate(third_word = sapply(n_grams, function(x) {x[3]})) %>%
    mutate(next_word = sapply(n_grams, function(x) {x[4]})) %>%
    select(-c(ngrams))
  write.csv(ng4, file.save, row.names = FALSE)
  return(NULL)
}

FiveGram <- function(string, file.save) {
  ng5 <- get.phrasetable(ngram(string, n = 5))
  n_grams <- strsplit(ng5$ngrams, " ")
  ng5 <- ng5 %>%
    mutate(first_word = sapply(n_grams, function(x) {x[1]})) %>%
    mutate(second_word = sapply(n_grams, function(x) {x[2]})) %>%
    mutate(third_word = sapply(n_grams, function(x) {x[3]})) %>%
    mutate(fourth_word = sapply(n_grams, function(x) {x[4]})) %>%
    mutate(next_word = sapply(n_grams, function(x) {x[5]})) %>%
    select(-c(ngrams))
  write.csv(ng5, file.save, row.names = FALSE)
  return(NULL)
}