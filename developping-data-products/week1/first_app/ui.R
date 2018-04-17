library(shiny)

shinyUI(fluidPage(
  titlePanel("Plot Random Numbers"),
  sidebarLayout(
    sidebarPanel(

      numericInput(inputId = "nobs", label = "How many random numbers should be plotted?", value = 1000, min = 1, max = 2000),

      sliderInput(inputId = "rangeX", label = "Pick miniumum and maximum X values", min = -100, max = 100, value = c(-50, 50)),

      sliderInput(inputId = "rangeY", label = "Pick miniumum and maximum Y values", min = -100, max = 100, value = c(-50, 50)),

      checkboxInput("Xlabel", "Show/Hide X axis label", TRUE),
      checkboxInput("Ylabel", "Show/Hide Y axis label", TRUE),
      checkboxInput("Title", "Show/Hide Title", TRUE)
    ),
    mainPanel(
      h3("Graph of Random Points"),
      plotOutput(outputId = "plot1")
    )
  )
))