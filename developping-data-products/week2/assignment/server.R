library(shiny)
library(leaflet)
library(dplyr)

stations_ratp <- read.csv(file = "data/positions-geographiques-des-stations-du-reseau-ratp.csv", sep = ";")
stations_ratp <- stations_ratp %>%
  mutate(stop_name = toupper(as.character(stop_name))) %>%
  mutate(stop_name = gsub("É", "E", stop_name)) %>%
  mutate(stop_name = gsub("È", "E", stop_name)) %>%
  group_by(stop_name) %>%
  summarise(stop_lat = mean(stop_lat), stop_lon = mean(stop_lon))

frequency_ratp <- read.csv(file = "data/trafic-annuel-entrant-par-station-du-reseau-ferre-2016.csv", sep = ";")
frequency_ratp <- frequency_ratp %>%
  mutate(stop_name = toupper(as.character(Station))) %>%
  mutate(stop_name = gsub("É", "E", stop_name)) %>%
  mutate(stop_name = gsub("È", "E", stop_name)) %>%
  group_by(stop_name) %>%
  summarise(Frequency = sum(Trafic))

df <- full_join(stations_ratp, frequency_ratp, by = "stop_name") %>%
  filter(!is.na(Frequency)) %>%
  filter(!is.na(stop_lon))

line7 <- df %>%
  filter(stop_name %in% c("PORTE D'ITALIE", "VILLEJUIF-LOUIS ARAGON", "VILLEJUIF-LEO LAGRANGE"))

server <- function(input, output, session) {

  output$mymap <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addCircles(lng = df$stop_lon, lat = df$stop_lat, popup = df$stop_name) %>%
      addPolylines(lng = line7$stop_lon, lat = line7$stop_lat, color = "purple", popup = "Line 7")
  })
}


