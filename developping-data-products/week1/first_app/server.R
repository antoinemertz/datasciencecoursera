library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  output$plot1 <- renderPlot({

    xlabel <- ifelse(input$Xlabel, "X axis", "")
    ylabel <- ifelse(input$Ylabel, "Y axis", "")
    title_label <- ifelse(input$Title, "Title", "")

    x <- runif(n = input$nobs, min = input$rangeX[1], max = input$rangeX[2])
    y <- runif(n = input$nobs, min = input$rangeY[1], max = input$rangeY[2])

    df <- data.frame(x = x, y = y)

    ggplot(df, aes(x = x, y = y)) +
      geom_point() +
      xlab(xlabel) +
      ylab(ylabel) +
      ggtitle(title_label) +
      theme(plot.title = element_text(hjust = 0.5)) +
      xlim(-100, 100) +
      ylim(-100, 100)
  })
})