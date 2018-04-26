The goal of this Shiny application is to compare different ML models performance on a regression task.

I choose to illustrate the app using `mtcars` dataset. I test performance of ML models on the regression of the `mpg` variable using all the others `mtcars` variables (`cyl`, `disp`, `hp`, `drat`, `wt`, `qsec`, `vs`, `am`, `gear`, `carb`).

I test 5 different algorithms found in `caret` package:

* simple linear regression (`lm`)
* random forest (`rf`)
* SVM regression (`svr`)
* Ridge regression (`ridge`)
* Lasso regression (`lasso`)

I let interested people look this different algorithms and the `caret` documentation for further details.

On the side panel the user can tune some hyper parameters for each algorithm. To see performance of an algorithm (on the plot and on the table below the plot) just check the box of the algorithm you are interest in (`lm` is always display to compare).
