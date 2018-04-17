library(shiny)

shinyUI(fluidPage(
  titlePanel("Visualize Many Models"),

  sidebarLayout(
    sidebarPanel(
      h6("Slope"),
      textOutput("slope"),

      h6("Intercept"),
      textOutput("intercept")

    ),

    mainPanel(
      plotOutput("plot", brush = brushOpts(id = "brush"))
    )
  )
))