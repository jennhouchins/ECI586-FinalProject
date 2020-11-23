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
library(DT)

dashboardPage(
    dashboardHeader(title = "Accountability"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("About this Dashboard", tabName = "about", icon = icon("book-open")),
            menuItem("Regional Achievement", tabName = "achievement", icon = icon("chart-bar")),
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
                                   div(img(src = "NCflagimage.png", width = "100%"), style="text-align:center; margin-top: 45px;")
                            ),
                            column(6,
                                   h5(p("This application explores aggregate data collected and reported by the North Carolina Department of Public Instruction. These data include accountability reporting such as schools' performance scores, EVAAS scores and status, achievement scores, and 4-year cohort graduation rates.")),
                                   br(),
                                   h5(p("The purpose of this dashboard is to allow users to ask the questions: ")),
                                   HTML('<p><ul><li>What does school achievement look like in my region?</li><li>How are North Carolina schools performing across my region?</li></ul></p>'),
                                   br(),
                                   h5(p("Users of this dashboard should note that while data reported across multiple years is shown, yearly comparisons are not provided. This is due to reporting changes resulting from the Every Student Succeeds Act (ESSA). Therefore, care should be taken when drawing your own conclusions from the data presented. Context is provided when the dashboard designer has provided interpretations of the data for the user.")),
                                   br(),
                                   h4("This dashboard was built with ",
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
                            h5(p("This dashboard is intended to inform education community stakeholders in the state of North Carolina, particularly parents, educators, administrators, and education policy makers. Due to the nature of this wide-ranging audience, the dashboard provides explanations for how the data used are calculated and/or reported to provide necessary context for interpretation.")),
                            HTML('<p>For more infomation on education in NC, please visit the link below: <br /><a href="https://www.dpi.nc.gov/districts-schools/testing-and-school-accountability/school-accountability-and-reporting/accountability-data-sets-and-reports">NC DPI Testing and School Accountability Data Sets and Reports</a> </p>')
                        ),
                        box(title = "Data Sources",
                            solidHeader = TRUE,
                            width = 6, 
                            status = "primary",
                            h5(p("The data used in this dashboard are the testing and accountability data sets collected and used to generate school accountability reports by the North Carolina Department of Public Instruction. The accountabilty data sets obtained from NC DPI consisted of accountability data for the academic years of 2014-2015 to 2018-2019.")),
                            HTML('<p>To download these data, please visit the link below:<br /><a href="https://www.dpi.nc.gov/">NC Department of Public Instruction</a></p>')
                        )
                    )
            ),
            
            # Second tab content
            tabItem(tabName = "achievement",
                    fluidRow(
                        box(
                            title = "What Region Would You Like to Examine?",
                            solidHeader = TRUE,
                            width = 6,
                            status = "primary",
                            selectInput("reportingyearUpdate", 
                                        h5("Reporting Year:"),
                                        choices = NULL,
                                        selected = "reporting_year"),
                            selectInput("achievementRegion",
                                        h5("Region:"),
                                        choices = c("North Central" = "north central",
                                                   "Northeast" = "northeast",
                                                   "Northwest" = "northwest",
                                                   "Piedmont-Triad" = "piedmont triad",
                                                   "Sandhills" = "sandhills",
                                                   "Southeast" = "southeast",
                                                   "Southwest" = "southwest",
                                                   "Virtual" = "virtual",
                                                   "Western" = "western"),
                                        selected = "north central"),
                            selectInput("achievementScore",
                                        h5("Score:"),
                                        choices = list("Reading Achievement" = "rdgs_ach_score",
                                                       "Mathematics Achievement"="mags_ach_score",
                                                       "Overall Achievement" = "ach_score"),
                                        selected = "rdgs_ach_score")
                        ),
                        box(title = "Regional Achievement at a Glance",
                            solidHeader = TRUE,
                            width = 6,
                            status = "primary",
                            br(),
                            br(),
                            textOutput("achievementSnapshotExplain"),
                            br(),
                            br(),
                            br(),
                            infoBoxOutput("achievementValue", width = 6),
                            infoBoxOutput("achievementDifference", width = 6)
                        )
                    ),
                    fluidRow(
                        box(title = "How Does This Region Compare to the Others?",
                            solidHeader = TRUE,
                            width = 12,
                            status = "primary",
                            plotOutput("boxPlot")
                        )
                    )
            ),
            
            
            
            # Third tab content
            tabItem(tabName = "widgets",
                    fluidRow(
                           box(
                               title = "What Region Would You Like to Examine?",
                               solidHeader = TRUE,
                               width = 4,
                               status = "primary",
                               selectInput("performanceYearSelect",
                                           h4("Year:"),
                                           choices = NULL,
                                           selected = "reporting_year"),
                               br(),
                               selectInput("performanceRegionSelect",
                                                  h4("Region:"),
                                                  choices = c("North Central" = "north central",
                                                              "Northeast" = "northeast",
                                                              "Northwest" = "northwest",
                                                              "Piedmont-Triad" = "piedmont triad",
                                                              "Sandhills" = "sandhills",
                                                              "Southeast" = "southeast",
                                                              "Southwest" = "southwest",
                                                              "Virtual" = "virtual",
                                                              "Western" = "western"),
                                                  selected = "north central")#,
                               # selectInput("performanceleaSelect",
                               #             h4("Local Education Agency:"),
                               #             choices = NULL,
                               #             selected = "lea_name")
                           ),
                           box(
                               title = "Regional Performance at a Glance",
                               solidHeader = TRUE,
                               status = "primary",
                               width = 8,
                               valueBoxOutput("numSchoolsTotal"),
                               valueBoxOutput("numASchools"),
                               valueBoxOutput("numFSchools"),
                               valueBoxOutput("numSchoolsNotMet"),
                               valueBoxOutput("numSchoolsMet"),
                               valueBoxOutput("numSchoolsExceeded"),
                               br(),
                               h5(p("High performing schools are classified as those schools receiving a grade of A or A+NG. Low performing schools are classified as those receiving a grade of F."))
                           )
                    ),
                    fluidRow(
                        box(title = "Distribution of School Performance Grades Across the Region",
                            solidHeader = TRUE,
                            width = 12,
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
                            h5(p("You can use this data table to explore the school performance data on your own. The table allows for sorting and filtering the data by each column individually. Some things to note are provided below:")),
                            HTML('<p><ul><li>80% of the weight of a school\'s performance score is based on testing results (e.g., end-of-grade, end-of-course, graduation rate, and college/workplace readiness measures).</li><li>20% of the weight of the performaance is based on school growth as measured by SAS EVAAS (Education Value-Added Assessment System)</li><li>A performance grade of A+NG indicates a school earning an A designation with no significant achievement and/or graduation gaps.</li></ul></p>'),
                            HTML('<p><b style = "color: red;">Word of caution:</b> The way in which accountability measures are reported changed starting in the 2017-2018 academic year as a result of the <a href="https://www.ed.gov/essa?src=rn"><b>Every Student Succeeds Act (ESSA)</b></a>. Therefore, school performance grades, growth results, and graduation rates are not comparable across all years.</p>')
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
                           box(title = "Who is the Designer?", width = 6,status = "primary",solidHeader = TRUE,
                               div(img(src = "JennHeadshot_Small.jpeg", width = "60%"), style="text-align:center;"),
                               br(),
                               h5(p("Jennifer Houchins is a doctoral candidate in Learning Design and Technology at North Carolina State University. Her research examines students’ use of computational thinking and the effective use of instructional technology to deepen conceptual understanding in both formal and informal K-12 learning environments. She currently a graduate research assistant for the InfuseCS and the Programmed Robotics in the School Makerspace (PRISM) projects.")),
                               HTML('<br /><p>You can learn more about Jennifer and her work by <a href="http://jenniferkhouchins.com/">visiting her website.</a></p>')
                           ),
                           # project information
                        box(title = "About this Project", width = 6,status = "primary",solidHeader = TRUE,
                               h5(p("This Shiny app was developed for the final project assignment of ECI 586 (Intro to Learning Analytics). It is designed to follow the Data-Intensive Research Workflow (Krumm, Means, & Bienkowski, 2018). ")),
                            br(),
                            HTML('<p>If you would like to see the code for this project, you can download (or fork) it from the <a href="https://github.com/jennhouchins/ECI586-FinalProject">Github repository.</a> The project employs a multi-file Shiny app and includes an R script called wrangledata.R which was used to pre-process the data files and save the cleaned data to a single data file used by the app.</p>'),
                            br(),
                            h4(p("Limitations:")),
                            HTML('<p>Care has been taken to represent these data accurately while introducing as little designer bias as possible. Limited comparisons have been made due to the nature of the data and changes in the way measures are reported within the timeframe that these data span. Finally, some critics note that school report cards can have negative impacts. Please visit <a href="https://www.publicschoolsfirstnc.org/resources/fact-sheets/a-f-school-performance-grades/">Public Schools First NC</a> to see what critics have to say about school performance reporting.</p>'),
                            br(),
                            h4(p("References:")),
                           HTML('<p>Krumm, A., Means, B., & Bienkowski, M. (2018). <i>Learning analytics goes to school: A collaborative approach to improving education.</i> Routledge.</p>'),
                           HTML('<p>Antoszyk, E. (n.d.). School report cards. EducationNC. Retrieved November 22, 2020, from https://www.ednc.org/map/2015/06/school-report-cards/
</p>'),
                           HTML('<p>NC DPI: School Accountability and Reporting Page. (n.d.). Retrieved November 22, 2020, from https://www.dpi.nc.gov/districts-schools/testing-and-school-accountability/school-accountability-and-reporting/
</p>')
                           
                        )
                    )
            )
        )
    )
)