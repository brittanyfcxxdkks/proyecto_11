#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

head(quakes)
library(ggplot2)

ui <- fluidPage(
  
  titlePanel("Pregunta 5"),
  
  sidebarPanel(
    sliderInput(
      "depth",
      "Rango de profundidad (km):",
      min = min(quakes$depth),
      max = max(quakes$depth),
      value = range(quakes$depth)
    )
  ),
  
  mainPanel(
    plotOutput("grafico")
  )
)

server <- function(input, output) {
  
  datos_filtrados <- reactive({
    subset(
      quakes,
      depth >= input$depth[1] &
        depth <= input$depth[2]
    )
  })
  
  output$grafico <- renderPlot({
    
    ggplot(datos_filtrados(),
           aes(x = depth, y = mag)) +
      geom_point(alpha = 0.6) +
      geom_smooth(method = "lm", se = FALSE) +
      labs(
        title = "Relación entre profundidad y magnitud de los terremotos",
        x = "Profundidad (km)",
        y = "Magnitud (Escala Richter)"
      ) +
      theme_minimal()
  })
  
}

shinyApp(ui, server)
#Se observa una relación negativa débil entre la profundidad y la magnitud. La gran dispersión de los puntos indica que no existe una correlación lineal entre ambas variables.


