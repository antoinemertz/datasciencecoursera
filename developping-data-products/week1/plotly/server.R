library(shiny)
library(plotly)
data(mtcars)

shinyServer(function(input, output) {

  output$plot2D <- renderPlotly({
    plot_ly(mtcars, x = ~mpg, y = ~wt)
  })

  output$plot3D <- renderPlotly({
    mtcars %>%
      mutate(cyl = as.factor(cyl)) %>%
    plot_ly(x = ~mpg, y = ~wt, z = ~drat, type = "scatter3d", mode = "markers", color = ~cyl)
  })
})