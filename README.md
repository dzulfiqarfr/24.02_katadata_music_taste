# 24.02_katadata_music_taste

The code and data to produce [Katadata's "Selera Musik di Indonesia Cenderung Lagu Sedih" story](https://katadata.co.id/analisisdata/6287a5383c274/selera-musik-di-indonesia-cenderung-lagu-sedih).

> [!NOTE]
>
> The analysis has been updated for reproduction. Hence, the data in this repository are expected to be different from the ones that originally appear in the story.

## Getting started

### Spotify setup

The analysis uses data such as playlists and audio features from Spotify, which are available through its Application Programming Interface (API).

You need to set up a Spotify account and create an app for its Web API on the developer platform (see [Getting started with Web API](https://developer.spotify.com/documentation/web-api/tutorials/getting-started)). The app is necessary as you'll need its client ID and secret to get an access token to authorize your request.

The following sections describe the pipeline to produce the analysis.

> [!CAUTION]
>
> You may need to wait for several hours before running the script for requesting audio features after running scripts requesting playlists and tracks, given the rate limit (see [Rate Limits](https://developer.spotify.com/documentation/web-api/concepts/rate-limits)).

### Top Songs playlists

1.  Run `top_songs_playlists.R` in the `src` folder to get the catalog information of the Top Songs playlist for all available countries.
2.  Run `top_songs_tracks.R` in the `src` folder to get the information of each track in every Top Songs playlist.

### Major genres

1.  Run `major_genre_playlists.R` in the `src` folder to get the sample playlists of selected major genres.
2.  Run `major_genre_tracks.R` in the `src` folder to get the information of the tracks in every sample playlist.
