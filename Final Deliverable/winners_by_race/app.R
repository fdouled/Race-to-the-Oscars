library(shiny)
library(tidyverse)
library(ggplot2)

#load dataframe
oscars <- read.csv(url('https://raw.githubusercontent.com/info201b-2022-spring/final-projects-swizzlejuice/3bfe43f235c6cc8034838c8ffb1b1d2b395a2c19/data/oscars.csv'))
#filter to only 1980 and later.
oscars <- filter(oscars, year_ceremony >= 1980)

#make a dataframe with amount of winners by race.
race_and_winners <- group_by(oscars, Race) %>%
  select( Race, winner) %>%
  summarise(Wins = sum( winner, na.rm = TRUE))

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel('Oscars Winners by Race'),
  sidebarLayout(
    sidebarPanel(
      h4('Races'),
      checkboxGroupInput(
        inputId = 'race',
        label = 'Compare specific races',
        choices = list("White", "Black", "Asian", "Hispanic"),
        selected = list("White", "Black", "Asian", "Hispanic")
      )),
    mainPanel(
      plotOutput(outputId = 'bar')
  )
  ) 
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  output$bar <- renderPlot({
    filter_df <- filter(race_and_winners, Race %in% input$race)
    ggplot(filter_df, aes(x=Race, y=Wins,fill=Race )) + 
      geom_bar(stat = "identity") + 
      ggtitle("Winners by Race") +
      scale_fill_brewer(palette = "Set2") +
      theme(legend.position="none")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
