score_unlabelled_records <- function(stroke, model, output_path, threshold = 0.50) {
  predictors <- c("age", "bmi", "average_glucose_level")
  required_columns(stroke, c(predictors, "source"), "processed dataset")

  scoring_data <- stroke |>
    dplyr::filter(source == "brfss") |>
    dplyr::filter(dplyr::if_all(dplyr::all_of(predictors), ~ !is.na(.)))

  risk_probability <- stats::predict(model, newdata = scoring_data, type = "response")

  scored <- scoring_data |>
    dplyr::mutate(
      risk_score = round(risk_probability, 4),
      predicted_class = factor(
        ifelse(risk_probability >= threshold, "higher model score", "lower model score"),
        levels = c("lower model score", "higher model score")
      )
    )

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(scored, output_path)
  scored
}
