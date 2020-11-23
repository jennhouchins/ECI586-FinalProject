# File:         ~/ECI586-FinalProject/accountability/wrangle/wrangledata.R
# Project:      Final Project Shiny App
# Author:       Jennifer Houchins
# Description:  Data wrangling R code for ECI 586 final project Shiny app
#               exploring NC School Performance data
#


# INSTALL AND LOAD PACKAGES ################################
# followed the LinkedIn exercises for using pacman here 
if (!require("pacman")) install.packages("pacman")

pacman::p_load(chartr,
               ggthemes, 
               pacman, 
               readxl, rio, 
               shiny, shinythemes, 
               tidyverse,
               writexl)



# listing the packages and what they do seems like good practice
# so i follow the LinkedIn exercises here
# ggthemes: themes package for ggplot
# pacman: for loading/unloading packages
# readxl: for working with xls(x) sheets particularly
# rio: for importing data
# shiny: for interactive data exploration apps
# shinythemes: to make shiny pretty
# tidyverse: for so many reasons

# DATA IMPORTS AND SET UP ################################

# setting a variable with the file name
# this make it easier to run this script on a
# different file later if applicable
workingdir <- getwd()
datafile1 <- file.path(workingdir, "accountability","data", "spg1415.xlsx")
datafile2 <- file.path(workingdir, "accountability","data", "spg1516.xlsx")
datafile3 <- file.path(workingdir, "accountability","data", "spg1617.xlsx")
datafile4 <- file.path(workingdir, "accountability","data", "spg1718.xlsx")
datafile5 <- file.path(workingdir, "accountability","data", "spg1819.xlsx")

# oldformatdf <- data.frame(datafile1, datafile2, datafile3)
# newformatdf <- data.frame(datafile4, datafile5)


# get the data from datafile sheet "SPG Data For Download"
# we have to specify this sheet, because read_excel defaults to
# the first sheet (which is introduction)
# could not find a way to get a particular sheet with generic import

# read all columns as text with the col_types option
# this gets all the data including the entries that are <5 and >95
# which allows for some data wrangling

# get 17-18 school year
spg_data1718 <- read_excel(datafile4,
                       sheet = "SPG Data For Download",
                       col_types = c("text")) %>%
  select(reporting_year,
         lea_name,
         school_code,
         school_name,
         sbe_region,
         subgroup,
         spg_grade,
         spg_score,
         eg_score,
         eg_status,
         ach_score,
         rdgs_ach_score,
         mags_ach_score,
         cgrs_score) %>%
  filter(subgroup == "ALL" & !xor(spg_grade == "I", spg_grade == "ALT")) %>%
  mutate(lea_name = as.factor(lea_name)) %>%
  mutate(sbe_region = as.factor(gsub("([-]|\\s)|(\\b(\\w*region\\w*)\\b)+", " ", tolower(sbe_region)))) %>%
  mutate(spg_grade = as.factor(spg_grade)) %>%
  mutate(spg_score = as.numeric(gsub("[\\<,\\>]", "", spg_score))) %>% 
  mutate(ach_score = as.numeric(gsub("[\\<,\\>]", "", ach_score))) %>% 
  mutate(rdgs_ach_score = as.numeric(gsub("[\\<,\\>]", "", rdgs_ach_score))) %>%
  mutate(mags_ach_score = as.numeric(gsub("[\\<,\\>]", "", mags_ach_score))) %>%
  mutate(cgrs_score = as.numeric(gsub("[\\<,\\>]", "", cgrs_score))) %>%
  
  drop_na()

