library(shiny)
library(dplyr)
library(plotly)

oscars_df <- read.csv("oscars.csv")
oscars_df <- oscars_df %>%
  filter(year_ceremony >= 1980) %>%
  filter(winner == TRUE) %>% 
  select(year_ceremony,Race,winner)

#mutate a column that counts the whites per year
oscar_white_df <- oscars_df %>% 
  mutate(white_counter = str_count(oscars_df$Race, "White")) %>%
  group_by(year_ceremony) %>%
  summarise(white_per_year = sum(white_counter))

#mutate a column that counts other races per year
oscar_other_df <- oscars_df %>%
  mutate(other_counter = !str_detect(oscars_df$Race,"White")) %>%
  group_by(year_ceremony) %>%
  summarise(other_per_year = sum(other_counter, na.rm = FALSE))

#join df
oscar_race_df <- full_join(oscar_white_df,oscar_other_df)  


ui <- fluidPage(
  titlePanel("Winners by Race Over the Years"),
  sidebarLayout(
    sidebarPanel(
      h5("Controls"),
      sliderInput(
        inputId = "year",
        label = "Year Range",
        1980,
        2020,
        value = c(1980,2020),
        sep = ""
      ),
      helpText("Note: Other race is any race other than white. It is a combination of Asian, Black, and Hispanic statistics.")
    ),
    mainPanel(
      plotOutput(outputId = "line", click = "click"),
      tableOutput(outputId = "whitedata"),
      tableOutput(outputId = "otherdata")
    )
  )
)

server <- function(input, output, session) {
    output$line <- renderPlot({
      minyear <- input$year[1]
      maxyear <- input$year[2]
      
      oscar_race_df <- filter(oscar_race_df, year_ceremony >= minyear,
                              year_ceremony <= maxyear)
      
      ggplot(data = oscar_race_df, mapping = aes(x = year_ceremony)) +
        geom_point(mapping = aes(y= white_per_year,color = "White")) +
        geom_point(mapping = aes(y= other_per_year, color = "Other Race")) +
        labs(x= "Year of Ceremony", y ="Number of Winners", color = "Race") +
        theme(legend.position = "bottom")
  })
}

shinyApp(ui, server)