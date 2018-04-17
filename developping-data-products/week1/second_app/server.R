library(shiny)
data("mtcars")

shinyServer(function(input, output) {
  mtcars$mpgsp <- ifelse(mtcars$mpg - 20 > 0, mtcars$mpg - 20, 0)
  model1 <- lm(hp ~ mpg, data = mtcars)
  model2 <- lm(hp ~ mpgsp + mpg, data = mtcars)

  model1pred <- reactive({
    mpgInput <- input$sliderMPG
    predict(model1, newdata = data.frame(mpg = mpgInput))
  })

  model2pred <- reactive({
    mpgInput <- input$sliderMPG
    predict(model2, newdata = data.frame(mpg = mpgInput,
                                          mpgsp = ifelse(mpgInput - 20 > 0, mpgInput - 20, 0)))
  })

  output$plot1 <- renderPlot({
    mpgInput <- input$sliderMPG

    plot1 <- ggplot(mtcars, aes(x = mpg, y = hp)) +
      geom_point() +
      xlab("Miles per Gallon") +
      ylab("Horsepower") +
      ggtitle("") +
      theme(plot.title = element_text(hjust = 0.5)) +
      xlim(10, 35) +
      ylim(50, 350)

    if(input$showModel1) {
      new_df <- data.frame(mpg = 10:35, hp = predict(model1, newdata = data.frame(mpg = 10:35)))
      plot1 <- plot1 +
        geom_line(data = new_df, aes(x = mpg, y = hp, color = 'red')) +
        geom_point(aes(x = mpgInput, y = model1pred(), color = "red"))
    }

    if(input$showModel2) {
      mpg_lim <- 10:35
      new_mpgsp <- ifelse(mpg_lim - 20 > 0, mpg_lim - 20, 0)
      new_df <- data.frame(mpg = 10:35, mpgsp = new_mpgsp, hp = predict(model2, newdata = data.frame(mpg = 10:35, mpgsp = new_mpgsp)))
      plot1 <- plot1 +
        geom_line(data = new_df, aes(x = mpg, y = hp, color = 'green4')) +
        geom_point(aes(x = mpgInput, y = model2pred(), color = "green4"))
    }


    plot1 +
      scale_color_discrete(name = "model", labels = c("hp ~ mpg", "hp ~ mpg + mpgsp"))

  })

  output$pred1 <- renderText({
    model1pred()
  })

  output$pred2 <- renderText({
    model2pred()
  })

  output$mpg <- renderText({
    input$sliderMPG
  })
})