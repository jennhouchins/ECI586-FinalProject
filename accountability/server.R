# File:         ~/ECI586-FinalProject/accountability/server.R
# Project:      Final Project Shiny App
# Author:       Jennifer Houchins
# Description:  Shiny app for ECI 586 final project 
#               exploring NC School Performance data
#
#
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(stringr)
library(ggthemes)
library(shiny)
library(shinythemes)
library(readxl)
library(tidyverse)
library(DT)

function(input, output, session) {
    # LOAD THE DATA ################################
    spgdatafile <-"data/SPGData_processed.xlsx"
    
    spg_data <- read_excel(spgdatafile,
                           sheet = 1) %>%
        mutate(lea_name = as.factor(lea_name)) %>%
        mutate(sbe_region = as.factor(sbe_region)) %>%
        mutate(spg_grade = as.factor(spg_grade)) %>%
        mutate(eg_status = as.factor(eg_status)) %>%
        mutate(reporting_year = as.numeric(reporting_year)) %>% 
        mutate(spg_score = as.numeric(spg_score)) %>% 
        mutate(ach_score = as.numeric(ach_score)) %>% 
        mutate(rdgs_ach_score = as.numeric(rdgs_ach_score)) %>%
        mutate(mags_ach_score = as.numeric(mags_ach_score)) %>%
        mutate(cgrs_score = as.numeric(cgrs_score))
    
    arrange(spg_data, reporting_year, sbe_region)
    
    # UPDATE INPUTS ################################
    updateSelectInput(session,
                      "performanceYearSelect",
                      choices = sort(unique(spg_data$reporting_year)))
    
    updateSelectInput(session,
                      "reportingyearUpdate",
                      choices = sort(unique(spg_data$reporting_year)))
    
    # REGIONAL ACHIEVEMENT TAB OUTPUTS ################################
    
    # reactive achievement score boxplot
    output$boxPlot <- renderPlot({
        spg_data_singleyear = spg_data %>%
            filter(
                reporting_year == input$reportingyearUpdate
            ) 
        ggplot(data = spg_data_singleyear, aes_string(x = spg_data_singleyear$sbe_region, 
                                                      y = input$achievementScore, 
                                                      fill=spg_data_singleyear$sbe_region)) +
            geom_boxplot(show.legend = FALSE) +
            theme_minimal() +
            theme(axis.title.x = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.title.y = element_blank()) +
            scale_fill_brewer(palette = "Set3")
        
    })
    
    # reactive explanation of mean achievement regional snapshot
    output$achievementSnapshotExplain <- renderText({
        score <- input$achievementScore
        
        if(score == 'rdgs_ach_score'){
            scoreTitle <- "Reading Achievement"
        } else if(score == 'mags_ach_score'){
            scoreTitle <- "Mathematics Achievement"
        } else {
            scoreTitle <- "Overall Achievement"
        }
        
        paste("The following snapshot shows the mean", 
              scoreTitle, "for the year", input$reportingyearUpdate, 
              "and the change  from the previous year",
              "where green represents an increase in mean score,",
              "orange represent a decrease in the mean score,",
              "and light blue represents either no change or a value of NA.")
    })
    
    # reactive infoBox reporting mean regional achievement
    output$achievementValue <- renderInfoBox({
        score <- input$achievementScore
        
        if(score == 'rdgs_ach_score'){
            scoreTitle <- "Reading Achievement"
        } else if(score == 'mags_ach_score'){
            scoreTitle <- "Mathematics Achievement"
        } else {
            scoreTitle <- "Overall Achievement"
        }
        
        scoreAverage <- spg_data %>%
            filter(
                sbe_region == input$achievementRegion,
                reporting_year == input$reportingyearUpdate
            ) %>%
            select(input$achievementScore) 
        
        scoreAverage <- mean(scoreAverage[[1]], na.rm = TRUE) %>%
            round(2)
        
        infoBox(
            paste("Mean", scoreTitle), scoreAverage, icon = icon("percent"),
            color = "purple", fill = TRUE, width = 4
        )
    })
    
    # reactive infoBox reporting difference in mean achievment from year prior
    output$achievementDifference <- renderInfoBox({
        
        scoreAverage <- spg_data %>%
            filter(
                sbe_region == input$achievementRegion,
                reporting_year == input$reportingyearUpdate
            ) %>%
            select(input$achievementScore)
        
        scoreAverage <- mean(scoreAverage[[1]], na.rm = TRUE)
        
        if (input$reportingyearUpdate == 2015) {
            meanDiff <- NA 
        } else {
            year = as.numeric(input$reportingyearUpdate) - 1
            prevAverage <- spg_data %>%
                filter(
                    sbe_region == input$achievementRegion,
                    reporting_year == year
                ) %>%
                select(input$achievementScore)
            
            prevAverage <- mean(prevAverage[[1]], na.rm = TRUE)
            
            meanDiff <- round(prevAverage - scoreAverage, 2)
        }
        
        if (is.na(meanDiff) | meanDiff == 0){
            infoBoxColor = "light-blue"
            infoBoxIcon = "window-minimize"
        } else if (meanDiff > 0) {
            infoBoxColor = "green"
            infoBoxIcon = "arrow-up"
        } else if (meanDiff < 0){
            infoBoxColor = "orange"
            infoBoxIcon = "arrow-down"
        }
        
        infoBox(
            "Change", abs(meanDiff), icon = icon(infoBoxIcon),
            color = infoBoxColor, fill = TRUE, width = 4
        )
    })
    
    
    # REGIONAL SCHOOL PERFORMANCE OUTPUTS ################################
    
    # reactive valueBox reporting total number of schools in region
    output$numSchoolsTotal <- renderValueBox({
        
        filtereddata <- spg_data %>%
            filter(
                sbe_region == input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect
            )
        
        schoolCount <- unique(filtereddata$school_name) %>%
            length() 
        
        valueBox(schoolCount, "Number of Schools", icon = icon("school"),
                 color = "purple")
    })
    
    # reactive valueBox reporting number of high performing schools in region
    output$numASchools <- renderValueBox({
        
        filtereddata <- spg_data %>%
            filter(
                sbe_region == input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect,
                spg_grade %in% c("A", "A+NG")
            )
        
        schoolCount <- unique(filtereddata$school_name) %>%
            length() 
        
        valueBox(schoolCount, "High Performing Schools", icon = icon("star"),
                 color = "green")
    })
    
    # reactive valueBox reporting low performing schools in region
    output$numFSchools <- renderValueBox({
        
        filtereddata <- spg_data %>%
            filter(
                sbe_region == input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect,
                spg_grade == "F"
            )
        
        schoolCount <- unique(filtereddata$school_name) %>%
            length() 
        
        valueBox(schoolCount, "Low Performing Schools", 
                 icon = icon("star-half"),
                 color = "orange")
    })
    
    # reactive valueBox reporting num schools in region where growth not met
    output$numSchoolsNotMet <- renderValueBox({
        
        filtereddata <- spg_data %>%
            filter(
                sbe_region == input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect,
                eg_status == "NotMet"
            )
        
        schoolCount <- unique(filtereddata$school_name) %>%
            length()
        
        valueBox(schoolCount, "Growth Not Met", 
                 icon = icon("times"),
                 color = "red")
    })
    
    # reactive valueBox reporting num schools in region where growth met
    output$numSchoolsMet <- renderValueBox({
        
        filtereddata <- spg_data %>%
            filter(
                sbe_region == input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect,
                eg_status == "Met"
            )
        
        schoolCount <- unique(filtereddata$school_name) %>%
            length()
        
        valueBox(schoolCount, "Growth Met", 
                 icon = icon("check"),
                 color = "blue")
    })
    
    # reactive valueBox reporting num schools in region where growth exceeded
    output$numSchoolsExceeded <- renderValueBox({
        filtereddata <- spg_data %>%
            filter(
                sbe_region == input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect,
                eg_status == "Exceeded"
            )
        
        schoolCount <- unique(filtereddata$school_name) %>%
            length()
        
        valueBox(schoolCount, "Growth Exceeded", 
                 icon = icon("check-double"),
                 color = "fuchsia")
    })
    
    # reactive bar chart that shows regional distribution of performance grades
    output$stackedBar_use_with_updateSelectInput <- renderPlot({
        spg_data %>%
            filter(
                sbe_region %in% input$performanceRegionSelect,
                reporting_year == input$performanceYearSelect
            ) %>%
            ggplot() +
            geom_bar(mapping = aes(x=spg_grade, fill=spg_grade)) +
            theme_minimal() +
            theme(panel.grid.major.x = element_blank(),
                  axis.title.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.title.y = element_blank(),
                  axis.ticks.y = element_blank(),
                  legend.position = "left") +
            scale_fill_brewer(type = "qual", 
                              palette = "Set3", 
                              direction = -1, 
                              aesthetics = "fill", 
                              guide = guide_legend(title = "School Grade")) 
        
    })
    
    # DATA BROWSER TAB OUTPUTS ################################
    
    # set up tabular data for data browsing using datatable
    tabularspg <- spg_data %>%
        select(reporting_year,
               lea_name,
               school_name,
               sbe_region,
               spg_grade,
               spg_score,
               eg_score,
               eg_status,
               ach_score,
               rdgs_ach_score,
               mags_ach_score,
               cgrs_score) %>%
        mutate(sbe_region = str_to_title(sbe_region))
    
    # formatting to make the datatable easier to read and comprehend
    # and setting table options
    dt_browser <- datatable(tabularspg, 
                            colnames = c("Year", #1
                                         "LEA", #2
                                         "School", #3
                                         "Region", #4
                                         "Grade", #5
                                         "Score", #6
                                         "EVAAS Score", #7
                                         "EVAAS Status", #8
                                         "Overall Achievement", #9
                                         "Reading Achievement", #10
                                         "Math Achievement", #11
                                         "4-year Cohort Graduation Rate"), #12
                            extensions = "Responsive",
                            style = 'bootstrap',
                            filter = "top",
                            fillContainer = getOption("DT.fillContainer", NULL),
                            rownames = FALSE,
                            options = list(
                                columnDefs = list(list(className = 'dt-center', width = '200px', targets = c(1, 5, 6, 7)))
                            )
    ) %>% formatRound(c(6,7,9,10,11,12), 1)

    # responsive datatable of school performance and achievement data
    output$tabulardata <- renderDataTable({dt_browser})
    
    
}
