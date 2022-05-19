library(ggplot2)
library(dplyr)
library(stringr)

oscars_df <- read.csv("oscars.csv")

#Filter for 1980 winners and later
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

#plot
ggplot(data = oscar_race_df, mapping = aes(x = year_ceremony)) +
  geom_line(mapping = aes(y= white_per_year,color = "White")) +
  geom_point(mapping = aes(y= white_per_year,color = "White")) +
  geom_line(mapping = aes(y= other_per_year, color = "Other Race")) +
  geom_point(mapping = aes(y= other_per_year, color = "Other Race")) +
  labs(x= "Year of Ceremony", y ="Number of Winners", title = "Winners by Race Over the Years") +
  theme(legend.position = "bottom")

