---
  #title: "Data wrangling code"
  #coding_language: "R"
  #author: "Hanna Julku"
  #date: "20.11.2022"
  #Data_source: "https://archive.ics.uci.edu/ml/datasets/Student+Performance"
---
  # load packages to be used
library(tidyverse) # check what's wrong with this
library(dplyr) 
library(boot) 
library(readr)
  
  
  # read the downloaded data files inlcuding questionnaire data to memory and check they look fine
  math <- read.table(file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/student-mat.csv', sep = ";" , header = TRUE)
  por <- read.table(file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/student-por.csv', sep = ";" , header = TRUE)
  
  #look at the dimensions of the data sets
  dim(math)
  dim(por)
  # both have 33 variables; math has 395 observations, por 649 observations
  
  # look at the structure of the data sets
  str(math) 
  str(por)
  # data types: integer and character
  # variable names are the same in both data sets
  
  #combine data sets
  # the following columns vary in the data sets
  vary_cols <- c("failures","paid","absences","G1","G2","G3") 
  # the rest of the columns are common identifiers used for joining the data sets
  join_cols <- setdiff(colnames(por), vary_cols)
  # join the two data sets by the selected identifiers, this will keep only those who are present in both data sets
  math_por <- inner_join(math, por, by = join_cols)
  #look at the structure and dimensions of the combined data set
  str(math_por)
  dim(math_por)
# in the data set there are 370 observations and 39 variables
  
  #there are duplicate records in this combined data set, remove those
  # create a new data frame with only the joined columns
  alc <- select(math_por, all_of(join_cols))
  # for every column name not used for joining...
  for(col_name in vary_cols) {
    # select two columns from 'math_por' with the same original name
    two_cols <- select(math_por, starts_with(col_name))
    # select the first column vector of those two columns
    first_col <- select(two_cols, 1)[[1]]
    
    # then, enter the if-else structure!
    # if that first column vector is numeric...
    if(is.numeric(first_col)) {
      # take a rounded average of each row of the two columns and
      # add the resulting vector to the alc data frame
      alc[col_name] <- round(rowMeans(two_cols))
    } else { # else (if the first column vector was not numeric)...
      # add the first column vector to the alc data frame
      alc[col_name] <- cbind(first_col)
    }
  }
  
  # glimpse at the new combined  to check duplicates are removed
  glimpse(alc)
  # now there are 370 observations and 33 variables, as expected
  
  # next, define alcohol consumption for the whole week and define high use
  # define a new column alc_use by combining weekday and weekend alcohol use
  alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
  # define a new logical column 'high_use'
  alc <- mutate(alc, high_use = ifelse(alc_use > 2, TRUE, FALSE))
  # check that the data looks fine
  glimpse(alc)
  # 370 rows (observations) and 35 columns (variables) now variables are including also alc_use as double and high_use as logic
  
  # set working directory
  setwd("\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project")
  #write data to csv file
  write.csv(alc, file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/alc.csv', row.names = FALSE)
  