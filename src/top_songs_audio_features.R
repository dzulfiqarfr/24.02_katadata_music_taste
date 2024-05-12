# Get the danceability and valence of tracks in Spotify's Top Songs playlists

suppressMessages(here::i_am("src/top_songs_audio_features.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr", quiet = TRUE)
library(spotifyr)

# Helper ------------------------------------------------------------------

source(here("src", "helper", "group_tracks.R"))

# Data --------------------------------------------------------------------

top_songs_tracks <- read_csv(
  here("results", "top_songs_tracks.csv"),
  col_types = list(
    track_id = col_character(),
    timestamp_addition = col_datetime()
  )
)

# Concat 100 track IDs into a comma-separated string to keep requests low
grouped_top_songs_tracks <- group_tracks(top_songs_tracks)

# Get the audio features of each track
top_songs_audio_features <- map(
  grouped_top_songs_tracks,
  get_track_audio_features,
  .progress = TRUE
)

# Wrangling ---------------------------------------------------------------

# Get the danceability and valence of each track
top_songs_danceability_valence <- top_songs_audio_features |> 
  bind_rows() |> 
  select(
    track_id = id,
    danceability,
    valence
  ) |> 
  right_join(top_songs_tracks, by = join_by(track_id)) |> 
  relocate(danceability, valence, .after = last_col()) |> 
  arrange(playlist_name)

# Export ------------------------------------------------------------------

write_csv(
  top_songs_danceability_valence,
  here("results", "top_songs_audio_features.csv")
)
