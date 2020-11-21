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
    dashboardHeader(title = "NC Public Schools Accountability and Testing Reports"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard Information", tabName = "about", icon = icon("info")),
            menuItem("Achievement", tabName = "achievement", icon = icon("chart-bar")),
            menuItem("School Performance", tabName = "widgets", icon = icon("school")),
            menuItem("Data Browser", tabName = "tabulate", icon = icon("table")),
            menuItem("About the Author", tabName = "jenn", icon = icon("user-edit")),
            menuItem("About the Project", tabName = "project", icon = icon("github"))
            
        )
    ),
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "about",
                    fluidRow(
                        column(6,
                               br(),
                               HTML('<img src="NCflagimage.png", width="100%", align=center></img>')
                        ),
                        column(6,
                               h3(p("What is the state of education in North Carolina?")),
                               h5(p("This application explores aggregate data collected and reported by the North Carolina Department of Public Instruction. These data include accountability reporting such as School Report Cards, Student Testing, and Teacher Performance.")),
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
            
            # Second tab content
            tabItem(tabName = "achievement",
                    fluidRow(
                        box(
                            title = "Controls",
                            selectInput("achievement", h4("Choose a Score:"),
                                       choices = list("Reading Achievement" = "rdgs_ach_score",
                                                      "Mathematics Achievement"="mags_ach_score",
                                                      "Overall Achievement" = "ach_score"),
                                       selected = "rdgs_ach_score")
                        ),
                        box(title = "Achievement Distribution",
                            textOutput("boxPlotExplanation"),
                            plotOutput("boxPlot")
                        )
                        
                    )
            ),
            
            
            
            # Third tab content
            tabItem(tabName = "widgets",
                    # fluidRow(
                    #     box(
                    #         textOutput("regionSnapshot"),
                    #         solidHeader = TRUE
                    #     )
                    # ),
                    fluidRow(
                        box(
                            title = "Filters",
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
                        box(
                            plotOutput("stackedBar_use_with_updateSelectInput")
                        )
                    )
            ),
            
            # Fourth tab item
            tabItem(tabName = "tabulate",
                        fluidPage(
                            dataTableOutput("tabulardata")
                        )
                    ),
            
            # Fifth tab item
            tabItem(tabName = "jenn",
                       fluidRow(
                           column(3,
                                  HTML('<img src="JennHeadshot_Small.jpeg", width="115%", align=center></img>')
                           ),
                           column(8,
                                  # h4(p("The Author")),
                                  h5(p("Jennifer Houchins is a doctoral candidate in Learning Design and Technology at North Carolina State University. Her research examines students’ use of computational thinking and the effective use of instructional technology to deepen conceptual understanding in both formal and informal K-12 learning environments. She currently a graduate research assistant for the InfuseCS and the Programmed Robotics in the School Makerspace (PRISM) projects.")),
                                  HTML('<p>You can learn more about Jennifer and her work by <a href="http://jenniferkhouchins.com/">visiting her website.</a></p>')
                           )
                       )
                    ),
            
            # Sixth tab item
            tabItem(tabName = "project",
                    fluidRow(
                        column(8,
                               h4(p("About the Project")),
                               h6(p("This Shiny app was developed for the final project assignment of ECI 586 (Intro to Learning Analytics).")),
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
