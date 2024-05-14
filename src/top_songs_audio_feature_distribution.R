# Count the number of tracks by danceability and valence for Top Songs playlists

suppressMessages(here::i_am("src/top_songs_audio_feature_distribution.R"))

# Packages ----------------------------------------------------------------

library(conflicted)
library(here)
library(tidyverse)
conflict_prefer("filter", "dplyr", quiet = TRUE)

# Helper ------------------------------------------------------------------

count_tracks <- function(data, x, bin_width) {
  stopifnot(tibble::is_tibble(data), is.double(bin_width))
  
  if (!any("playlist_name" == names(data))) {
    stop("`data` must contain `playlist_name` column.", call. = FALSE)
  }
  
  data |> 
    dplyr::group_by(playlist_name) |> 
    dplyr::count(bins = ggplot2::cut_width({{ x }}, bin_width)) |> 
    dplyr::ungroup() |> 
    dplyr::mutate(
      bins_clean_punctuations = stringr::str_remove_all(
        bins,
        "(^\\[)|(^\\()|(\\]$)")
      ,
      valence_group = stringr::str_replace(bins_clean_punctuations, ",", " - ")
    ) |> 
    dplyr::select(
      playlist_name,
      valence_group,
      n_track = n
    )
}

# Data --------------------------------------------------------------------

top_songs_audio_featrues <- read_csv(
  here("results", "top_songs_audio_features.csv"),
  col_types = list(
    track_id = col_character(),
    timestamp_addition = col_datetime()
  )
)

# Wrangling ---------------------------------------------------------------

# Subset Indonesia, Malaysia, and Global playlists for a music taste comparison
top_songs_audio_features_subset <- filter(
  top_songs_audio_featrues,
  playlist_name %in% c(
    "Top Songs - Indonesia",
    "Top Songs - Malaysia",
    "Top Songs - Global"
  )
)

# Analysis ----------------------------------------------------------------

top_songs_valence_distribution <- count_tracks(
  top_songs_audio_features_subset,
  valence,
  0.1
)

top_songs_danceability_distribution <- count_tracks(
  top_songs_audio_features_subset,
  danceability,
  0.075
)

# Export ------------------------------------------------------------------

write_csv(
  top_songs_valence_distribution,
  here("results", "top_songs_valence_distribution.csv")
)

write_csv(
  top_songs_danceability_distribution,
  here("results", "top_songs_danceability_distribution.csv")
)