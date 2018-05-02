#' Building a Model with Top Ten Features
#'
#' This function develops a prediction algorithm based on the top 10 features
#' in 'x' that are most predictive of 'y'
#'
#' @param x a n x p matrix of n observations and p predictors
#' @param y a vector of length n representing the response
#' @return a vector of coefficients from the final fitted model with top 10 features
#' @author Antoine Mertz
#' @details
#' This function runs a univariate regression of y on each predictor in x and
#' calculalate a p-value indicating the significance of the association. The
#' final set of predictors is taken from the 10 smallest p-values.
#' @seealso \code{lm}
#' @export
#' @importFrom stats lm

topten <- function(x, y) {
  p <- ncol(x) # number of predictors

  if (p < 10) {
    stop("There are less than 10 predictors")
  }

  pvalues <- numeric(p) # store p-value associated for each predictor

  for (i in seq_len(p)) {
     fit <- lm(y ~ x[,i]) # fit a simple linear model with predictor i
     summ <- summary(fit) # summary the lm model to access p-value
     pvalues[i] <- summ$coefficients[2, 4]
  }

  x10 <- x[, order(pvalues)[1:10]]

  fit <- lm(y ~ x10)
  return(coef(fit))
}

#' Prediction with Top Ten Features
#'
#' This function takes a set of coefficients produced by the \code{topten}
#' function and makes a prediction for each value provided in the input
#' 'X' matrix.
#'
#' @param X a n x 10 matrix
#' @param b a set of coefficients
#' @return a numeric vector
#' @author Antoine Mertz
#' @export

predict10 <- function(X, b) {
  X <- cbind(1, X)
  return(drop(X %*% b))
}
