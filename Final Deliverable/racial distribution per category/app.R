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
  count(name = "Total_Amount_of_Nominees")
#rename n column to nominated.....

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

analysis_page <- tabPanel(
  "Racial distribution per category since 1980",
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
  title = "A look at the Oscars",
  analysis_page
)



#Server stuff
server <- function(input, output, session) {
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

#the shiny app
shinyApp(ui = ui, server = server)