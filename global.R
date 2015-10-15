bib <- readRDS("data/bibliography.rds")
year_range <- range(bib$year)
our_title <- "A Bibliography of Urban Religious History"
cities <- sort(unique(paste(bib$city, bib$state, sep = ", ")))
cities <- c("All cities", cities)
