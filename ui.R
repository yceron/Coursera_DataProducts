library(shiny)
library(ggplot2)
library(dplyr)
ui <- fixedPage(  
  tags$head(tags$title("Titanic Data Explorer"), tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
  h1("Titanic Data Explorer"),
  
  fluidRow(
    column (6,
            HTML('<p class="intro">The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.<br/><br/>On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships.
<br/><br/>One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew.<br />Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class.<br/> This app will let you explore the passengers list.</p>')),
    column(6,img(src='titanic.png', align = "right"))
            
  ),
  
  fluidRow(
    column(12,
           HTML('<div class="instructions"><b>Instructions:</b> Use the options below to filter the information you would like to see.</div>'),
           column(4,
                  selectInput(inputId="passengerType",
                              label = "Select the passenger type",
                              choices = c("Any", "Survivor", "Non survivor"),
                              selected = "Any")           
           ),
           column(4,
                  selectInput(inputId="passengerSex",
                              label = "Select the passenger sex",
                              choices = c("Any", "Female", "Male"),
                              selected = "Any")),
           column(4,
                  selectInput(inputId="passengerClass",
                              label = "Select the passenger class",
                              choices = c( "Any", "1st Class", "2nd Class", "3rd Class"),
                              selected = "Any")
           )
           #,submitButton("Explore data")
    )),
  fluidRow(
    tabsetPanel(
      tabPanel("Summary information",
               column(12,
                      fixedRow(
                        column(width = 6, 
                               plotOutput("survivalPlot")
                        ),
                        column(width = 6, 
                               h3("Survival"),             
                               tableOutput("survivalTable"))
                      ),
                      
                      fixedRow(
                        column(width = 6, 
                               plotOutput("sexPlot")
                        ),
                        column(width = 6, 
                               h3("Sex"),
                               tableOutput("sexTable"))
                      ),
                      
                      fixedRow(
                        column(width = 6, 
                               plotOutput("classPlot")
                        ),
                        column(width = 6, 
                               h3("Class"),
                               tableOutput("classTable"))
                      ))
      ),
      tabPanel("Passengers List",
               fixedRow(
                 column(width = 12,
                        helpText("This is the passenger list corresponding to the information you selected.")
                 ),
                 column(width = 12,
                    tableOutput("passengerTable")
                 ))
               )
      ),
    fluidRow
    (
    column(width = 12, 
    HTML("<div class='footer'>This project was created as the course project for the Johns Hopkins Bloomberg School of Public Health Data Science Specialization class Developing Data Products on Coursera.</div>")
    )

    )

  )
)

