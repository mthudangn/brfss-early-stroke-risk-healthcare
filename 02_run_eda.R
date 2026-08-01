source("requirements.R")
source("config/config.R")
source("R/utils.R")
source("R/eda.R")

if (!file.exists(PATHS$processed)) {
  stop("Processed data not found. Run scripts/01_prepare_data.R first.", call. = FALSE)
}

stroke <- readr::read_csv(PATHS$processed, show_col_types = FALSE)
run_eda(stroke, PATHS$figures)
message(sprintf("EDA figures written to %s.", PATHS$figures))
