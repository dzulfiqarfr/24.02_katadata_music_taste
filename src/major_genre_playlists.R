# Get sample playlists of selected major genres

here::i_am("src/major_genre_playlists.R")

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr")
library(spotifyr)

# Data --------------------------------------------------------------------

major_genres <- c(
  "Electronic", 
  "Hip hop", 
  "Jazz", 
  "Pop", 
  "Punk",
  "Reggae",
  "Rock",
  "Metal", 
  "R&B", 
  "Dangdut"
)

major_genre_search_result <- map(
  set_names(major_genres, major_genres), # Name it to create `genre` column
  \(x) search_spotify(
    x,
    type = "playlist",
    market = "ID",
    limit = 50
  ),
  .progress = TRUE
)

# Wrangling ---------------------------------------------------------------

# Add the genre to facilitate analysis by genre
major_genre_playlists <- major_genre_search_result |>
  bind_rows(.id = "genre") |>
  distinct(id, .keep_all = TRUE) |> # Drop duplicated playlists
  select(
    playlist_id = id,
    playlist_name = name,
    genre,
    playlist_description = description,
    n_track = tracks.total
  )

# Export ------------------------------------------------------------------

write_csv(major_genre_playlists, here("results", "major_genre_playlists.csv"))
