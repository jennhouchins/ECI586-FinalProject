# File:         ~/ECI586-FinalProject/accountability/ui.R
# Project:      Final Project Shiny App
# Author:       Jennifer Houchins
# Description:  Shiny app for ECI 586 final project 
#               exploring NC School Performance data
#
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
dashboardPage(
    dashboardHeader(title = "Accountability"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("About this Dashboard", tabName = "about", icon = icon("book-open")),
            menuItem("Achievement", tabName = "achievement", icon = icon("chart-bar")),
            menuItem("School Performance", tabName = "widgets", icon = icon("school")),
            menuItem("Data Browser", tabName = "tabulate", icon = icon("table")),
            menuItem("Project Information", tabName = "jenn", icon = icon("info"))
            
        )
    ),
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "about",
                    fluidRow(
                        box(title = "Welcome to the NC Public Schools Accountability and Testing Reports Dashboard",
                            solidHeader = TRUE,
                            width = 12,
                            status = "primary",
                            column(6,
                                   br(),
                                   HTML('<img src="NCflagimage.png", width="100%", align=center></img>')
                            ),
                            column(6,
                                   h3(p("How are North Carolina Schools performing?")),
                                   h5(p("This application explores aggregate data collected and reported by the North Carolina Department of Public Instruction. These data include accountability reporting such as schools' performance scores, EVAAS scores and status, achievement scores, and 4-year cohort graduation rates.")),
                                   br(),
                                   br(),
                                   h4("Built with ",
                                      img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
                                      " by ",
                                      img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px")
                                   )
                            )
                        )
                        
                        
                    ),
                    fluidRow(
                        box(title = "Target Audience",
                            solidHeader = TRUE,
                            width = 6, 
                            status = "primary",
                            h5(p("describe target audience"))
                        ),
                        box(title = "Data Sources",
                            solidHeader = TRUE,
                            width = 6, 
                            status = "primary",
                            h5(p("describe data sources"))
                        )
                    )
            ),
            
            # Second tab content
            tabItem(tabName = "achievement",
                    fluidRow(
                        box(
                            title = "Controls",
                            solidHeader = TRUE,
                            width = 4,
                            status = "primary",
                            selectInput("achievementScore",
                                        h5("Achievement Score:"),
                                        choices = list("Reading Achievement" = "rdgs_ach_score",
                                                       "Mathematics Achievement"="mags_ach_score",
                                                       "Overall Achievement" = "ach_score"),
                                        selected = "rdgs_ach_score"),
                            selectInput("reportingyearUpdate", 
                                        h5("Reporting Year:"),
                                        choices = NULL,
                                        selected = "reporting_year")#,
                            # selectInput("achievementRegion",
                            #             h5("Choose Region:"),
                            #             choices = c("North Central" = "north central",
                            #                        "Northeast" = "northeast",
                            #                        "Northwest" = "northwest",
                            #                        "Piedmont-Triad" = "piedmont triad",
                            #                        "Sandhills" = "sandhills",
                            #                        "Southeast" = "southeast",
                            #                        "Southwest" = "southwest",
                            #                        "Virtual" = "virtual",
                            #                        "Western" = "western"),
                            #             selected = "north central")
                        ),
                        box(title = "Region Snapshot",
                            solidHeader = TRUE,
                            width = 8,
                            status = "primary",
                        )
                        
                    ),
                    fluidRow(
                        box(title = "Achievement Distribution Across Regions",
                            solidHeader = TRUE,
                            width = 12,
                            status = "primary",
                            textOutput("boxPlotExplanation"),
                            plotOutput("boxPlot")
                        )
                    )
            ),
            
            
            
            # Third tab content
            tabItem(tabName = "widgets",
                    fluidRow(
                        valueBox(76, "some info", icon = icon("apple"), color = "purple"),
                        valueBox(25, "other info")
                        # box(
                        #     textOutput("regionSnapshot"),
                        #     solidHeader = TRUE
                        # )
                    ),
                    fluidRow(
                        box(
                            title = "Controls",
                            solidHeader = TRUE,
                            width = 3,
                            status = "primary",
                            selectInput("region_with_updateSelectYear",
                                       h4("Reporting Year:"),
                                       choices = NULL,
                                       selected = "reporting_year"),
                           checkboxGroupInput("region_with_updateSelectInput",
                                       h4("Choose Regions:"),
                                       choices = c("North Central" = "north central",
                                                   "Northeast" = "northeast",
                                                   "Northwest" = "northwest",
                                                   "Piedmont-Triad" = "piedmont triad",
                                                   "Sandhills" = "sandhills",
                                                   "Southeast" = "southeast",
                                                   "Southwest" = "southwest",
                                                   "Virtual" = "virtual",
                                                   "Western" = "western"),
                                       selected = c("north central"))
                        ),
                        box(title = "Proportions of Performance Grades",
                            solidHeader = TRUE,
                            width = 8,
                            status = "primary",
                            plotOutput("stackedBar_use_with_updateSelectInput")
                        )
                    )
            ),
            
            # Fourth tab item
            tabItem(tabName = "tabulate",
                    fluidRow(
                        box(title = "How-to Information", width = 12, status = "primary",
                            solidHeader = TRUE,
                            h5(p("You can use this table to explore the school performance data on your own."))
                        )
                    ),    
                    fluidRow(
                        box(title = "School Performance Data", width = 12, status = "primary",
                            solidHeader = TRUE,
                            dataTableOutput("tabulardata")
                            )
                            
                        )
                    ),
            
            # Fifth tab item
            tabItem(tabName = "jenn",
                       fluidRow(
                           # author information
                           box(title = "About the Author", width = 6,status = "primary",solidHeader = TRUE,
                               div(img(src = "JennHeadshot_Small.jpeg", width = "60%"), style="text-align:center;"),
                               br(),
                               h5(p("Jennifer Houchins is a doctoral candidate in Learning Design and Technology at North Carolina State University. Her research examines students’ use of computational thinking and the effective use of instructional technology to deepen conceptual understanding in both formal and informal K-12 learning environments. She currently a graduate research assistant for the InfuseCS and the Programmed Robotics in the School Makerspace (PRISM) projects.")),
                               HTML('<br /><p>You can learn more about Jennifer and her work by <a href="http://jenniferkhouchins.com/">visiting her website.</a></p>')
                           ),
                           # project information
                        box(title = "About this Project", width = 6,status = "primary",solidHeader = TRUE,
                               h5(p("This Shiny app was developed for the final project assignment of ECI 586 (Intro to Learning Analytics). It is designed to follow the Data-Intensive Research Workflow (Krumm, Means, & Bienkowski, 2018). ")),
                            br(),
                            HTML('<p>If you would like to see the code for this project, you can download (or fork) it from the <a href="https://github.com/jennhouchins/ECI586-FinalProject">Github repository.</a></p>'),
                            br(),
                            h4(p("References:")),
                           HTML('<p>Krumm, A., Means, B., & Bienkowski, M. (2018). <i>Learning analytics goes to school: A collaborative approach to improving education.</i> Routledge.</p>')
                           
                        )
                    )
            )
        )
    )
)

