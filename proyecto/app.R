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
library(dplyr)
library(DT)

ui <- fluidPage(
  titlePanel("Análisis de Terremotos"),
  
  tabsetPanel(
    # Pregunta 1
    tabPanel("Pregunta 1",
             sidebarLayout(
               sidebarPanel(
                 helpText("Visualización de la magnitud de los terremotos: histograma y boxplot")
               ),
               mainPanel(
                 plotOutput("histogramaTerremotos"),
                 hr(),
                 plotOutput("boxplotTerremotos")
               )
             )
    ),
    
    # Pregunta 2
    tabPanel("Pregunta 2",
             sidebarLayout(
               sidebarPanel(
                 helpText("Distribución de terremotos según rango de magnitud")
               ),
               mainPanel(
                 plotOutput("grafico_p2"),
                 DTOutput("tabla_p2")
               )
             )
    ),
    
    # Pregunta 3
    tabPanel("Pregunta 3",
             sidebarLayout(
               sidebarPanel(
                 helpText("Distribución geográfica de los terremotos")
               ),
               mainPanel(
                 plotOutput("grafico_p3")
               )
             )
    ),
    
    # Pregunta 4
    tabPanel("Pregunta 4",
             sidebarLayout(
               sidebarPanel(
                 sliderInput(
                   "intervalo",
                   "Ancho de agrupación de la magnitud:",
                   min = 0.1,
                   max = 1,
                   value = 0.5,
                   step = 0.1
                 )
               ),
               mainPanel(
                 plotOutput("grafico_p4")
               )
             )
    ),
    
    # Pregunta 5
    tabPanel("Pregunta 5",
             sidebarLayout(
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
                 plotOutput("grafico_p5")
               )
             )
    )
  )
)

server <- function(input, output) {
  
  # --- Pregunta 1 ---
  output$histogramaTerremotos <- renderPlot({
    ggplot(quakes, aes(x = mag)) +
      geom_histogram(binwidth = 0.2, fill = "darkblue", color = "black", alpha = 0.8) +
      labs(
        title = "Distribución de la Magnitud de los Terremotos",
        x = "Magnitud",
        y = "Frecuencia (Cantidad de Terremotos)"
      ) +
      theme_minimal()
  })
  
  output$boxplotTerremotos <- renderPlot({
    ggplot(quakes, aes(y = mag)) +
      geom_boxplot(fill = "lightgreen", color = "darkgreen",
                   outlier.color = "red", outlier.shape = 16) +
      labs(
        title = "Diagrama de Caja de la Magnitud de los Terremotos",
        y = "Magnitud"
      ) +
      theme_minimal() +
      theme(axis.text.x = element_blank(),
            axis.ticks.x = element_blank())
  })
  
  # --- Pregunta 2 ---
  datos_p2 <- reactive({
    quakes %>%
      mutate(rango_magnitud = cut(
        mag,
        breaks = c(4, 5, 6, 7),
        labels = c("4-5", "5-6", "6-7"),
        include.lowest = TRUE
      )) %>%
      count(rango_magnitud) %>%
      mutate(porcentaje = round(n / sum(n) * 100, 2))
  })
  
  output$grafico_p2 <- renderPlot({
    ggplot(datos_p2(), aes(x = rango_magnitud, y = n, fill = rango_magnitud)) +
      geom_bar(stat = "identity") +
      labs(
        title = "Cantidad de terremotos por rango de magnitud",
        x = "Rango de magnitud",
        y = "Frecuencia"
      ) +
      theme_minimal()
  })
  
  output$tabla_p2 <- renderDT({
    datatable(datos_p2(),
              options = list(pageLength = 5),
              rownames = FALSE)
  })
  
  # --- Pregunta 3 ---
  output$grafico_p3 <- renderPlot({
    ggplot(quakes, aes(x = long, y = lat)) +
      geom_point(color = "orange", alpha = 0.7) +
      labs(
        title = "Distribución geográfica de los terremotos según latitud y longitud",
        x = "Longitud",
        y = "Latitud"
      ) +
      theme_minimal()
  })
  
  # --- Pregunta 4 ---
  output$grafico_p4 <- renderPlot({
    datos_grafico <- quakes %>%
      mutate(
        magnitud_grupo = round(mag / input$intervalo) * input$intervalo
      ) %>%
      group_by(magnitud_grupo) %>%
      summarise(promedio_estaciones = mean(stations, na.rm = TRUE))
    
    ggplot(datos_grafico,
           aes(x = magnitud_grupo, y = promedio_estaciones)) +
      geom_line() +
      geom_point() +
      labs(
        title = "Cantidad de estaciones según la magnitud",
        x = "Magnitud del terremoto",
        y = "Promedio de estaciones que lo registraron"
      ) +
      theme_minimal()
  })
  
  # --- Pregunta 5 ---
  datos_filtrados <- reactive({
    subset(quakes,
           depth >= input$depth[1] &
             depth <= input$depth[2])
  })
  
  output$grafico_p5 <- renderPlot({
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

