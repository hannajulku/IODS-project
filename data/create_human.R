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


# Here starts the second part of data wrangling for this data set
#load libraries to be used
library(tidyverse)
library(tidyr)

# read the human data
human <- read.table("\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/human.csv", 
                    sep =",", header = T)

# look at the (column) names of human
names(human)
# look at the structure of human
str(human)
# look at the dimensions
dim(human)
# print out summaries of the variables
summary(human)

# This data has 195 observations and 19 variables. 
 # The data is from project defining human developmental index, that takes into account different societal aspect
    # The data combines several indicators from most countries in the world
    # "Country" = Country name
      # Health and knowledge
          #"GNI" = Gross National Income per capita
          #"Life.Exp"= Life expectancy at birth
          #"Edu.Exp" = Expected years of schooling 
          #"Mat.Mor" = Maternal mortality ratio
          #"Ado.Birth" = Adolescent birth rate
      # Empowerment
          #"Parli.F" = Percetange of female representatives in parliament
          #"Edu2.F" = Proportion of females with at least secondary education
          #"Edu2.M" = Proportion of males with at least secondary education
          #"Labo.F" = Proportion of females in the labour force
          #"Labo.M" " Proportion of males in the labour force
          #"Edu2.FM" = Edu2.F / Edu2.M
          #"Labo.FM" = Labo2.F / Labo2.M

#last time I had accidently missed renaming "Percent.Representation.in.Partiament" as "Parli.F".
#Will do that now before continuing with mutating data
human <- rename(human, "Parli.F" = "Percent.Representation.in.Parliament")

# change GNI to numeric
human$GNI <- as.numeric(human$GNI)
glimpse(human)
# seems that as.numeric worked, and also renaming variable to Parli.F

# keep only variables "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"
# columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
# select the 'keep' columns
human <- select(human, one_of(keep))

# remove rows with missing values
# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human <- filter(human, complete.cases(human) ,TRUE) 

# check what is in the country varible
print(human$Country)
# last 7 observation are related to region instead of country
#remove these 7 last observations
# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

# define row names as countries
rownames(human) <- human$Country

# check the index for variable country
str(human)
# remove country column
human <- human[, -1]
# check that removed variable was country
str(human)
#there are 155 observations and 8 variables, as supposed to be
#check that row names are included
human
# yup, data looks as it should, Row names are countries and other included variables are
# Edu2.FM, Labo.FM, Life.Exp, Edu.Exp, GNI Mat.Mor, Ado.Birth, and Parli.F

#Save the data as human.csv in data folder.
# set working directory
setwd("\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project")
# write human into a csv file, old one will be overwritten
write.csv(human, file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/human.csv', row.names = TRUE)



