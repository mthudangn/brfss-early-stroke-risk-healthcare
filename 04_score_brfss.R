source("requirements.R")
source("config/config.R")
source("R/utils.R")
source("R/scoring.R")

model_path <- file.path(PATHS$models, "logistic_optimised.rds")
if (!file.exists(PATHS$processed)) {
  stop("Processed data not found. Run scripts/01_prepare_data.R first.", call. = FALSE)
}
if (!file.exists(model_path)) {
  stop("Selected model not found. Run scripts/03_train_models.R first.", call. = FALSE)
}

stroke <- readr::read_csv(PATHS$processed, show_col_types = FALSE)
model <- readRDS(model_path)
scored <- score_unlabelled_records(
  stroke = stroke,
  model = model,
  output_path = PATHS$scored,
  threshold = MODEL_CONFIG$classification_threshold
)

message(sprintf("Scored %s records and wrote %s.", nrow(scored), PATHS$scored))
