library(shiny)
library(leaflet)
library(DT)

shinyUI(
  fluidPage(
    tags$head(tags$link(rel = "stylesheet", type = "text/css",
                        href = "custom.css")),
    titlePanel(our_title),
    sidebarLayout(
      sidebarPanel(
        sliderInput("year_published", "Year published",
                    min = year_range[1], max = year_range[2],
                    value = year_range, sep = "", round = TRUE, step = 1),
        selectInput("city_select", "City studied", cities),
        actionButton("reset_button", "Show all cities & years",
                     icon = icon("repeat")),
        tags$br(),
        includeHTML("explanation.html"),
        width = 3
      ),
      mainPanel(
        leafletOutput("map", width = "100%", height = "400px"),
        tags$hr(),
        dataTableOutput("bibtable")
      )
    )
  )
)
