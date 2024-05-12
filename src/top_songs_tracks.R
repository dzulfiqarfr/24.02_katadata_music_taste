# Get the tracks in Spotify's Top Songs playlists

suppressMessages(here::i_am("src/top_songs_tracks.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr", quiet = TRUE)
library(spotifyr)

# Data --------------------------------------------------------------------

top_songs_playlists <- read_csv(
  here("results", "top_songs_playlists.csv"),
  col_type = list(
    playlist_id = col_character(),
    owner_id = col_character()
  )
)

# Put playlist IDs into a named character vector to get their tracks
top_songs_playlist_id <- top_songs_playlists |> 
  select(playlist_name, playlist_id) |> 
  deframe()

# Get the tracks of each playlist
top_songs_tracks <- map(
  top_songs_playlist_id,
  get_playlist_tracks,
  .progress = TRUE
)

# Wrangling ---------------------------------------------------------------

# Add the playlist name to facilitate analysis by country
top_songs_tracks_clean <- top_songs_tracks |> 
  bind_rows(.id = "playlist_name") |> 
  as_tibble() |> 
  select(
    track_id = track.id,
    track_name = track.name,
    playlist_name,
    timestamp_addition = added_at
  )

# Export ------------------------------------------------------------------

write_csv(top_songs_tracks_clean, here("results", "top_songs_tracks.csv"))
