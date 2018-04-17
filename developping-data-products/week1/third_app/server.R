library(shiny)
library(ggplot2)
data(trees)

shinyServer(function(input, output) {
  model <- reactive({
    brushed_data <- brushedPoints(trees, input$brush, xvar = "Girth", yvar = "Volume")

    if (nrow(brushed_data) < 2) {
      return(NULL)
    } else {
      lm(Volume ~ Girth, brushed_data)
    }

  })

  output$slope <- renderText({
    if (is.null(model())) {
      "No model found"
    } else {
      model()[[1]][2]
    }
  })

  output$intercept <- renderText({
    if (is.null(model())) {
      "No model found"
    } else {
      model()[[1]][1]
    }
  })

  output$plot <- renderPlot({
    plot_data <- ggplot(trees, aes(x = Girth, y = Volume)) +
      geom_point() +
      xlab("Girth") +
      ylab("Volume") +
      ggtitle("Tree measurement") +
      theme(plot.title = element_text(hjust = 0.5))

    if (!is.null(model())) {
      lm_model <- model()
      ydf <- predict(lm_model, data.frame(Girth = trees$Girth))
      df_model <- data.frame(x = trees$Girth, y = ydf)
      plot_data <- plot_data +
        geom_line(data = df_model, aes(x = x, y = y))
    }

    plot_data
  })
})