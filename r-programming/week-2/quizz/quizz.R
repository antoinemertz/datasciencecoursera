pollutantmean <- function (directory = "specdata", polluant, id=1:332) {
  sulfate <- NULL
  nitrate <- NULL
  for (i in id) {
    file <- paste0(directory, "/", sprintf("%03d", i), ".csv")
    df <- read.csv(file)
    sulfate <- c(sulfate, df$sulfate)
    nitrate <- c(nitrate, df$nitrate)
  }
  mean.sulfate <- mean(sulfate, na.rm = TRUE)
  mean.nitrate <- mean(nitrate, na.rm = TRUE)
  
  mean.polluant = data.frame(sulfate = mean.sulfate, nitrate = mean.nitrate)
  
  if (length(polluant) > 1) {
    return(mean.polluant)
  } else {
    if (polluant == "sulfate") {
      return(mean.polluant$sulfate)
    } else if (polluant == "nitrate") {
      return(mean.polluant$nitrate)
    } else {
      return(warning("polluant is not valid"))
    }
  }
}

complete <- function(directory = "specdata", id=1:332) {
  n <- NULL
  for (i in id) {
    file <- paste0(directory, "/", sprintf("%03d", i), ".csv")
    df <- read.csv(file)
    n.nitrate <- !is.na(df$nitrate)
    n.sulfate <- !is.na(df$sulfate)
    n.df <- n.nitrate & n.sulfate
    n <- c(n, sum(n.df))
  }
  
  res <- data.frame(id = id, nobs = n)
  return(res)
}

corr <- function(directory = "specdata", threshold=0) {
  id <- which(complete("specdata", 1:332)$nobs > threshold)
  res <- NULL
  for (i in id) {
    file <- paste0(directory, "/", sprintf("%03d", i), ".csv")
    df <- read.csv(file)
    nitrate <- df$nitrate
    sulfate <- df$sulfate
    res <- c(res, cor(nitrate, sulfate, use = "pairwise.complete.obs"))
  }
  
  return(res)
}
