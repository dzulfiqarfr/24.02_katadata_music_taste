# Compute the mean valence of each Top Songs playlist

suppressMessages(here::i_am("src/top_songs_mean_valence.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)

# Data --------------------------------------------------------------------

top_songs_audio_featrues <- read_csv(
  here("results", "top_songs_audio_features.csv"),
  col_types = list(
    track_id = col_character(),
    timestamp_addition = col_datetime()
  )
)

# Analysis ----------------------------------------------------------------

top_songs_mean_valence <-summarize(
  top_songs_audio_featrues,
  valence_mean = mean(valence, na.rm = TRUE),
  .by = playlist_name
)

# Export ------------------------------------------------------------------

write_csv(top_songs_mean_valence, here("results", "top_songs_mean_valence.csv"))