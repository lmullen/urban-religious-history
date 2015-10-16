library("shiny")
library("shinythemes")
library("leaflet")
library("DT")

shinyUI(
  fluidPage(theme = shinytheme("cosmo"),
    tags$head(tags$link(rel = "stylesheet", type = "text/css",
                        href = "custom.css")),
    headerPanel("A Bibliography of Urban American Religious History"),
    sidebarLayout(
      sidebarPanel(
        includeHTML("authors.html"),
        sliderInput("year_published", "Year published",
                    min = year_range[1], max = year_range[2],
                    value = year_range, sep = "", round = TRUE, step = 1),
        selectInput("city_select", "City studied", cities),
        actionButton("reset_button", "All cities & years",
                     icon = icon("repeat"), class = "btn-warning btn-sm"),
        includeHTML("explanation.html"),
        width = 3
      ),
      mainPanel(
        leafletOutput("map", width = "100%", height = "400px"),
        tags$hr(),
        DT::dataTableOutput("bibtable")
      )
    )
  )
)
