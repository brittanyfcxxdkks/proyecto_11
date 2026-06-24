Primero se cargan las librerías Shiny y ggplot2 
Se hace la interfaz de la aplicación
Se crea un deslizador que permite seleccionar un rango de profundidades. Los valores mínimo y máximo se obtienen directamente de la variable depth del conjunto de datos.
Define el espacio donde se mostrará el gráfico.
Server ,contiene las instrucciones que ejecutan la lógica de la aplicación
datos_filtrados , crea un conjunto de datos reactivo que filtra los terremotos según el rango de profundidad seleccionado en el deslizador. Cada vez que el usuario mueve el deslizador, los datos se actualizan 
output$grafico , genera el gráfico que se mostrará en la aplicación
luego se construye un gráfico de dispersión donde la profundidad se ubica en el eje X y la magnitud en el eje Y
geom_point , dibuja los puntos correspondientes a cada terremoto
geom_smooth, agrega una línea de regresión lineal para visualizar la tendencia entre las variables
Se añade el título del gráfico y las etiquetas de los ejes
aplica un diseño sencillo y limpio al gráfico
shinyApp(ui, server), inicia la aplicación Shiny conectando la interfaz de usuario con el servidor.







Código pregunta 3:

Este código utiliza la librería ggplot2 para generar un gráfico de dispersión a partir del conjunto de datos quakes. La función ggplot(quakes, aes(x = long, y = lat)) establece que la longitud (long) se representará en el eje horizontal y la latitud (lat) en el eje vertical. Posteriormente, geom_point(color = "orange", alpha = 0.7) dibuja un punto por cada terremoto registrado, asignándole un color naranja y un nivel de transparencia que facilita la visualización cuando varios puntos se encuentran cercanos entre sí. La función labs() agrega un título descriptivo y etiquetas a los ejes, mientras que theme_minimal() aplica un diseño simple que mejora la claridad del gráfico. Se eligió un gráfico de dispersión porque permite visualizar la ubicación geográfica de cada terremoto mediante sus coordenadas de latitud y longitud, lo que facilita identificar patrones espaciales, zonas de concentración de actividad sísmica y la distribución general de los eventos registrados en la base de datos.

Código pregunta 1:

Primero se cargan las librerías Shiny y ggplot2. En la interfaz de usuario (ui), se configura un diseño de panel lateral (sidebarLayout); el panel lateral muestra un texto informativo y el principal (mainPanel) reserva el espacio para dos gráficos mediante plotOutput(), separados por una línea horizontal (hr()). Por su parte, el servidor server maneja la lógica de la aplicación. Aunque la plantilla inicial procesa por error el conjunto de datos faithful, la lógica real se define abajo con ggplot2 sobre la base de datos quakes. El primer gráfico utiliza geom_histogram(binwidth = 0.2) para mostrar la frecuencia de las magnitudes en un histograma azul oscuro, mientras que el segundo emplea geom_boxplot() para generar un diagrama de caja vertical verde claro que resalta los valores atípicos en rojo. En ambos gráficos, labs() añade los títulos y theme_minimal() define el diseño estético, usando además theme() en el boxplot para ocultar el eje X. Finalmente, shinyApp(ui, server) enlaza ambos componentes para iniciar la aplicación.
