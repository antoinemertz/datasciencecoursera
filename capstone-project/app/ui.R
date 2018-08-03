# The user graphic interface definition for Shiny web application.

library(shiny)

shinyUI <- fluidPage(
  navbarPage("Predict Next Word",
             # multi-page user-interface that includes a navigation bar.
             tabPanel("Application",
                      sidebarLayout(
                        sidebarPanel(
                          textInput(inputId="text1", label = "Please enter your text here: ", value =""),
                          checkboxInput(inputId="displayEnterText", "Display entered text", value = TRUE)
                        ), # end of "sidebarPanel"
                        mainPanel(
                          htmlOutput("html1")
                        ) # mainPanel
                      ) #sidebarLayout
             )
  ) # end of navbarPage
)