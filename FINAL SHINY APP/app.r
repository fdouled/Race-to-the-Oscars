library(shiny)
library(dplyr)
library(plotly)
library(stringr)

#read in all of the data from charts
oscars <- read.csv(url("https://raw.githubusercontent.com/info201b-2022-spring/final-projects-swizzlejuice/main/data/oscars.csv"))
oscars <- filter(oscars, year_ceremony >= 1980)
race_and_winners <- group_by(oscars, Race) %>%
  select( Race, winner) %>%
  summarise(Wins = sum( winner, na.rm = TRUE))

the_oscars <- read.csv(url("https://raw.githubusercontent.com/info201b-2022-spring/final-projects-swizzlejuice/main/data/oscars.csv"))
filtered_oscars <- the_oscars %>% filter(year_ceremony >= 1980)
col <- c("year_ceremony", "Race", "Category")
race_and_category <- filtered_oscars[,col]
race_and_category <- race_and_category %>%
  group_by(Category, Race) %>%
  count(name = "Total_Amount_of_Nominees")
make_piechart <- function (cat) {
  df <- race_and_category %>%
    filter(Category == cat) 
  pie_chart <- plot_ly(df, labels=~Race, values=~Total_Amount_of_Nominees, type='pie')
  return(pie_chart)
}
make_table <- function (cat) {
  table_df <- race_and_category %>%
    filter(Category == cat) %>%
    select(c( Race, Total_Amount_of_Nominees )) 
  table_df = table_df[,-1]
  return( do.call("rbind", list(table_df)))
}

oscars_df <- read.csv(url("https://raw.githubusercontent.com/info201b-2022-spring/final-projects-swizzlejuice/main/data/oscars.csv"))
oscars_df <- oscars_df %>%
  filter(year_ceremony >= 1980) %>%
  filter(winner == TRUE) %>% 
  select(year_ceremony,Race,winner)
oscar_white_df <- oscars_df %>% 
  mutate(white_counter = str_count(oscars_df$Race, "White")) %>%
  group_by(year_ceremony) %>%
  summarise(white_per_year = sum(white_counter))
oscar_other_df <- oscars_df %>%
  mutate(other_counter = !str_detect(oscars_df$Race,"White")) %>%
  group_by(year_ceremony) %>%
  summarise(other_per_year = sum(other_counter, na.rm = FALSE))
oscar_race_df <- full_join(oscar_white_df,oscar_other_df) 


#begin writing the ui and server logic
intro_panel <- tabPanel(
  "INTRODUCTION",
  img(src = "oscar.jpg", height = 485, width =650,style="display: block; margin-left: auto; margin-right: auto;"),
  br(),
  br(),
  
  p("The Oscars Ceremonies have been repeatedly accused of racial bias in recent decades. 
    The hashtag #OscarsSoWhite has been used countless times to address the issue of 
    racial diversity, and whether or not the Oscars discriminates against People of Color. 
    To explore this issue, we decided to analyze a dataset that lists the winners and 
    nominees for 92 different Oscar categories from 1980 to 2020, as well as the race 
    of all winners and nominees.
    By analyzing the dataset, we hoped to find answers to the following questions:"),
  
p("1) Do the Oscars Ceremonies reflect racial diversity, or are the Oscars truly #SoWhite?"),
p("2) What has the racial diversity of the Oscars looked like over the years?
  Has there been improvement in racial diversity in the past five years?"),
p("3) What does the racial distribution of the Oscars look like by Category? 
Are there specific categories that reflect higher racial diversity than others?"),

p("To answer these questions, we chose to create three charts to better 
  understand the data. One chart is a pie chart that illustrates the 
  racial distribution of Oscar nominees by category, another is a line graph 
  that illustrates the racial distribution of Oscar winners from 1928 to 2020, 
  and another is a bar chart that illustrates the racial diversity of Oscar winners. 
  By constructing these plots, we hoped to find answers to our questions and to 
  gain a more comprehensive understanding of the data."),
br(),
br()
)


first_chart <- tabPanel(
  "Oscars Winners by Race",
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


second_chart <- tabPanel(
  "Racial Distribution per Category",
  sidebarLayout(
    sidebarPanel(
      h3("Racial Distribution (percentage)"),
      selectInput(
        inputId = "category", 
        label = "Select an Oscar Category",
        choices = race_and_category$Category
      )
    ),
    mainPanel(
      plotlyOutput(outputId = 'pie'),
      tableOutput(outputId = 'table')
    )
  )
)


third_chart <- tabPanel(
  "Winners by Race Over the Years",
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


second_panel <- tabPanel(
  "SUMMARY",
  titlePanel("Concluding Thoughts"),
  p("
Through our analysis of the data, we arrived at the conclusion that there is 
significant lack of racial diversity in the Oscars. This was the biggest takeaway. 
Another takeaway from conducting our analysis of racial distribution by category is
that there is little correlation between Oscar Category and race.
The only observation found was that People of Color are more likely to be nominated 
for Best Actor and Best Actress than for any other category. 
A third takeaway is that based on our analysis of racial distribution over the years, 
there has been slight improvement in racial diversity in the last five years. 
This may be due to increased calls for racial diversity by the general population, 
and the criticism that the Oscars have received for being #SoWhite."),
p("To summarize, the Oscars have significant lack of racial diversity- 
  however slowly but surely, it seems to be improving. It would be interesting 
  to see how this data would look in the next ten, even fifteen or twenty years, 
  and whether or not racial diversity continues to improve.")
)

#ui logic
ui <- navbarPage(
  "Race in the Oscars",
  intro_panel,
  first_chart,
  third_chart,
  second_chart,
  second_panel
)

server <- function(input, output) {
  #evan's
  output$bar <- renderPlot({
    filter_df <- filter(race_and_winners, Race %in% input$race)
    ggplot(filter_df, aes(x=Race, y=Wins,fill=Race )) + 
      geom_bar(stat = "identity") + 
      ggtitle("Winners by Race") +
      scale_fill_brewer(palette = "Set2") +
      theme(legend.position="none")
  })
  
  #matt's
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
  #fardowsa's
  output$graph <- renderPlotly ({
    labels = c('Asian','Black','Hispanic','White')
    values = c(make_piechart$Total_Amount_of_Nominees)
    
    pie_chart <- plot_ly(type='pie', labels =Race, values = Total_Amount_of_Nominees, 
                         textinfo='label+percent',
                         insidetextorientation='radial')
  })
  
  output$pie <- renderPlotly({
    choice <- input$category
    plt <- make_piechart(choice)
    print(plt)
  })
  
  output$table <- renderTable({
    display <- input$category
    the_table <- make_table(display)
    print(the_table)
  })
}

shinyApp(ui, server)
