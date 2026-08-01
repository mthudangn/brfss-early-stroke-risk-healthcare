packages <- c(
  "tidyverse",
  "janitor",
  "skimr",
  "GGally",
  "forcats",
  "scales",
  "randomForest",
  "caret",
  "pROC",
  "ggdist",
  "knitr",
  "xgboost"
)

missing_packages <- packages[!packages %in% rownames(installed.packages())]
if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

invisible(lapply(packages, library, character.only = TRUE))
