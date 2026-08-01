source("requirements.R")
source("config/config.R")
source("R/utils.R")
source("R/data_preparation.R")

required_files <- c(PATHS$raw_stroke, PATHS$raw_brfss)
missing_files <- required_files[!file.exists(required_files)]
if (length(missing_files) > 0) {
  stop(
    paste("Missing raw data files:", paste(missing_files, collapse = ", ")),
    call. = FALSE
  )
}

stroke <- build_harmonised_dataset(
  stroke_path = PATHS$raw_stroke,
  brfss_path = PATHS$raw_brfss,
  output_path = PATHS$processed
)

message(sprintf("Processed dataset written to %s (%s rows).", PATHS$processed, nrow(stroke)))
