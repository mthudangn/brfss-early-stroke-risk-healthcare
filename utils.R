required_columns <- function(data, columns, data_name = "data") {
  missing <- setdiff(columns, names(data))
  if (length(missing) > 0) {
    stop(
      sprintf(
        "%s is missing required columns: %s",
        data_name,
        paste(missing, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

ensure_directories <- function(paths) {
  for (path in paths) {
    if (!dir.exists(path)) {
      dir.create(path, recursive = TRUE, showWarnings = FALSE)
    }
  }
  invisible(TRUE)
}

stat_mode <- function(x) {
  non_missing <- x[!is.na(x)]
  if (length(non_missing) == 0) return(NA)
  unique_values <- unique(non_missing)
  unique_values[which.max(tabulate(match(non_missing, unique_values)))]
}

impute_with_training_summaries <- function(data, exclude = character()) {
  columns <- setdiff(names(data), exclude)
  for (column in columns) {
    x <- data[[column]]
    if (is.numeric(x)) {
      value <- mean(x, na.rm = TRUE)
      if (is.finite(value)) x[is.na(x)] <- value
    } else if (is.character(x) || is.factor(x)) {
      value <- stat_mode(x)
      if (!is.na(value)) x[is.na(x)] <- value
    }
    data[[column]] <- x
  }
  data
}
