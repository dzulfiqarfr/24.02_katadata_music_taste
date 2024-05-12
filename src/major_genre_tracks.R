# Get the tracks of sample major genre playlists

suppressMessages(here::i_am("src/major_genre_tracks.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr", quiet = TRUE)
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

# Drop duplicated tracks within a playlist
major_genre_tracks_clean <- major_genre_tracks |> 
  bind_rows(.id = "playlist_id") |> 
  as_tibble() |> 
  select(
    track_id = track.id,
    track_name = track.name,
    playlist_id,
    date_album_release = track.album.release_date,
    timestamp_addition = added_at
  ) |> 
  left_join(major_genre_playlists, by = join_by(playlist_id)) |> 
  group_by(genre, playlist_id) |> 
  distinct(track_id, .keep_all = TRUE) |> 
  ungroup() |> 
  select(!c(playlist_name, playlist_description, n_track)) |> 
  relocate(genre, .before = date_album_release)

# Export ------------------------------------------------------------------

write_csv(major_genre_tracks_clean, here("results", "major_genre_tracks.csv"))
