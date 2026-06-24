#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)


ui <- fluidPage(
  
  
  titlePanel("Análisis de magnitud de Terremotos"),
  
  
  sidebarLayout(
    sidebarPanel(p("Visualización de los valores extremos (mínimo y máximo) en el conjunto de datos"),
                 mainPanel(
                   plotOutput("histogramaTerremotos"),
                   hr(),
                   plotOutput("boxplotTerremotos")
                 )
    )
  )
  
  # Define server logic required to draw a histogram
  server <- function(input, output) {
    
    output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white',
           xlab = 'Waiting time to next eruption (in mins)',
           main = 'Histogram of waiting times')
    })
  }
  
  # Run the application 
  shinyApp(ui = ui, server = server)
  


library(ggplot2)

ggplot(quakes, aes(x = mag)) +
  geom_histogram(binwidth = 0.2, fill = "darkblue", color = "black", alpha = 0.8) +
  labs(
    title = "Distribución de la Magnitud de los Terremotos",
    x = "Magnitud",
    y = "Frecuencia (Cantidad de Terremotos)"
  ) +
  theme_minimal()


ggplot(quakes, aes(y = mag)) +
  geom_boxplot(fill = "lightgreen", color = "darkgreen", outlier.color = "red", outlier.shape = 16) +
  labs(
    title = "Diagrama de Caja de la Magnitud de los Terremotos",
    y = "Magnitud"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

