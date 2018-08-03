# Shiny server

library(shiny)
load("../model/trained_model.RData")

cleanInput <- function(text){
  return(text)
}

predictNextWord <- function(textInput) {
  return(c("mot1", "mot2", "mot3"))
}

shinyServer <- function (input, output) {
  output$html1 <- renderUI({
    textInput <- input$text1
    textInput <- cleanInput(textInput)
    predictword <- predictNextWord(textInput)  
    
    str1 <- h4("Predicted words", align = "left")
    word_predicted_1 <- paste("<span style='color:orange'>", paste("1.", predictNextWord("blabla")[1]), "</span>")
    word_predicted_2 <- paste("<span style='color:orange'>", paste("2.", predictNextWord("blabla")[2]), "</span>")
    word_predicted_3 <- paste("<span style='color:orange'>", paste("3.", predictNextWord("blabla")[3]), "</span>")
    
    if (input$displayEnterText==FALSE) {
      str2 <- ""
      str3 <- ""
    } else {
      str2 <- h4('Entered text:', align = "left")
      str3 <- paste("<span style='color:blue'>", h4(input$text1, align = "left"), "</span>")
    }
    
    HTML(paste(str1, "</br>",
               word_predicted_1, "</br>", word_predicted_2, "</br>", word_predicted_3, "</br>",
               str2, "</br>", str3))
  })
}