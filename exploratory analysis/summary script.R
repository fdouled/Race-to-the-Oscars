#Summary Information Script

#read csv file
oscars<-read.csv(url("https://raw.githubusercontent.com/info201b-2022-spring/final-projects-swizzlejuice/main/data/oscars.csv?token=GHSAT0AAAAAABUUS75QD6FJJLBBUZW2ZYRUYUEL4WQ"))


summary_info <- list(num_rows,num_cols,num_of_years,num_of_categories,different_races)

num_rows<- c(nrow(oscars))
#number of rows in dataset
num_cols<-c(ncol(oscars))
#number of columns in dataset
range_of_years<-unique(c(oscars$year_ceremony))
#different years listed in dataset (with number of years)
num_of_categories<-unique(c(oscars$Category))
#different categories listed in dataset (with number of categories)
different_races<-unique(c(oscars$Race))
#different races listed in dataset (with number of races)
summary_info

