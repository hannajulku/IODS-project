---
  #title: "Data wrangling code"
  #coding_language: "R"
  #author: "Hanna Julku"
  #date: "24.11.2022"
  #Data_sourcec: "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv"
    #and "https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv"
  ---

  #load libraries to be used
  library(tidyverse)
  library(GGally)
  library(dplyr)
  
# read data sets to memory  
# hd = human development
# gii = gender inequality
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")


hd <- as.data.frame(hd)
gii <- as.data.frame(gii)

# inspect the structure of data and create summaries
str(hd)
dim(hd)
colnames(hd)
summary(hd)
# 195 observations, 8 variables

str(gii)
dim(gii)
colnames(gii)
summary(gii)
# 195 observations, 10 variables  
  

# rename the variables with (shorter) descriptive names. 
# these are related to hd
# "GNI" = Gross National Income per capita = Gross National Income (GNI) per Capita
# "Life.Exp" = Life expectancy at birth = Life Expectancy at Birth
# "Edu.Exp" = Expected years of schooling = Expected Years of Education
# rename columns accordingly
hd <- rename(hd, "GNI" = "Gross National Income (GNI) per Capita")
hd <- rename(hd, "Edu.Exp" = "Expected Years of Education")
hd <- rename(hd, "Life.Exp" = "Life Expectancy at Birth")
colnames(hd)
# column rename worked out
 
# these are related to gii
# "Mat.Mor" = Maternal mortality ratio = Maternal Mortality Ratio
# "Ado.Birth" = "Adolescent Birth Rate"
# "Edu2.F" = Proportion of females with at least secondary education = "Population with Secondary Education (Female)"
# "Edu2.M" = Proportion of males with at least secondary education = "Population with Secondary Education (Male)" 
# "Labo.F" = Proportion of females in the labour force = "Labour Force Participation Rate (Female)"
# "Labo.M" " Proportion of males in the labour force = "Labour Force Participation Rate (Male)"
# rename columns as above
gii <- rename(gii, "Mat.Mor" = "Maternal Mortality Ratio")
gii <- rename(gii, "Ado.Birth" = "Adolescent Birth Rate")
gii <- rename(gii, "Edu2.F" = "Population with Secondary Education (Female)")
gii <- rename(gii, "Edu2.M" = "Population with Secondary Education (Male)")
gii <- rename(gii, "Labo.F" = "Labour Force Participation Rate (Female)")
gii <- rename(gii, "Labo.M" = "Labour Force Participation Rate (Male)")
colnames(gii)
# columns are renamed


# Mutate the “Gender inequality” data and create two new variables. 
# The ratio of Female and Male populations with secondary education in each country. 
# "Edu2.FM" = Edu2.F / Edu2.M
# The ratio of labor force participation of females and males in each country (labF / labM).
# "Labo.FM" = Labo.F / Labo.M
gii <- mutate(gii, Edu2.FM = (Edu2.F / Edu2.M))
gii <- mutate(gii, Labo.FM = (Labo.F / Labo.M))
colnames(gii)
# mutatating columns worked

# Join together the two data sets using the variable Country as the identifier. 
human <- inner_join(hd, gii, by = "Country")
# look at the column names of the joined data set
colnames(human)
# glimpse at the joined data set
glimpse(human)
#The joined data has 195 observations and 19 variables, as expected. 

#Save the data as human.csv in data folder.
  # set working directory
  setwd("\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project")
# write cleaneddata into a csv file
write.csv(human, file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/human.csv', row.names = FALSE)