# now get 18-19 school year
spg_data1819 <- read_excel(datafile5,
                           sheet = "SPG Data For Download",
                           col_types = c("text")) %>%
  select(reporting_year,
         lea_name,
         school_code,
         school_name,
         sbe_region,
         subgroup,
         spg_grade,
         spg_score,
         eg_score,
         eg_status,
         ach_score,
         rdgs_ach_score,
         mags_ach_score,
         cgrs_score) %>%
  filter(subgroup == "ALL" & !xor(spg_grade == "I", spg_grade == "ALT")) %>%
  mutate(lea_name = as.factor(lea_name)) %>%
  mutate(sbe_region = as.factor(gsub("([-]|\\s)|(\\b(\\w*region\\w*)\\b)+", " ", tolower(sbe_region)))) %>%
  mutate(spg_grade = as.factor(spg_grade)) %>%
  mutate(spg_score = as.numeric(gsub("[\\<,\\>]", "", spg_score))) %>% 
  mutate(ach_score = as.numeric(gsub("[\\<,\\>]", "", ach_score))) %>% 
  mutate(rdgs_ach_score = as.numeric(gsub("[\\<,\\>]", "", rdgs_ach_score))) %>%
  mutate(mags_ach_score = as.numeric(gsub("[\\<,\\>]", "", mags_ach_score))) %>%
  mutate(cgrs_score = as.numeric(gsub("[\\<,\\>]", "", cgrs_score))) %>%
  
  drop_na()

# combine the latest two years with the newer excel format into the overall dataset
spg_data_combined <- rbind(spg_data1718, spg_data1819) %>%
  subset(select = -c(subgroup))

# drop spg_data1718 and spg_data1819 to clear memory
rm(spg_data1718, spg_data1819)

# get the data from the older formatted excel files (datafiles 1 - 3)
# with some wrangling of that pesky data due to data-entry shenanigans

# get 14-15 school year
spg_data1415 <- read_excel(datafile1,
                           sheet = 1,
                           range = "A8:X2597",
                           col_names = TRUE,
                           col_types = c("text")) %>%
  select("LEA Name",
         "School Code",
         "School Name",
         "SBE District",
         "SPG Grade",
         "SPG Score",
         "EVAAS Growth Score",
         "EVAAS Growth Status",
         "Overall Achievement Score*",
         "Read Score*",
         "Math Score*",
         "Cohort Graduation Rate Standard Score*") %>%
  rename(
    lea_name = "LEA Name",
    school_code = "School Code",
    school_name = "School Name",
    sbe_region = "SBE District",
    spg_grade = "SPG Grade",
    spg_score = "SPG Score",
    eg_score = "EVAAS Growth Score",
    eg_status = "EVAAS Growth Status",
    ach_score = "Overall Achievement Score*",
    rdgs_ach_score = "Read Score*",
    mags_ach_score = "Math Score*",
    cgrs_score = "Cohort Graduation Rate Standard Score*"
  ) %>%
  
  filter(!xor(spg_grade == "I", spg_grade == "ALT")) %>%
  mutate(lea_name = as.factor(lea_name)) %>%
  mutate(sbe_region = as.factor(gsub("([-]|\\s)|(\\b(\\w*region\\w*)\\b)+", " ", tolower(sbe_region)))) %>%
  mutate(spg_grade = as.factor(spg_grade)) %>%
  mutate(spg_score = as.numeric(gsub("[\\<,\\>]", "", spg_score))) %>% 
  mutate(ach_score = as.numeric(gsub("[\\<,\\>]", "", ach_score))) %>% 
  mutate(rdgs_ach_score = as.numeric(gsub("[\\<,\\>]", "", rdgs_ach_score))) %>%
  mutate(mags_ach_score = as.numeric(gsub("[\\<,\\>]", "", mags_ach_score))) %>%
  mutate(cgrs_score = as.numeric(gsub("[\\<,\\>]", "", cgrs_score))) %>%
  
  drop_na()

# add the reporting year and then combine into larger dataset
spg_data1415$reporting_year <- 2015
spg_data_combined <- rbind(spg_data_combined, spg_data1415)

