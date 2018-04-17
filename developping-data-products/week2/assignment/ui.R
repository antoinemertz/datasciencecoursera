library(shiny)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Plot Random Numbers"),
  sidebarLayout(
    sidebarPanel(

      h6("Sidebar Panel")

    ),
    mainPanel(
      h6("Map"),
      leafletOutput("mymap")
    )
  )
))