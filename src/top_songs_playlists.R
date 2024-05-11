# Get Spotify's Top Songs playlists for all available countries

here::i_am("src/top_songs_playlists.R")

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr")
library(countries)
library(spotifyr)

# Data --------------------------------------------------------------------

country_list <- list_countries()

# Search the Top Songs playlist for every country
top_songs_search_result <- map(
  country_list,
  \(x) search_spotify(
    str_c("top songs ", x),
    type = "playlist",
    market = "ID",
    limit = 50
  ),
  .progress = TRUE
)

# Wrangling ---------------------------------------------------------------

# Subset the official playlist for each country
top_songs_playlists <- top_songs_search_result |>
  bind_rows() |>
  distinct(id, .keep_all = TRUE) |> # Drop duplicated playlists
  filter(
    str_detect(name, "Top\\sSongs\\s-\\s"), # Choose weekly playlists
    owner.id == "spotify"
  ) |> 
  select(
    playlist_id = id,
    playlist_name = name,
    owner_id = owner.id,
    playlist_description = description,
    n_track = tracks.total
  )

# Export ------------------------------------------------------------------

write_csv(top_songs_playlists, here("results", "top_songs_playlists.csv"))
