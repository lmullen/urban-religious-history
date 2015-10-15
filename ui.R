library(shiny)
library(leaflet)

shinyUI(bootstrapPage(

  tags$head(
    tags$title(our_title),
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  leafletOutput("map", width = "100%", height = "100%"),

  absolutePanel(
    id = "controls",
    bottom = 10, left = 10,
    tags$h2(our_title),
    sliderInput("year_published", "Year published",
                min = year_range[1], max = year_range[2],
                value = year_range, sep = "", round = TRUE, step = 1),
    tags$p(tags$a(href = "http://peputz.blogspot.com/", "Paul Putz"),
           " and ",
           tags$a(href = "http://lincolnmullen.com", "Lincoln Mullen"))
  )
  )
)
