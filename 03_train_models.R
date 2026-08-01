source("requirements.R")
source("config/config.R")
source("R/utils.R")
source("R/modeling.R")

if (!file.exists(PATHS$processed)) {
  stop("Processed data not found. Run scripts/01_prepare_data.R first.", call. = FALSE)
}

stroke <- readr::read_csv(PATHS$processed, show_col_types = FALSE)
training_result <- train_and_compare_models(
  stroke = stroke,
  config = MODEL_CONFIG,
  models_dir = PATHS$models,
  results_dir = PATHS$results,
  figures_dir = PATHS$figures
)

print(training_result$metrics)
message("Model artefacts and evaluation results have been written successfully.")
