library(shiny)
library(leaflet)
suppressMessages(library(dplyr))

shinyServer(function(input, output, session) {

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
    df <- bib_for_map()

    leafletProxy("map", data = df) %>%
      clearMarkers() %>%
      clearPopups()

    if (nrow(df) > 0) {
      leafletProxy("map", data = df) %>%
        addCircleMarkers(layerId = ~location, lng = ~lon, lat = ~lat,
                         radius = ~sqrt(n) * 3)
    }

    if (nrow(df) == 1) {
      leafletProxy("map", data = df) %>%
        addPopups(~lon, ~lat, ~location, layerId = ~location)
    }

  })

  # If a marker is clicked, return results for just that city
  observeEvent(input$map_marker_click, {
    event <- input$map_marker_click
    updateSelectInput(session, "city_select", selected = event$id)
  })

  # If the map background is clicked, show all cities
  observeEvent(input$map_click, {
    updateSelectInput(session, "city_select", selected = "All cities")
  })

  # If the reset button is clicked, show all cities and years
  observeEvent(input$reset_button, {
    updateSelectInput(session, "city_select", selected = "All cities")
    updateSliderInput(session, "year_published", value = year_range)
  })

})
