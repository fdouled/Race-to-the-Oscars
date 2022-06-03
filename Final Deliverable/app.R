library(shiny)

intro_panel <- tabPanel(
  "INTRODUCTION",
  
  titlePanel("Race in the Oscars: An Analysis"),
  img(src = "oscar.jpg", height = 600, width =800),
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
  understand the data. The first chart is a pie chart that illustrates the 
  racial distribution of Oscar nominees by category, the second is a line graph 
  that illustrates the racial distribution of Oscar winners from 1928 to 2020, 
  and the third is a bar chart that illustrates the racial diversity of Oscar winners. 
  By constructing these plots, we hoped to find answers to our questions and to 
  gain a more comprehensive understanding of the data."),
br(),
br()
)
second_panel <- tabPanel(
  "SUMMARY",
  titlePanel("Race in the Oscars: An Analysis"),
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

ui <- navbarPage(
  "Race in the Oscars",
  intro_panel,
  second_panel
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)
