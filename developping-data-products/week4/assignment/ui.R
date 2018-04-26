library(shiny)
library(dplyr)
library(ggplot2)
library(randomForest)
library(elasticnet)
library(caret)
library(MLmetrics)

shinyUI(fluidPage(
  titlePanel("Test different ML model"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("showRF", h5("Show/Hide random forest model"), FALSE),
      sliderInput(inputId = "mtry_rf", label = "Choose mtry parameter (number of variables tested at each split):", min = 2, max = 9, value = 6, step = 1),

      checkboxInput("showSVR", h5("Show/Hide SVR"), FALSE),
      selectInput(inputId = "svr_kernel", label = "Choose SVR kernel:", choices = c("RBF", "Linear")),
      uiOutput(outputId = "svm_parameters"),

      checkboxInput("showRidge", h5("Show/Hide Ridge Regression"), FALSE),
      sliderInput(inputId = "lambda_ridge", label = "Choose lambda parameter:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2),

      checkboxInput("showLasso", h5("Show/Hide Lasso Regression"), FALSE),
      sliderInput(inputId = "fraction_lasso", label = "Choose fraction parameter:", min = 1e-2, max = 1-1e-2, value = 0.8, step = 1e-2),


      submitButton()

    ),
    mainPanel(

      includeMarkdown("explication.md"),

      plotOutput(outputId = "plot_result"),

      dataTableOutput('table')
    )
  )
))
