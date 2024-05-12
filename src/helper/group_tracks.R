# Put tracks into groups of 100
group_tracks <- function(data) {
  stopifnot(tibble::is_tibble(data))
  
  if (!any("track_id" == names(data))) {
    stop("`data` must contain `track_id` column.", call. = FALSE)
  }
  
  data |>
    dplyr::distinct(track_id) |> 
    dplyr::mutate( # Use row number to group tracks
      row_number = dplyr::row_number(),
      group = dplyr::case_when(
        row_number %in% seq(1, length(unique(track_id)), 99) ~ row_number
      )
    ) |> 
    tidyr::fill(group) |> 
    split(~ group) |>
    purrr::map(\(x) dplyr::pull(x, track_id)) |>
    purrr::map(\(x) stringr::str_flatten(x, collapse = ","))
}