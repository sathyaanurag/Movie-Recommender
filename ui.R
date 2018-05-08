### Recommenderlab Example with Shiny by Michael Hahsler
###
### This work is licensed under the Creative Commons Attribution 4.0
### International License (http://creativecommons.org/licenses/by/4.0/).
### For questions please contact Michael Hahsler at http://michael.hahsler.net.

library(shiny)

shinyUI(
  fluidPage(
    
    titlePanel("Movie Recommender"),
    
    sidebarLayout(position = "left",
                  sidebarPanel(
                    h3("Rate the following Movies:"),
                    
                    ### create the sliders
                    lapply(1:4, function(i) sliderInput(paste0("slider", i),
                                                        label = textOutput(paste0("joke", i)),
                                                        min = 1, max = 5, value = 2)),
                    
                    selectInput("select_algo", label = p("Select recommender algorithm"),
                                choices = list("POPULAR", "UBCF", "IBCF", "SVD", "RANDOM"),
                                selected = "UBCF"),
                    
                    numericInput("num_recoms",
                                 label = p("Number of recommended Movies"),
                                 value = 3, min = 1, max =10, step = 1),
                    
                    actionButton("new_jokes", "Change Movies to rate")
                  ),
                  
                  mainPanel(tableOutput("joke_recom"),
                            p(
                              a("recommenderlab",
                                href="https://cran.r-project.org/package=recommenderlab"),
                              "movie recommendation system by", a("Sathya", href="https://github.com/sathyaanurag?page=2&tab=repositories"), "based on example by",
                              a("Michael Hahsler.", href="http://michael.hahsler.net"),
                              "See the orginal source-code", a("source code.", href="https://github.com/mhahsler/recommenderlab/tree/master/Work/apps")
                              
                            )
                  )
    )
  )
)