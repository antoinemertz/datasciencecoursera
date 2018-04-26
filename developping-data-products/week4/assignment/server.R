library(shiny)
library(dplyr)
library(ggplot2)
library(randomForest)
library(elasticnet)
library(caret)
library(MLmetrics)

data("mtcars")

shinyServer(function(input, output) {

  model_lm <- train(mpg ~ ., data = mtcars, method = "lm")

  test_df <- mtcars %>%
    select(-c(mpg))

  model_rf <- reactive({
    if(input$showRF) {
      fitControl <- trainControl(method = "none")
      rf_param <- data.frame(mtry = input$mtry_rf)
      rf_model <- train(mpg ~ ., data = mtcars, method = "rf", trControl = fitControl, tuneGrid = rf_param)

      predict(rf_model, test_df)
    }
  })

  output$svm_parameters <- renderUI({
    if(input$svr_kernel == "Linear") {
      tagList(
        sliderInput("C", "Choose cost parameter C:", min = 1e-2, max = 1-1e-2, value = 0.5, step = 1e-2)
      )
    } else if(input$svr_kernel == "RBF") {
      tagList(
        sliderInput("C", "Choose cost parameter C:", min = 1e-2, max = 1-1e-2, value = 0.8, step = 1e-2),
        sliderInput("sigma", "Choose sigma parameter:", min = 1e-2, max = 1-1e-2, value = 0.8, step = 1e-2)
      )
    }
  })

  model_svr <- reactive({
    if(input$showSVR) {
      fitControl <- trainControl(method = "none")
      if(input$svr_kernel == "RBF") {
        svr_param <- data.frame(C = input$C, sigma = input$sigma)
        svr_model <- train(mpg ~ ., data = mtcars, method = "svmRadial", tuneGrid = svr_param)
      } else if(input$svr_kernel == "Linear") {
        svr_param <- data.frame(C = input$C)
        svr_model <- train(mpg ~ ., data = mtcars, method = "svmLinear", tuneGrid = svr_param)
      }
      predict(svr_model, test_df)
    }
  })

  model_ridge <- reactive({
    if(input$showRidge) {
      fitControl <- trainControl(method = "none")
      ridge_param <- data.frame(lambda = input$lambda_ridge)
      ridge_model <- train(mpg ~ ., data = mtcars, method = "ridge", trControl = fitControl, tuneGrid = ridge_param)
      predict(ridge_model, test_df)
    }
  })

  model_lasso <- reactive({
    if(input$showLasso) {
      fitControl <- trainControl(method = "none")
      lasso_param <- data.frame(fraction = input$fraction_lasso)
      lasso_model <- train(mpg ~ ., data = mtcars, method = "lasso", trControl = fitControl, tuneGrid = lasso_param)
      predict(lasso_model, test_df)
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
      plot_result <- plot_result +
        geom_point(aes(y = model_rf(), color = 'rf'))
    }

    if(input$showSVR) {
      plot_result <- plot_result +
        geom_point(aes(y = model_svr(), color = 'svr'))
    }

    if(input$showRidge) {
      plot_result <- plot_result +
        geom_point(aes(y = model_ridge(), color = 'ridge'))
    }

    if(input$showLasso) {
      plot_result <- plot_result +
        geom_point(aes(y = model_lasso(), color = 'lasso'))
    }

    plot_result
    })



  output$table <- renderDataTable({
    predict_mpg <- mtcars %>%
      select(-c(mpg))

    prediction_lm <- predict(model_lm, predict_mpg)

    rmspe_lm <- RMSPE(prediction_lm, mtcars$mpg)
    mape_lm <- MAPE(prediction_lm, mtcars$mpg)

    result <- data.frame(model = c("Linear Regression (lm)"), rmspe = rmspe_lm, mape = mape_lm)
    result$model <- as.character(result$model)

    if(input$showRF) {
      rmspe_rf <- RMSPE(model_rf(), mtcars$mpg)
      mape_rf <- MAPE(model_rf(), mtcars$mpg)

      result <- rbind(result, c("Random Forest (rf)", rmspe_rf, mape_rf))
    }

    if(input$showSVR) {
      rmspe_svr <- RMSPE(model_svr(), mtcars$mpg)
      mape_svr <- MAPE(model_svr(), mtcars$mpg)

      result <- rbind(result, c("SVR", rmspe_svr, mape_svr))
    }

    if(input$showRidge) {
      rmspe_ridge <- RMSPE(model_ridge(), mtcars$mpg)
      mape_ridge <- MAPE(model_ridge(), mtcars$mpg)

      result <- rbind(result, c("Ridge Regression (ridge)", rmspe_ridge, mape_ridge))
    }

    if(input$showLasso) {
      rmspe_lasso <- RMSPE(model_lasso(), mtcars$mpg)
      mape_lasso <- MAPE(model_lasso(), mtcars$mpg)

      result <- rbind(result, c("Lasso Regression (lasso)", rmspe_lasso, mape_lasso))
    }

    result
    })

  })
