# Compute the mean valence of each major genre

suppressMessages(here::i_am("src/major_genre_mean_valence.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr", quiet = TRUE)

# Data --------------------------------------------------------------------

major_genre_audio_features <- read_csv(
  here("results", "major_genre_audio_features.csv"),
  col_types = list(
    track_id = col_character(),
    playlist_id = col_character(),
    timestamp_addition = col_datetime()
  )
)

# Wrangling ---------------------------------------------------------------

# Drop outlier tracks to reduce biases
major_genre_audio_features_clean <- major_genre_audio_features |>
  filter(
    duration <= 600000, # Tracks that are longer 10 minutes
    speechiness <= 0.66, # Tracks that are likely to be speech, mostly
    !is.na(valence)
  ) |>
  group_by(genre) |>
  distinct(track_id, .keep_all = TRUE) |> # Drop duplicated tracks within genres
  ungroup() |> 
  mutate(
    year_album_release = as.integer(str_sub(date_track_release, end = 4L))
  ) |> 
  filter(year_album_release >= 1940) |> # Tracks with wrong release year
  relocate(year_album_release, .before = date_track_release)

# Analysis ----------------------------------------------------------------

major_genre_mean_valence_overall <- summarize(
  major_genre_audio_features_clean,
  valence_mean = mean(valence, na.rm = TRUE),
  .by = genre
)

major_genre_mean_valence_annual <- summarize(
  major_genre_audio_features_clean,
  valence_mean = mean(valence, na.rm = TRUE),
  .by = c(genre, year_album_release)
)

# Export ------------------------------------------------------------------

write_csv(
  major_genre_mean_valence_overall,
  here("results", "major_genre_mean_valence_overall.csv")
)

write_csv(
  major_genre_mean_valence_annual,
  here("results", "major_genre_mean_valence_annual.csv")
)
