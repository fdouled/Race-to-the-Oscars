library(shiny)
library(dplyr)
library(plotly)


#Use the Oscars data to compare race distribution within all nominees 
#(winners or not) for all categories from the 1980s and up

the_oscars <- read.csv("oscars.csv")

filtered_oscars <- the_oscars %>% filter(year_ceremony >= 1980)


#get only the columns
col <- c("year_ceremony", "Race", "Category")
race_and_category <- filtered_oscars[,col]


#count racial distribution per category
race_and_category <- race_and_category %>%
  group_by(Category, Race) %>%
  count(name = "amount_of_nominees")
#rename n column to nominated.....

make_piechart <- function (cat) {
  df <- race_and_category %>%
  filter(Category == cat) 
  pie_chart <- plot_ly(df, labels=~Race, values=~amount_of_nominees, type='pie')
  return(pie_chart)
}

make_table <- function (cat) {
  table_df <- race_and_category %>%
    filter(Category == cat) %>%
    select(c( Race, amount_of_nominees )) 
    table_df = table_df[,-1]
    return( do.call("rbind", list(table_df)))
}


summary_page <- tabPanel(
  "Summary",
  titlePanel("A look at Oscar nominees....."),
  p("This visualization lets you explore the nominee racial distribution for different Oscar Categories")
)

analysis_page <- tabPanel(
  "Analysis",
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


ui <- navbarPage(
  title = "Oscar ceremonies from 1980 onward",
  summary_page,
  analysis_page
)



#Server stuff
server <- function(input, output, session) {
  output$graph <- renderPlotly ({
    labels = c('Asian','Black','Hispanic','White')
    values = c(make_piechart$amount_of_nominees)
    
    pie_chart <- plot_ly(type='pie', labels =Race, values = amount_of_nominees, 
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

#the shiny app
shinyApp(ui = ui, server = server)