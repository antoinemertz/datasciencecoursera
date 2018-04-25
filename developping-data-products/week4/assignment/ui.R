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

      selectInput("rank_metric", label = "Choose the ranking metric", choices = c('RMSPE', 'MAPE'))

    ),
    mainPanel(
      plotOutput(outputId = "plot_result"),

      dataTableOutput('table')
    )
  )
))