# more clean up 
rm(spg_data1415)
# now get 15-16 school year
spg_data1516 <- read_excel(datafile2,
                           sheet = 1,
                           range = "A7:X2608",
                           col_names = TRUE,
                           col_types = c("text")) %>%
  select("District Name",
         "School Code",
         "School Name",
         "State Board Region",
         "SPG Grade",
         "SPG Score",
         "EVAAS Growth Score",
         "EVAAS Growth Status",
         "Overall Achievement Score",
         "Reading Score*",
         "Math Score*",
         "4-Year Cohort Graduation Rate Score*") %>%
  rename(
    lea_name = "District Name",
    school_code = "School Code",
    school_name = "School Name",
    sbe_region = "State Board Region",
    spg_grade = "SPG Grade",
    spg_score = "SPG Score",
    eg_score = "EVAAS Growth Score",
    eg_status = "EVAAS Growth Status",
    ach_score = "Overall Achievement Score",
    rdgs_ach_score = "Reading Score*",
    mags_ach_score = "Math Score*",
    cgrs_score = "4-Year Cohort Graduation Rate Score*"
  ) %>%
  
  filter(!xor(spg_grade == "I", spg_grade == "ALT")) %>%
  mutate(lea_name = as.factor(lea_name)) %>%
  mutate(sbe_region = as.factor(gsub("([-]|\\s)|(\\b(\\w*region\\w*)\\b)+", " ", tolower(sbe_region)))) %>%
  mutate(spg_grade = as.factor(spg_grade)) %>%
  mutate(spg_score = as.numeric(gsub("[\\<,\\>]", "", spg_score))) %>% 
  mutate(ach_score = as.numeric(gsub("[\\<,\\>]", "", ach_score))) %>% 
  mutate(rdgs_ach_score = as.numeric(gsub("[\\<,\\>]", "", rdgs_ach_score))) %>%
  mutate(mags_ach_score = as.numeric(gsub("[\\<,\\>]", "", mags_ach_score))) %>%
  mutate(cgrs_score = as.numeric(gsub("[\\<,\\>]", "", cgrs_score))) %>%
  
  drop_na()

# add the reporting year and then combine into larger dataset
spg_data1516$reporting_year <- 2016
spg_data_combined <- rbind(spg_data_combined, spg_data1516)

# clean up, clean up...
rm(spg_data1516)

# now get 16-17 school year
spg_data1617 <- read_excel(datafile3,
                           sheet = 1,
                           range = "A7:X2629",
                           col_names = TRUE,
                           col_types = c("text")) %>%
  select("District Name",
         "School Code",
         "School Name",
         "SBE District",
         "SPG Grade",
         "SPG Score",
         "EVAAS Growth Score",
         "EVAAS Growth Status",
         "Overall Achievement Score",
         "Reading Score*",
         "Math Score*",
         "4-Year Cohort Graduation Rate Score*") %>%
  rename(
    lea_name = "District Name",
    school_code = "School Code",
    school_name = "School Name",
    sbe_region = "SBE District",
    spg_grade = "SPG Grade",
    spg_score = "SPG Score",
    eg_score = "EVAAS Growth Score",
    eg_status = "EVAAS Growth Status",
    ach_score = "Overall Achievement Score",
    rdgs_ach_score = "Reading Score*",
    mags_ach_score = "Math Score*",
    cgrs_score = "4-Year Cohort Graduation Rate Score*"
  ) %>%
  
  filter(!xor(spg_grade == "I", spg_grade == "ALT")) %>%
  mutate(lea_name = as.factor(lea_name)) %>%
  mutate(sbe_region = as.factor(gsub("([-]|\\s)|(\\b(\\w*region\\w*)\\b)+", " ", tolower(sbe_region)))) %>%
  mutate(spg_grade = as.factor(spg_grade)) %>%
  mutate(spg_score = as.numeric(gsub("[\\<,\\>]", "", spg_score))) %>% 
  mutate(ach_score = as.numeric(gsub("[\\<,\\>]", "", ach_score))) %>% 
  mutate(rdgs_ach_score = as.numeric(gsub("[\\<,\\>]", "", rdgs_ach_score))) %>%
  mutate(mags_ach_score = as.numeric(gsub("[\\<,\\>]", "", mags_ach_score))) %>%
  mutate(cgrs_score = as.numeric(gsub("[\\<,\\>]", "", cgrs_score))) %>%
  
  drop_na()

# add the reporting year and then combine into larger dataset 

spg_data1617$reporting_year <- 2017
spg_data_combined <- rbind(spg_data_combined, spg_data1617)

# clean up, clean up...
rm(spg_data1617)

# order the data by reporting year and region before outputting to a file
spg_data_combined <- arrange(spg_data_combined, reporting_year, sbe_region)

# save the processed uniform data for the shiny app's use
outputpath <- file.path(workingdir, "accountability", "data", "SPGData_processed.xlsx")
write_xlsx(spg_data_combined, outputpath)
