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
  # Prepare variable deep by selecting appropriate variables and divide with their count
    # D03+D11+D19+D27+D07+D14+D22+D30+D06+D15+D23+D31, count 12
  fulldata$deep <-  
  # Prepare variable stra by selecting approapriate variables and divide with their count
    # ST01+ST09+ST17+ST25+ST04+ST12+ST20+ST28
  fulldata$stra <-
  # Prepare variable surf 
    # SU02+SU10+SU18+SU26+SU05+SU13+SU21+SU29+SU08+SU16+SU24+SU32, count 12
  fulldata$surf <-   
    
# Exclude observations where points value is 0
    # cleaneddata <- analysisdata %>% 
    # filter(points !=0)
    
# write cleaneddata into a csv file