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

# Define server logic required to draw a histogram
function(input, output, session) {
    # DATA IMPORTS AND SET UP ################################
    
    # setting a variable with the file name
    # this make it easier to run this script on a
    # different file later if applicable
    
    spgdatafile <-"data/SPGData_processed.xlsx"
    
    # get the data from datafile sheet "SPG Data For Download"
    # we have to specify this sheet, because read_excel defaults to
    # the first sheet (which is introduction)
    # could not find a way to get a particular sheet with generic import
    
    # read all columns as text with the col_types option
    # this gets all the data including the entries that are <5 and >95
    # which allows for some data wrangling
    
    spg_data <- read_excel(spgdatafile,
                           sheet = 1) %>%
        mutate(lea_name = as.factor(lea_name)) %>%
        mutate(sbe_region = as.factor(sbe_region)) %>%
        mutate(spg_grade = as.factor(spg_grade)) %>%
        mutate(eg_status = as.factor(eg_status))
    
    updateSelectInput(session,
                      "region_with_updateSelectYear",
                      choices = sort(unique(spg_data$reporting_year)))
    
    updateSelectInput(session,
                      "reportingyearUpdate",
                      choices = sort(unique(spg_data$reporting_year)))
    
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
    
    output$boxPlotExplanation <- renderText({
        "\n\n\nThis box plot shows the score distribution for the selected score across all NC regions."
    })
    
    output$regionSnapshot <- renderText("Explanation of region snapshot")
    
    output$stackedBar_use_with_updateSelectInput <- renderPlot({
        spg_data %>%
            filter(
                sbe_region %in% input$region_with_updateSelectInput,
                reporting_year == input$region_with_updateSelectYear
            ) %>%
            ggplot() +
            geom_bar(mapping = aes(x=sbe_region, y=spg_grade, fill=spg_grade),
                     position = "stack", stat = "identity") +
            theme_minimal() +
            theme(panel.grid.major.x = element_blank(),
                  axis.title.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.title.y = element_blank(),
                  legend.position = "left") +
            coord_flip() + 
            ylab("Number of Schools") + 
            scale_fill_brewer(type = "qual", 
                              palette = "Set3", 
                              direction = -1, 
                              aesthetics = "fill", 
                              guide = guide_legend(title = "School Grade")) 
        
    })
    
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
                            fillContainer = getOption("DT.fillContainer", NULL),
                            rownames = FALSE,
                            options = list(
                                columnDefs = list(list(className = 'dt-center', width = '200px', targets = c(1, 5, 6, 7)))
                            )
    ) %>% formatRound(c(6, #6
                             7, #7
                             9, #9
                             10, #10
                             11, #11
                             12), 1)

    output$tabulardata <- renderDataTable({dt_browser})
    

    
    # output$StackedBarExplanation <- renderText({
    #     paste("\n\n\nThis bar chart shows the school performance grade distribution for the ", 
    #           input$region_with_updateSelectInput, 
    #           "region of North Carolina")
    # })
    
}
