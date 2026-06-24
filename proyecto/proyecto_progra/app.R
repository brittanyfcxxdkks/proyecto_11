#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  titlePanel("Distribución geográfica de los terremotos"),
  
  sidebarLayout(
    sidebarPanel(),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    
    ggplot(quakes, aes(x = long, y = lat)) +
      geom_point(color = "orange", alpha = 0.7) +
      labs(
        title = "Distribución geográfica de los terremotos según latitud y longitud",
        x = "Longitud",
        y = "Latitud"
      ) +
      theme_minimal()
    
  })
  
}

shinyApp(ui = ui, server = server)
