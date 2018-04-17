library(shiny)

shinyUI(fluidPage(
  titlePanel("Predict Horsepower from MPG"),
  sidebarLayout(
    sidebarPanel(

      sliderInput(inputId = "sliderMPG", label = "What is the MPG of the car?", min = 10, max = 35, value = 20),

      checkboxInput("showModel1", "Show/Hide Model 1", TRUE),
      checkboxInput("showModel2", "Show/Hide Model 2", TRUE),

      submitButton("Submit")
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Tab 1",
                            plotOutput(outputId = "plot1"),
                            h3("Predicted Horsepower from Model 1:"),
                            textOutput("pred1"),
                            h3("Predicted Horsepower from Model 2:"),
                            textOutput("pred2")
                           ),
                  tabPanel("Tab 2", textOutput("mpg"))
                  )

    )
  )
))