library(shiny)
library(miniUI)

myfirstGadget <- function() {
  ui <- miniPage(
    gadgetTitleBar("My First Gadget")
  )

  server <- function(input, output, session) {
    # The done button close the app
    observeEvent(input$done, {
      stopApp()
    })
  }
  runGadget(ui, server)
}