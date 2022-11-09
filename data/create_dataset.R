---
#title: "Data wrangling code"
#coding_language: "R"
#author: "Hanna Julku"
#date: "8.11.2022"
#Original_data: "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"
---

# to install needed packages use the following, first take off the hashtag
    # install.packages("tidyverse")
    # install.packages("GGally") 
# load packages to be used
library(tidyverse)
library(GGally)

# read data into memory
  fulldata <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
  
# Look at the dimensions of the data
  dim(fulldata)
  # Data consist of 183 rows and 60 columns
  
# Look at the structure of the data
  str(fulldata)
  # data includes variable scores and demographics as gender and age 
  
#create dataset for analysis 
  # variables to select gender, age, attitude, deep, stra, surf, and points
  # Prepare Attitude column to attitude column, which gives the mean value instead of count
    # create column 'attitude' by scaling the column "Attitude"
  fulldata$attitude <- fulldata$Attitude / 10
  # Access the dplyr library
  library(dplyr)
  # Prepare variables deep, surf, and stra
  # questions related to deep, surface and strategic learning
  deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06", "D15", "D23", "D31")
  surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
  strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
  # select the columns related to deep learning 
  deep_columns <- select(fulldata, one_of(deep_questions))
    # and create column 'deep' by averaging
  fulldata$deep <- rowMeans(deep_columns)
  # select the columns related to surface learning 
  surface_columns <- select(fulldata, one_of(surface_questions))
    # and create column 'surf' by averaging
  fulldata$surf <- rowMeans(surface_columns)
  # select the columns related to strategic learning 
  strategic_columns <- select(fulldata, one_of(strategic_questions)) 
    # and create column 'stra' by averaging
  fulldata$stra <- rowMeans(strategic_columns)

# Select  columns to be included in the analysis dataset 
    # choose columns to keep
  analysisdata <- fulldata[c("gender","Age","attitude", "deep", "stra", "surf", "Points")]
    
# Exclude observations where points value is 0
    cleaneddata <- analysisdata %>% 
    filter(Points !=0)
    
# check the structure of cleaned dataset
    str(cleaneddata)
    # 16 observations and 7 variables, as expected by instructions

# set working directory
    setwd("\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project")
    # write cleaneddata into a csv file
    write.csv(cleaneddata, file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/exp2data.csv', row.names = FALSE)
# read created file to data frame andheck it looks fine
    exp2data <- read.csv(file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/exp2data.csv')
    str(exp2data) 
    head(exp2data)
    # data inspection shows that it is still having 166 observations and 7 variables
    # also data looks as expected
