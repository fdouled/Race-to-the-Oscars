library('tidyverse')

oscars <- read.csv(url('https://raw.githubusercontent.com/info201b-2022-spring/final-projects-swizzlejuice/3bfe43f235c6cc8034838c8ffb1b1d2b395a2c19/data/oscars.csv'))

#filter to only 1980 and later.
oscars <- filter(oscars, year_ceremony >= 1980)

#make a dataframe with amount of winners by race.
race_and_winners <- group_by(oscars, Race) %>%
  select( Race, winner) %>%
  summarise(Wins = sum( winner, na.rm = TRUE))
#Make a bar graph showing how many winners of each race there have been
race_and_winners_graph <- ggplot(race_and_winners, aes(x=Race, y=Wins,fill=Race )) + 
  geom_bar(stat = "identity") + 
  ggtitle("Winners by Race") +
  scale_fill_brewer(palette = "Set2") +
  theme(legend.position="none")
print(race_and_winners_graph)