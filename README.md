# 24.02_katadata_music_taste

The code and data to produce Katadata's "[Selera Musik di Indonesia Cenderung Lagu Sedih](https://katadata.co.id/analisisdata/6287a5383c274/selera-musik-di-indonesia-cenderung-lagu-sedih)" story.

> [!NOTE]
>
> The analysis has been updated for reproduction. Hence, the data in this repository are expected to be different from the ones that originally appear in the story.

## Getting started

You need [R](https://cran.r-project.org/) (and [RStudio](https://posit.co/products/open-source/rstudio/)) to produce the analysis. It uses the [renv package](https://rstudio.github.io/renv/index.html) to manage dependencies and ensures reproducibility.

### Spotify setup

The analysis uses data such as playlists and audio features from [Spotify](https://open.spotify.com/), which are available through its Application Programming Interface (API).

You need to set up a Spotify account and create an app for its Web API on the developer platform (see [Getting started with Web API](https://developer.spotify.com/documentation/web-api/tutorials/getting-started)). The app is necessary as you'll need its client ID and secret to get an access token to authorize your request.

## Example

You can produce the analysis by running `run_all.R` in the `src` folder. This is the controller script that runs other scripts to perform every step of the analysis from start to finish.

> [!CAUTION]
>
> You may hit the API's rate limit when running the scripts (multiple times within a short period) (see [Rate Limits](https://developer.spotify.com/documentation/web-api/concepts/rate-limits)). In such cases, you have to wait for several hours before you can successfully make a request again.

You can run the script in your RStudio interactively or using the console like so.

``` r
source("src/run_all.R")
```
