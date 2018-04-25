library(shiny)
library(dplyr)
library(ggplot2)
library(caret)
library(MLmetrics)

data("mtcars")

shinyServer(function(input, output) {


  output$svm_parameters <- renderUI({
    if(input$svr_kernel == "Linear") {
      tagList(
        sliderInput("C", "Choose cost parameter C:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2)
      )
      } else if(input$svr_kernel == "Polynomial") {
        tagList(
          sliderInput("C", "Choose cost parameter C:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2),
          sliderInput("degree", "Choose the degree", min = 1, max = 5, value = 2, step = 1)
        )
      } else if(input$svr_kernel == "RBF") {
        tagList(
          sliderInput("C", "Choose cost parameter C:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2),
          sliderInput("sigma", "Choose sigma parameter:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2)
        )
      }
  })

  model_lm <- train(mpg ~ ., data = mtcars, method = "lm")


  model_rf <- reactive({
    if(input$showRF) {
      fitControl <- trainControl(method = "none")
      rf_param <- data.frame(mtry = 6)
      train(mpg ~ ., data = mtcars, method = "rf", trControl = fitControl, tuneGrid = rf_param)
    }
  })

  model_svr <- reactive({
    if(input$showSVR) {
      fitControl <- trainControl(method = "none")
      if(input$svr_kernel == "RBF") {
        svr_param <- data.frame(C = input$C, sigma = input$sigma)
        train(mpg ~ ., data = mtcars, method = "svmRadial", tuneGrid = svr_param)
      } else if(input$svr_kernel == "Polynomial") {
        svr_param <- data.frame(C = input$C, degree = input$degree, scale = 100)
        train(mpg ~ ., data = mtcars, method = "svmPoly", tuneGrid = svr_param)
      } else if(input$svr_kernel == "Linear") {
        svr_param <- data.frame(C = input$C)
        train(mpg ~ ., data = mtcars, method = "svmLinear", tuneGrid = svr_param)
      }
    }
  })

  model_ridge <- reactive({
    if(input$showRidge) {
      fitControl <- trainControl(method = "none")
      ridge_param <- data.frame(lambda = input$lambda_ridge)
      train(mpg ~ ., data = mtcars, method = "ridge", trControl = fitControl, tuneGrid = ridge_param)
    }
  })

  model_lasso <- reactive({
    if(input$showLasso) {
      fitControl <- trainControl(method = "none")
      lasso_param <- data.frame(fraction = input$fraction_lasso)
      train(mpg ~ ., data = mtcars, method = "lasso", trControl = fitControl, tuneGrid = lasso_param)
    }
  })

   output$plot_result <- renderPlot({

     predict_lm <- mtcars %>%
       select(-c(mpg))

     predict_lm$mpg <- predict(model_lm, predict_lm)

     plot_result <- ggplot(mtcars, aes(x = mpg)) +
       geom_point(aes(y = predict_lm$mpg, color = 'lm')) +
       geom_abline(intercept = 0, slope = 1) +
       xlab("True values") +
       ylab("Predicted values") +
       xlim(c(5, 35)) +
       ylim(c(5, 35)) +
       ggtitle("") +
       theme(plot.title = element_text(hjust = 0.5))


    if(input$showRF) {
      predict_rf <- mtcars %>%
        select(-c(mpg))

      predict_rf$mpg <- predict(model_rf(), predict_rf)

      plot_result <- plot_result +
        geom_point(aes(y = predict_rf$mpg, color = 'rf'))
    }

    if(input$showSVR) {
      predict_svr <- mtcars %>%
        select(-c(mpg))

      predict_svr$mpg <- predict(model_svr(), predict_svr)

      if(input$svr_kernel == 'RBF') {
        plot_result <- plot_result +
          geom_point(aes(y = predict_svr$mpg, color = 'svr (rbf)'))
      } else {
        plot_result <- plot_result +
          geom_point(aes(y = predict_svr$mpg, color = 'svr (polynomial)'))
      }
    }

    if(input$showRidge) {
      predict_ridge <- mtcars %>%
        select(-c(mpg))

      predict_ridge$mpg <- predict(model_ridge(), predict_ridge)

      plot_result <- plot_result +
        geom_point(aes(y = predict_ridge$mpg, color = 'ridge'))
    }

     if(input$showLasso) {
       predict_lasso <- mtcars %>%
         select(-c(mpg))

       predict_lasso$mpg <- predict(model_lasso(), predict_lasso)

       plot_result <- plot_result +
         geom_point(aes(y = predict_lasso$mpg, color = 'lasso'))
     }

     plot_result
   })

   output$table <- renderDataTable({
     predict_mpg <- mtcars %>%
       select(-c(mpg))

     prediction_lm <- predict(model_lm, predict_mpg)

     rmspe_lm <- RMSPE(prediction_lm, mtcars$mpg)
     mape_lm <- MAPE(prediction_lm, mtcars$mpg)

     result <- data.frame(model = c("Linear Regression (lm)"), rmspe = c(rmspe_lm), mape = mape_lm)
     result$model <- as.character(result$model)

     if(input$showRF) {
       prediction_rf <- predict(model_rf(), predict_mpg)

       rmspe_rf <- RMSPE(prediction_rf, mtcars$mpg)
       mape_rf <- MAPE(prediction_rf, mtcars$mpg)

       result <- rbind(result, c("Random Forest (rf)", rmspe_rf, mape_rf))
     }

     if(input$showSVR) {
       prediction_svr <- predict(model_svr(), predict_mpg)

       rmspe_svr <- RMSPE(prediction_svr, mtcars$mpg)
       mape_svr <- MAPE(prediction_svr, mtcars$mpg)

       result <- rbind(result, c("SVR", rmspe_svr, mape_svr))
     }

     if(input$showRidge) {
       prediction_ridge <- predict(model_ridge(), predict_mpg)

       rmspe_ridge <- RMSPE(prediction_ridge, mtcars$mpg)
       mape_ridge <- MAPE(prediction_ridge, mtcars$mpg)

       result <- rbind(result, c("Ridge Regression (ridge)", rmspe_ridge, mape_ridge))
     }

     if(input$showLasso) {
       prediction_lasso <- predict(model_lasso(), predict_mpg)

       rmspe_lasso <- RMSPE(prediction_lasso, mtcars$mpg)
       mape_lasso <- MAPE(prediction_lasso, mtcars$mpg)

       result <- rbind(result, c("Lasso Regression (lasso)", rmspe_lasso, mape_lasso))
     }

     if(input$rank_metric == 'RMSPE') {
       result <- result %>%
         arrange(rmspe) %>%
         mutate(rank = row_number())
     } else if(input$rank_metric == 'MAPE') {
       result <- result %>%
         arrange(mape) %>%
         mutate(rank = row_number())
     }

     result
   })

})
