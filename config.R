PROJECT_ROOT <- normalizePath(".", mustWork = FALSE)

PATHS <- list(
  raw_stroke = file.path(PROJECT_ROOT, "data", "raw", "stroke_prediction_dataset.csv"),
  raw_brfss = file.path(PROJECT_ROOT, "data", "raw", "brfss2020.csv"),
  processed = file.path(PROJECT_ROOT, "data", "processed", "stroke.csv"),
  scored = file.path(PROJECT_ROOT, "data", "processed", "brfss_scored.csv"),
  figures = file.path(PROJECT_ROOT, "figures"),
  models = file.path(PROJECT_ROOT, "models"),
  results = file.path(PROJECT_ROOT, "results")
)

MODEL_CONFIG <- list(
  seed = 123,
  train_fraction = 0.80,
  random_forest_trees = 500,
  random_forest_mtry = 4,
  xgboost_rounds = 50,
  classification_threshold = 0.50
)
