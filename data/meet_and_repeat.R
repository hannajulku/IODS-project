---
  #title: "Data wrangling code"
  #coding_language: "R"
  #author: "Hanna Julku"
  #date: "4.12.2022"
  #Data_sources: "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt"
  # and "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt"
  ---
  
  #load libraries to be used
  library(tidyverse)
  
  # read data sets to memory  
  BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
  RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')
  
  
  #have a look at the data sets
  str(BPRS)
  dim(BPRS)
  summary(BPRS)
  glimpse(BPRS)
  # BPRS contains 40 observations and 11 variables
  # treatment is either of the randomly selected treatment groups
  # subject is subject number
  # week numbers: 0 refer to the baseline and 1-8 weeks from the beginning of treatment
  # value in week refers to brief psychiatric rating scale (BPRS) score. 
      # The scale is used to evaluate patients suspected of having schizophrenia.
  
  str(RATS)
  dim(RATS)
  summary(RATS)
  glimpse(RATS)
  # RATS consists of 16 observations and 13 variables
  # ID refers to subject
  # Group refers to diet group
  # WDX value refers to body weight and WD number refers to days from the beginning of experiment
  
  # in both data sets data is in wide form
  
  # convert categorical variables to factors
  # those are: BPRS treatment + subject and RATS Group + ID
  BPRS$treatment <- factor(BPRS$treatment)
  BPRS$subject <- factor(BPRS$subject)
  RATS$ID <- factor(RATS$ID)
  RATS$Group <- factor(RATS$Group)

  # convert data sets to long form
  # Convert to long form
  BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                         names_to = "weeks", values_to = "bprs") %>%
    arrange(weeks) #order by weeks variable
  
  # Extract the week number and add a week variable to BPRSL
  BPRSL <-  BPRSL %>% 
    mutate(week = as.integer(substr(weeks,5,6)))
  
  # Convert data to long form
  RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                        names_to = "WD",
                        values_to = "Weight") %>% 
    mutate(Time = as.integer(substr(WD, 3,5))) %>%
    arrange(Time)
  
  # have a look at the data again
  str(BPRSL)
  dim(BPRSL)
  summary(BPRSL)
  glimpse(BPRSL)
  
  # now there are 360 observations and 5 variables
  # week numbers are now separated as their own variable
  # values related to prior weekx variables are presented now in bprs variable as a list 

  str(RATSL)
  dim(RATSL)
  summary(RATSL)
  glimpse(RATSL)
  # there are 176 observations and 5 variables
  # values related to WDX variables are now presented in variable Weight as a list
  # Day of the measurement from the WDX name are presented in variable Time
  
  # for both data sets data form is tibble
  # now data sets are in long form. 
  # That means that all observations are presented after each other so that those
   # can be viewed as continuous rather than separate
  
  # write data sets into csv files
  write.csv(BPRSL, file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/BPRSL.csv', row.names = FALSE)
  write.csv(RATSL, file = '\\\\ad.helsinki.fi/home/h/hkonstar/Desktop/IDOS/IODS-project/data/RATSL.csv', row.names = FALSE)
  