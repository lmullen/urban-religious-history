bib <- readRDS("data/bibliography.rds")
year_range <- range(bib$year)
cities <- sort(unique(paste(bib$city, bib$state, sep = ", ")))
cities <- c("All cities", cities)
