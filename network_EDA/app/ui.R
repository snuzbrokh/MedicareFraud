#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")

bootstrapPage(
  navbarPage(collapsible=TRUE, "Medical Fraud", id="nav",
             tabPanel("Affiliation Network",
                      div(
                        tags$style(type = "text/css", "#plot {height: calc(100vh - 80px) !important;}"),
                        absolutePanel(id = "controls", class = "panel panel-default",
                                      top = 120, left = 40, width = "auto", fixed=TRUE,
                                      draggable = TRUE, height = "auto",
                                      
                                      style = "font-size: 16px !important;",
                                      
                                      pickerInput("network_type_select", h4("Select Network:"),   
                                                  choices = c("Provider-Doctor","Provider-Patient","Patient-Doctor"), 
                                                  selected = "Provider-Patient",
                                                  options = list(`actions-box` = TRUE,
                                                                 inline = TRUE),
                                                  multiple = FALSE),
                                      pickerInput("state_select", h4("State:"),   
                                                  choices = states, 
                                                  selected = "New Jersey",
                                                  options = list(`actions-box` = TRUE,
                                                                 inline = TRUE),
                                                  multiple = FALSE),
                                      pickerInput("county_select", h4("County:"),   
                                                  choices = NULL, 
                                                  selected = '100',
                                                  options = list(`actions-box` = TRUE,
                                                                 inline = TRUE),
                                                  multiple = TRUE),
                                      pickerInput("status_select", h4("In/Outpatient:"),   
                                                  choices = c('in','out'), 
                                                  selected = c('in','out'),
                                                  options = list(`actions-box` = TRUE,
                                                                 inline = TRUE),
                                                  multiple = TRUE),
                                      pickerInput("layout_select", h4("Graph Layout:"),
                                                choices = c('sugiyama','stress','kk','drl'), 
                                                selected = "stress",
                                                options = list(`actions-box` = TRUE,
                                                                inline = TRUE),
                                                multiple = FALSE),
                                      h3("Legend"),
                                      img(src = "patient.jpeg", height = 15, width = 15),
                                      img(src = "doctor.png", height = 25, width = 23),
                                      img(src = "test.jpg", height = 20, width = 20),
                                      img(src = "nofraud.jpeg", height = 15, width = 15),
                                      img(src = "fraud.png", height = 25, width = 25)
                        ),
                        plotOutput("plot", width="100%", height = "100%")
                      )
                      
             ),
             tabPanel("Bipartite Projection",
                      fluidRow(
                        column(6,
                               plotOutput("actor1_plot")
                               ),
                        column(6,
                               plotOutput("actor2_plot")
                               )
                      )
             )
             # tabPanel("Provider Duplication Network",
             #          fluidRow(
             #            column(3,
             #                  pickerInput("pdup_layout_select", h4("Graph Layout:"),
             #                              choices = c('stress','kk'), 
             #                              selected = "stress",
             #                              options = list(`actions-box` = TRUE,
             #                                             inline = TRUE),
             #                              multiple = FALSE)
             #            ),
             #            column(9,
             #                   plotOutput("pduplicates_plot"),
             #                   DT::dataTableOutput("table")
             #            )
             #          )
             # ),
             # tabPanel("Doctor Duplication Network",
             #          fluidRow(
             #            column(3,
             #                   pickerInput("ddup_layout_select", h4("Graph Layout:"),
             #                               choices = c('stress','kk'),
             #                               selected = "stress",
             #                               options = list(`actions-box` = TRUE,
             #                                              inline = TRUE),
             #                               multiple = FALSE)
             #            ),
             #            column(9,
             #                   plotOutput("dduplicates_plot"),
             #                   #DT::dataTableOutput("table")
             #            )
             #          )
             # )
  ) # end of navbar page
) # end of bootstrap page
