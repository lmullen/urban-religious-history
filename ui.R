library(shiny)
library(leaflet)

shinyUI(bootstrapPage(

  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  leafletOutput("map", width = "100%", height = "100%"),

  absolutePanel(
    id = "controls",
    bottom = 10, left = 10,
    tags$h2("A Bibliography of Urban Religious History"),
    sliderInput("year_published", "Year published",
                min = year_range[1], max = year_range[2],
                value = year_range, sep = "", round = TRUE, step = 1),
    tags$p(tags$a(href = "http://peputz.blogspot.com/", "Paul Putz"),
           " and ",
           tags$a(href = "http://lincolnmullen.com", "Lincoln Mullen"))
  )
  )
)
