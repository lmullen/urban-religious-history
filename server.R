library(shiny)
library(leaflet)
suppressMessages(library(dplyr))

shinyServer(function(input, output) {

  bib_selected <- reactive({
    bib %>%
      filter(year >= input$year_published[1],
             year <= input$year_published[2]) %>%
      group_by(location) %>%
      arrange(last_name) %>%
      summarise(n = n(),
                book = paste(book, collapse = "</p><p>"),
                lon = lon[1],
                lat = lat[1])
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lat = 37.45, lng = -93.85, zoom = 4)
  })

  observe({
    df <- bib_selected()
    leafletProxy("map", data = df) %>%
      clearMarkers() %>%
      addCircleMarkers(lng = ~lon, lat = ~lat, radius = ~n * 5,
                       popup = ~paste0("<h4>", location, "</h4>", "<p>", book,
                                       "</p>"))
  })

})
