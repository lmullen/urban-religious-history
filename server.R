library(shiny)
library(leaflet)
suppressMessages(library(dplyr))

shinyServer(function(input, output) {

  bib_selected <- reactive({

    city_filter <- strsplit(input$city_select, ", ")[[1]]

    bib_s <- bib %>%
      filter(year >= input$year_published[1],
             year <= input$year_published[2])

    if (all(city_filter != "All cities")) {
      bib_s <- bib_s %>%
        filter(city == city_filter[1], state == city_filter[2])
    }

    bib_s

  })

  bib_for_table <- reactive({
    bib_selected() %>%
      arrange(state, city, year) %>%
      select(city, state, authors = full_name, title, publisher, year)
  })

  bib_for_map <- reactive({
    bib_selected() %>%
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

  output$bibtable <- renderDataTable({bib_for_table()}, server = FALSE)

  observe({
    leafletProxy("map", data = bib_for_map()) %>%
      clearMarkers() %>%
      addCircleMarkers(lng = ~lon, lat = ~lat, radius = ~sqrt(n) * 3,
                       popup = ~paste0("<h4>", location, "</h4>", "<p>", book,
                                       "</p>"))
  })

})
