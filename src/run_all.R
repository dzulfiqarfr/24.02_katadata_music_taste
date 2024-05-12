here::i_am("src/run_all.R")

# Helper ------------------------------------------------------------------

run <- function(file_name, message) {
  base::stopifnot(base::is.character(file_name))
  
  base::source(here::here("src", file_name))
}

# Data --------------------------------------------------------------------

# Silence tidyverse's startup message to reduce clutter in the console
options(tidyverse.quiet = TRUE)

run("top_songs_playlists.R")

run("top_songs_tracks.R")

run("top_songs_audio_features.R")

run("major_genre_playlists.R")

run("major_genre_tracks.R")

run("major_genre_audio_features.R")

# Analysis ----------------------------------------------------------------

run("top_songs_mean_valence.R")

run("top_songs_audio_feature_distribution.R")

run("major_genre_mean_valence.R")
