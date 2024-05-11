# Get the tracks of sample major genre playlists

here::i_am("src/major_genre_tracks.R")

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr")
library(spotifyr)

# Data --------------------------------------------------------------------

major_genre_playlists <- read_csv(
  here("results", "major_genre_playlists.csv"),
  col_types = list(playlist_id = col_character())
)

# Pull playlist IDs to get their tracks
major_genre_playlist_id <- pull(major_genre_playlists, playlist_id)

# Get the tracks of each playlist
major_genre_tracks <- map(
  set_names(major_genre_playlist_id, major_genre_playlist_id),
  get_playlist_tracks,
  .progress = TRUE
)

# Wrangling ---------------------------------------------------------------

major_genre_tracks_clean <- major_genre_tracks |> 
  bind_rows(.id = "playlist_id") |> 
  as_tibble() |> 
  select(
    track_id = track.id,
    track_name = track.name,
    playlist_id,
    timestamp_addition = added_at
  ) |> 
  left_join(major_genre_playlists) |> 
  select(!c(playlist_name, playlist_description, n_track)) |> 
  relocate(genre, .before = timestamp_addition)

# Export ------------------------------------------------------------------

write_csv(major_genre_tracks_clean, here("results", "major_genre_tracks.csv"))
