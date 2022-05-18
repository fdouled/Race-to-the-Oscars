#Aggregate Table Script

#selecting specific rows (by year: 1980s to present):
year_table <- oscars[-c(1:6544,10396), ]


#Groupby function for dataframe in R:
table_script = year_table %>% group_by(year_ceremony)  %>%
  select(Category,
            Race,
            winner)

View(table_script)

