library(shiny)
library(ggplot2)
library(dplyr)

filepath <- "./data/titanic-data.csv"
titanic <- read.csv(filepath)
totalPassengers <- nrow(titanic)

titanicData <- function(passengerType, passengerSex, passengerClass) {
  data <- titanic
  if (passengerType !="Any") {
    if (passengerType =="Survivor")
      data <- filter(data, Passenger.Survived == "YES")
    else
      data <- filter(data, Passenger.Survived == "NO")
  }
  
  if (passengerSex !="Any") 
    data <- filter(data, Passenger.Sex == passengerSex)
  
  if (passengerClass !="Any")
    data <- filter(data, Passenger.Class == passengerClass)
  
  data  
}

passengersData <-  function(passengerType, passengerSex, passengerClass) {
  data <- titanicData(passengerType, passengerSex, passengerClass)
  outputData <- select(data, Name = Passenger.Name, Sex = Passenger.Sex, Survived = Passenger.Survived, Class = Passenger.Class)
  outputData
}

renderChart <- function (passengerType, passengerSex, passengerClass, chartType) {
  
  filteredData <- titanicData(passengerType, passengerSex, passengerClass)
  
  if (chartType =="sex"){
    outputChart <- sexChart(filteredData)
  }
  
  if (chartType =="survival"){
    outputChart <- survivalChart(filteredData)
  }
  
  if (chartType =="class"){
    outputChart <- classChart(filteredData)
  }
  
  outputChart
}

returnTable  <- function (passengerType, passengerSex, passengerClass, chartType) {
  
  filteredData <- titanicData(passengerType, passengerSex, passengerClass)
  
  if (chartType =="sex"){
    outputData <- sexData(filteredData)
  }
  
  if (chartType =="survival"){
    outputData <- survivalData(filteredData)
  }
  
  if (chartType =="class"){
    outputData <- classData(filteredData)
  }
  
  outputData
}

survivalData <- function (dataset) {
  group_by(dataset, Survived = Passenger.Survived) %>% summarize(Count = n()) %>% mutate (Percentage = round(Count / totalPassengers * 100,2))
}

sexData <- function(dataset){
  group_by(dataset, Sex = Passenger.Sex) %>% summarize(Count = n()) %>% mutate (Percentage = round(Count / totalPassengers * 100,2))
}

classData <- function(dataset){
  group_by(dataset, Class = Passenger.Class) %>% summarize(Count = n()) %>% mutate (Percentage = round(Count / totalPassengers * 100,2))
}

survivalChart <- function (dataset) {
  titanic.BySurvival <- survivalData(dataset)
  
  ggplot(data=titanic.BySurvival, aes(x=Survived, y=Count, fill=Survived)) +
    geom_bar(colour="black",  stat="identity")+ xlab("Survived") + ylab("Count") + 
    scale_fill_brewer(palette="Set3") 
}

sexChart <- function(dataset) {
  titanic.BySex <- sexData(dataset)
  
  ggplot(data=titanic.BySex, aes(x=Sex, y=Count, fill=Sex)) +
    geom_bar(colour="black",  stat="identity")+ xlab("Sex") + ylab("Count") + 
    scale_fill_brewer(palette="Set2") 
}

classChart <- function(dataset) {
  titanic.ByClass <- classData(dataset)
  ggplot(data=titanic.ByClass, aes(x=Class, y=Count, fill=Class)) +
    geom_bar(colour="black",  stat="identity")+ xlab("Class") + ylab("Count") + 
    scale_fill_brewer(palette="Set3") 
}

server <- function(input, output) {
  output$selectedPassengerType <- renderPrint({paste("you have selected", input$passengerType)})
  
  output$sexPlot <- renderPlot({renderChart (input$passengerType, input$passengerSex, input$passengerClass, "sex")})
  output$sexTable <- renderTable({returnTable (input$passengerType, input$passengerSex, input$passengerClass, "sex")})
  
  output$classPlot <- renderPlot({renderChart (input$passengerType, input$passengerSex, input$passengerClass, "class")})
  output$classTable <- renderTable({returnTable (input$passengerType, input$passengerSex, input$passengerClass, "class")})
  
  output$survivalPlot <- renderPlot({renderChart (input$passengerType, input$passengerSex, input$passengerClass, "survival")})
  output$survivalTable <- renderTable({returnTable (input$passengerType, input$passengerSex, input$passengerClass, "survival")})
  
  output$passengerTable <- renderTable({passengersData(input$passengerType, input$passengerSex, input$passengerClass)})
}


