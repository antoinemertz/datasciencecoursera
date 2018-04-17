library(shiny)
library(plotly)

shinyUI(fluidPage(

  plotlyOutput("plot2D"),

  plotlyOutput("plot3D")
))