#setwd("Documents/Perso/Perso/Coursera/Data Science - John Hopkins/datasciencecoursera/ProgrammingAssignment3/")

rankhospital <- function(state, outcome, num = "best") {
  library(dplyr)

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

  df.state <- df[df$State == state,c(2,nc)]
  names(df.state) <- c("Hospital.Name", "Rate")
  df.state$Rate <- as.numeric(df.state$Rate)
  n <- nrow(df.state)
  if (is.numeric(num)) {
    if (num > n) {
      return(NA)
    } else {
      df.sort <- df.state %>%
        arrange(Rate, Hospital.Name) %>%
        mutate(Rank = row_number())
    }
  } else {
    df.sort <- df.state %>%
      arrange(Rate, Hospital.Name) %>%
      mutate(Rank = row_number())
  }

  if (num == "best") {
    num = 1
  } else if (num == "worst") {
    num = nrow(df.sort[!(is.na(df.sort$Rate)),])
  } else if (!(is.numeric(num))) {
    stop("invalid num")
  }

  return(df.sort[num,"Hospital.Name"])
}
