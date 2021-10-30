# Load libraries if not installed
# (Code by @dataprofessor (https://github.com/dataprofessor)
# in https://github.com/dataprofessor/iris-r-heroku/blob/master/init.R.
# Code edited)
my_packages = c("shiny", "plotly")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))

# Load libraries
library(shiny)
library(plotly)

# Load functions
source('./R/michaelis_functions.R')

# User Interface

ui <- fluidPage(
  titlePanel('Michaelis-Menten Steady-State Kinetics'),
  sidebarLayout(
    sidebarPanel(
      textInput('substrate', 'Substrate concentration (comma delimited and ordered)', value = c('1,3,5,8,10,15')),
      numericInput('vmax', 'Max velocity', value = 0.9),
      numericInput('km', 'Michaelis constant', value = 3.42),
      radioButtons(
        'viz',
        label = 'Visualization',
        choices = list('Hyperbole' = FALSE, 'Line' = TRUE),
        selected = FALSE
      )
    ),
    mainPanel(
      h3('Plot'),
      plotlyOutput('enzymePlot')
    )
  )
)

# Server

server <- function(input, output){
  
  x <- reactive({
    if(input$viz == FALSE){
      as.numeric(unlist(strsplit(input$substrate,",")))
    } else {
      as.numeric(unlist(strsplit(input$substrate,",")))^-1
    }
  })
  
  xPrint <- reactive({
    as.numeric(unlist(strsplit(input$substrate,",")))
  })

  
  y <- reactive({
    michaelis.eq(
      substrate = xPrint(),
      Vmax = input$vmax,
      Km = input$km,
      linear = input$viz
    )
  })
  
  output$enzymePlot <- renderPlotly(
    plot1 <- plot_ly(
      x = x(),
      y = y(),
      color = I('red'),
      type = 'scatter',
      mode = 'lines+markers'
    ) %>%
      layout(
        xaxis = list(title = 'Substrate concentration ([S])'),
        yaxis = list(title = 'Rate of the reaction (V)')
      )
  )

}

shinyApp(ui = ui, server = server)