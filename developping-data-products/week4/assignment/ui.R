library(shiny)
library(dplyr)
library(ggplot2)
library(caret)
library(MLmetrics)

shinyUI(fluidPage(
  titlePanel("Predict Horsepower from MPG"),
  sidebarLayout(
    sidebarPanel(

      checkboxInput("showRF", "Show/Hide random forest model", FALSE),

      checkboxInput("showSVR", "Show/Hide SVR", FALSE),
      selectInput(inputId = "svr_kernel", label = "Choose SVR kernel:", choices = c("RBF", "Polynomial", "Linear")),
      uiOutput(outputId = "svm_parameters"),

      checkboxInput("showRidge", "Show/Hide Ridge Regression", FALSE),
      sliderInput(inputId = "lambda_ridge", label = "Choose lambda parameter:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2),

      checkboxInput("showLasso", "Show/Hide Lasso Regression", FALSE),
      sliderInput(inputId = "fraction_lasso", label = "Choose fraction parameter:", min = 1e-2, max = 1-1e-2, value = 0.8, step = 1e-2),

      selectInput("rank_metric", label = "Choose the ranking metric", choices = c('RMSPE', 'MAPE'))

    ),
    mainPanel(
      plotOutput(outputId = "plot_result"),

      dataTableOutput('table')
    )
  )
))
