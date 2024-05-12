# Get the danceability and valence of tracks in sample major genre playlists

suppressMessages(here::i_am("src/major_genre_audio_features.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr", quiet = TRUE)
library(spotifyr)

# Helper ------------------------------------------------------------------

source(here("src", "helper", "group_tracks.R"))

# Data --------------------------------------------------------------------

major_genre_tracks <- read_csv(
  here("results", "major_genre_tracks.csv"),
  col_types = list(
    track_id = col_character(),
    playlist_id = col_character(),
    timestamp_addition = col_datetime()
  )
)

# Concat 100 track IDs into a comma-separated string to keep requests low
grouped_major_genre_tracks <- group_tracks(major_genre_tracks)

# Get the audio features of each track
major_genre_audio_features <- map(
  grouped_major_genre_tracks,
  get_track_audio_features,
  .progress = TRUE
)

# Wrangling ---------------------------------------------------------------

major_genre_audio_features_clean <- major_genre_audio_features |> 
  bind_rows() |> 
  select(
    track_id = id,
    duration = duration_ms,
    speechiness,
    valence
  ) |>
  right_join(
    major_genre_tracks,
    by = join_by(track_id),
    relationship = "many-to-many"
  ) |> 
  group_by(genre, playlist_id) |> 
  distinct(track_id, .keep_all = TRUE) |> 
  ungroup() |>
  relocate(duration, speechiness, valence, .after = last_col()) |> 
  arrange(genre, playlist_id)

# Export ------------------------------------------------------------------

write_csv(
  major_genre_audio_features_clean,
  here("results", "major_genre_audio_features.csv")
)