# Define UI for application that draws a histogram
# shinyUI(fluidPage(
#     theme = shinythemes::shinytheme("flatly"),
#     # Application title
#     titlePanel("NC Public Schools Accountability and Testing Reports"),
#     
#     navbarPage("Accountability",
#                navbarMenu("About", icon = icon("info"),
#                           tabPanel("Project Information",  fluid = TRUE,
#                                    fluidRow(
#                                        column(6, 
#                                               br(),
#                                               HTML('<img src="NCflagimage.png", width="100%", align=center></img>')
#                                        ),
#                                        column(6, 
#                                               h3(p("What is the state of education in North Carolina?")),
#                                               h5(p("This application explores aggregate data collected and reported by the North Carolina Department of Public Instruction. These data include accountability reporting such as School Report Cards, Student Testing, and Teacher Performance.")),
#                                               br(),
#                                               br(),
#                                               h4("Built with ",
#                                                  img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
#                                                  " by ",
#                                                  img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px")
#                                               )
#                                        )
#                                        
#                                    )
#                           ),
#                           tabPanel("Author Information",  fluid = TRUE,
#                                    fluidRow(
#                                        column(4, 
#                                               # br(),
#                                               HTML('<img src="JennHeadshot_Small.jpeg", width="100%", align=center></img>')
#                                        ),
#                                        column(6, 
#                                               h4(p("The Author")),
#                                               h5(p("Jennifer Houchins is a doctoral candidate in Learning Design and Technology at North Carolina State University. Her research examines students’ use of computational thinking and the effective use of instructional technology to deepen conceptual understanding in both formal and informal K-12 learning environments. She currently a graduate research assistant for the InfuseCS and the Programmed Robotics in the School Makerspace (PRISM) projects.")),
#                                        )
#                                    )
#                           )
#                           
#                ),
#                navbarMenu("Schools", icon = icon("chart-bar"),
#                           tabPanel("Achievement Scores", fluid = TRUE,
#                                    # Sidebar with a dropdown input for score selection
#                                    sidebarLayout(
#                                        sidebarPanel(
#                                            selectInput("achievement", h4("Choose a Score:"),
#                                                        choices = list("Reading Achievement" = "rdgs_ach_score",
#                                                                       "Mathematics Achievement"="mags_ach_score",
#                                                                       "Overall Achievement" = "ach_score"),
#                                                        selected = "rdgs_ach_score")
#                                            
#                                        ),
#                                        
#                                        # Show a generated boxplot
#                                        mainPanel(
#                                            fluidRow(
#                                                textOutput("boxPlotExplanation"),
#                                                br()
#                                            ),
#                                            plotOutput("boxPlot") 
#                                        )
#                                    )
#                           ),
#                           tabPanel("Performance Grades", fluid = TRUE,   
#                                    # Sidebar with a dropdown input for score selection
#                                    sidebarLayout(
#                                        sidebarPanel(
#                                            textOutput("regionSnapshot"),
#                                            br(),
#                                            selectInput("region_with_updateSelectYear",
#                                                        h4("Reporting Year:"),
#                                                        choices = NULL,
#                                                        selected = "reporting_year"),
#                                            checkboxGroupInput("region_with_updateSelectInput", 
#                                                        h4("Choose Regions:"),
#                                                        choices = c("North Central" = "north central",
#                                                                    "Northeast" = "northeast",
#                                                                    "Northwest" = "northwest", 
#                                                                    "Piedmont-Triad" = "piedmont triad",
#                                                                    "Sandhills" = "sandhills",
#                                                                    "Southeast" = "southeast",
#                                                                    "Southwest" = "southwest",
#                                                                    "Virtual" = "virtual",
#                                                                    "Western" = "western"),
#                                                        selected = c("north central"))
#                                            
#                                        ),
#                                        
#                                        # Show a generated stackedBar
#                                        mainPanel(
#                                            fluidRow(
#                                                textOutput("StackedBarExplanation"),
#                                                br()
#                                            ),
#                                            plotOutput("stackedBar_use_with_updateSelectInput")
#                                            
#                                        )
#                                    )
#                           )
#                           
#                ),
#                navbarMenu("Teachers", icon = icon("chalkboard-teacher"),
#                           tabPanel("Teacher Attrition", fluid = TRUE,
#                                    fluidRow(
#                                        column(3),
#                                        column(6, 
#                                               h1(p("Under Construction...")),
#                                               br(),
#                                               HTML('<img src="https://media.giphy.com/media/3oKIPnAiaMCws8nOsE/source.gif", width="100%", class="center", alt="kitteh"></img>')
#                                        )
#                                    )
#                                    
#                           )
#                           
#                )
#                
#     )
# ))
