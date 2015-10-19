library("humaniformat")
library("dplyr")
library("ggmap")

bib <- read.csv("data/Urban Religious Histories - Sheet1.csv",
                stringsAsFactors = FALSE)
names <- parse_names(bib$Author)
bib <- bind_cols(names, bib)
bib <- bib %>%
         select(-salutation, -Author) %>%
         rename(title = Title, city = City, state = State, publisher = Publisher,
                year = Year.Published) %>%
         mutate(location = as.character(paste0(city, ", ", state)))
loc <- geocode(bib$location, source = "google")
bib <- bind_cols(bib, loc)
saveRDS(bib, "data/bibliography.rds")
