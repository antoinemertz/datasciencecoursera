setwd("Documents/Perso/Perso/Coursera/Data Science - John Hopkins/datasciencecoursera/ProgrammingAssignment3/")

rankall <- function(outcome, num = "best") {
  library(dplyr)
  source("rankhospital.R")
  # read csv file
  df <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")

  # check that outcome is valid
  out <- c("heart attack", "heart failure", "pneumonia")
  if (!(outcome %in% out)) {
    stop("invalid outcome")
  } else {
    if (outcome == out[1]) {
      nc <- 11
    } else if (outcome == out[2]) {
      nc <- 17
    } else if (outcome == out[3]) {
      nc <-23
    }
  }

  states <- levels(as.factor(df$State))
  hos <- rep(NULL, length(states))
  for (i in 1:length(states)) {
    st <- states[i]
    hos[i] <- rankhospital(st, outcome, num)
  }

  res <- data.frame(hospital = hos, state = states)

  return(res)
}

