library(shiny)

shinyUI(fluidPage(
        titlePanel("Giving History"),
        sidebarLayout(
                sidebarPanel(
                        fileInput('file1', 'Choose CSV File',
                                  accept=c('text/csv', 
                                           'text/comma-separated-values,text/plain', 
                                           '.csv')),
                        tags$hr(),
                        checkboxInput('header', 'Header', TRUE),
                        radioButtons('sep', 'Separator',
                                     c(Comma=',',
                                       Semicolon=';',
                                       Tab='\t'),
                                     ','),
                        radioButtons('quote', 'Quote',
                                     c(None='',
                                       'Double Quote'='"',
                                       'Single Quote'="'"),
                                     '"'),
                        downloadButton('downloadData', 'Download')
                ),
        mainPanel(
                tabsetPanel(type = "tabs", 
                            tabPanel("Giving Summary", tableOutput("contents")), 
                            tabPanel("About", includeMarkdown("about.Rmd")) 
                           
        )
        ))
)
)