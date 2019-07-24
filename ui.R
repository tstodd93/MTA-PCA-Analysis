# UI for app
ui <- fluidPage(
  # titlePanel("NYCT Bus Data 2008-2018 - Principle Component Analysis "),
  shinythemes::themeSelector(),
      navbarPage(
        theme = "cerulean",
        "shinythemes",
    tabPanel("PCA App",
  sidebarLayout(
        sidebarPanel(
      dateRangeInput("dates", h3("Date range"), start = "2008-12-01", end = "2017-12-01", min = "2008-12-01",
                     max = "2017-12-01"),
      textOutput("date_range"),
      checkboxGroupInput("checkGroup", 
                         h3("NYCT Bus Variables"), 
                         choices = list("Mean Distance Between Failures - NYCT Bus" = 2, 
                                        "Total Paratransit Ridership - NYCT Bus" = 3, 
                                        "Customer Accident Injury Rate - NYCT Bus" = 4,
                                        "Total Ridership - NYCT Bus" = 5,
                                        "Collisions with Injury Rate - NYCT Bus" = 6,
                                        "% of Completed Trips - NYCT Bus" = 7,
                                        "Bus Passenger Wheelchair Lift Usage - NYCT Bus" = 8),
                         selected = 2:8),
    
    selectInput("pca_one", label = h3("Select PC for x-axis"), 
                choices = list("PC1" = 1, "PC2" = 2, "PC3" = 3, "PC4" = 4, "PC5" = 5, "PC6" = 6, "PC7" = 7), 
                selected = 1),
    
    selectInput("pca_two", label = h3("Select PC for y-axis"), 
                choices = list("PC1" = 1, "PC2" = 2, "PC3" = 3, "PC4" = 4, "PC5" = 5, "PC6" = 6, "PC7" = 7), 
                selected = 2),
    "Only select PCs that exist in the data table on the right"
    
    ),
  
  mainPanel(
    titlePanel("NYCT Bus Data 2008-2018 - Principle Component Analysis "),
        DT::dataTableOutput("mytable"),
    tabsetPanel(
      tabPanel("Total Ridership", plotOutput("explore_chart")),
      tabPanel("Pareto Chart", plotOutput("pca_pareto")),
      tabPanel("Bi Plot", plotOutput("plot_pca"))
  )
)
)),

tabPanel("About/Tutorial", 
         sidebarLayout(
           sidebarPanel(
             
           ),
           mainPanel(
             strong("Dataset"),
             p("This site uses a data set from the New York State Transit Authority and comes from the MTA’s Performance Dashboard and is used to increase transparency at the MTA. The Key Performance Indicators (KPI) are used to track performance is areas such as On Time Performance. This set includes data from 2008 to 2018 for all the MTA run agencies. For the purposes of this study, only the MTA’s data on their buses was investigated to limit the scope of this shiny app."),
             p("Source: https://www.kaggle.com/new-york-state/nys-metropolitan-transport-authority-mta-data"),
             strong("Motivation"),
             p("Transit and transportation has always been of interest to me. This is partially because issues with the MBTA in Boston is almost a daily problem for me and the thousands of other T riders in Boston. However, less data is available in the public domain for Boston’s transport authority than for New York City. While the two cities and their public transportation are vastly different, many of the conclusions that can be drawn from NYC’s data is also pertinent to Boston."),
             p("Buses throughout the United States are often described in poor terms in relation to their cleanliness, speed, and reliability. The data science problem that can be presented is based on the initial exploration of the dataset – over any selected data range, the total monthly membership has been trending downwards from 2008 to 2018."),
             strong("Analysis/Tutorial"),
             p("some text here"),
             strong("Results"),
             p("some text here")
           )
         )
)
)
)

