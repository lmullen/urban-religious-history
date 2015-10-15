library("humaniformat")
library("dplyr")
library("ggmap")

format_book <- function(row) {
  paste0(row$full_name, ", ", "<em>", row$title, "</em>", " (", row$city, ": ",
         row$publisher, ", ", row$year, ").")
}

bib <- read.csv("data/bibliography.csv", stringsAsFactors = FALSE)
names <- parse_names(bib$Author)
bib <- bind_cols(names, bib)
bib <- bib %>%
         select(-salutation, -Author) %>%
         rename(title = Title, city = City, state = State, publisher = Publisher,
                year = Year.Published) %>%
         mutate(location = as.character(paste0(city, ", ", state)),
                book = format_book(.))
loc <- geocode(bib$location, source = "google")
bib <- bind_cols(bib, loc)
saveRDS(bib, "data/bibliography.rds")
