library(methods)

setClass("polygon",
         representation(x = "numeric",
                        y = "numeric"))

setMethod("plot", "polygon",
          function(x, y, ...) { # argument x is a polygon
            plot(x@x, x@y, type = "n", ...)
            xp <- c(x@x, x@x[1])
            yp <- c(x@y, x@y[1])
            lines(xp, yp)
          })

p <- new("polygon", x = c(1, 2, 3, 4), y = sample(1:10, 4, TRUE))
plot(p)
