#setwd("Documents/Perso/Perso/Coursera/Data Science - John Hopkins/datasciencecoursera/ProgrammingAssignment3/")

best <- function(state, outcome) {
  # read csv file
  df <- read.csv("data/outcome-of-care-measures.csv", colClasses = "character")

  # check that state is valid
  st <- levels(as.factor(df$State))
  if (!(state %in% st)) {
    stop("invalid state")
  }

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

  df.state <- df[df$State == state,]
  nm <- df.state$Hospital.Name[which.min(as.numeric(df.state[,nc]))]

  return(nm)
}
