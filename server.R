### Recommenderlab Example with Shiny by Michael Hahsler
###
### This work is licensed under the Creative Commons Attribution 4.0
### International License (http://creativecommons.org/licenses/by/4.0/).
### For questions please contact Michael Hahsler at http://michael.hahsler.net.

### How to:
# 1. Start/open a Shiny project in R Studio
# 2. Edit ui.R and server.R and test (using Run App button)
# 3. Deploy:
#     a) Create a shinyapps.io account (https://www.shinyapps.io/)
#     b) Go to account and create a token and set account using package rsconnect
#     c) deploy using: library(rsconnect); deployApp()

library(shiny)
library(recommenderlab)

## load data
data("Jester5k")
data("MovieLense")

moviedf = as(MovieLense, "data.frame")
movieslist <- as.vector(moviedf['item'])
movies = array(as.character(unlist(movieslist)))

ncol(MovieLense)

shinyServer(
  function(input, output) {
    
    ## pick random jokes and display
    jokes_to_rate <- reactive({
      ignore <- input$new_jokes  ### listen to button
      
      rand_jokes <- sample(ncol(MovieLense), 4)
      
      output[[paste0("joke", 1)]] <- renderText(movies[rand_jokes[1]])
      output[[paste0("joke", 2)]] <- renderText(movies[rand_jokes[2]])
      output[[paste0("joke", 3)]] <- renderText(movies[rand_jokes[3]])
      output[[paste0("joke", 4)]] <- renderText(movies[rand_jokes[4]])
      
      rand_jokes
    })
    
    ### create and change recommender
    recom <- reactive({
      rec<- Recommender(MovieLense, method = 'UBCF')#input$select_algo)
      #Recommender(MovieLense, method = 'UBCF')
    })
    
    ### make recommendations
    output$joke_recom <- renderTable({
      
      ### read ratings
      ratings <- matrix(NA, nrow = 1, ncol = ncol(MovieLense))
      for(i in 1:4)
        ratings[1, jokes_to_rate()[i]] <- input[[paste0("slider", i)]]
      
      ### create recommendations
      
      pred <- predict(recom(), as(ratings, "realRatingMatrix"),
                      n = input$num_recoms)
      as(pred,'list')
      
      cbind('Recommended Movie' = getList(pred)[[1]],
            'Predicted Rating' = sprintf("%1.1f", getRatings(pred)[[1]]))
    })
  }
)