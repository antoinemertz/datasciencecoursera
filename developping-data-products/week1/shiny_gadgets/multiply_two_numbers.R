library(shiny)
library(miniUI)

multiplyNumbers <- function(a, b) {
  ui <- miniPage(
    gadgetTitleBar("Multiply two numbers"),

    miniContentPanel(
      selectInput('a', "First Number", choices = a),
      selectInput('b', "Second Number", choices = b)
    )
  )

  server <- function(input, output, session) {
    observeEvent(input$done, {
      a <- as.numeric(input$a)
      b <- as.numeric(input$b)

      stopApp(a * b)
    })
  }

  runGadget(ui, server)
}