model_formula_full <- function() {
  diagnosis ~ age + bmi + average_glucose_level + stress_level +
    sex_birth + hypertension + heart_disease + marital_status +
    work_type + residence_type + smoking_status + alcohol_intake +
    physical_activity + family_history_of_stroke + dietary_habits +
    diabetes + education + general_health
}

train_and_compare_models <- function(stroke, config, models_dir, results_dir, figures_dir) {
  ensure_directories(c(models_dir, results_dir, figures_dir))

  labelled <- stroke |>
    dplyr::filter(source == "kaggle", !is.na(diagnosis)) |>
    dplyr::mutate(diagnosis = factor(diagnosis, levels = c("no stroke", "stroke")))

  if (nrow(labelled) < 100) {
    stop("Insufficient labelled records for model training.", call. = FALSE)
  }

  set.seed(config$seed)
  train_index <- caret::createDataPartition(
    labelled$diagnosis,
    p = config$train_fraction,
    list = FALSE
  )
  train <- labelled[train_index, , drop = FALSE]
  test <- labelled[-train_index, , drop = FALSE]

  logistic_full <- stats::glm(
    model_formula_full(),
    data = train,
    family = "binomial"
  )
  logistic_small <- stats::glm(
    diagnosis ~ age + bmi + average_glucose_level,
    data = train,
    family = "binomial"
  )

  random_forest <- randomForest::randomForest(
    model_formula_full(),
    data = train,
    ntree = config$random_forest_trees,
    mtry = config$random_forest_mtry,
    importance = TRUE
  )

  xgb_predictors <- labelled |>
    dplyr::select(
      age, bmi, average_glucose_level, stress_level, sex_birth, hypertension,
      heart_disease, marital_status, work_type, residence_type, smoking_status,
      alcohol_intake, physical_activity, family_history_of_stroke, dietary_habits,
      diabetes, education, general_health
    )
  xgb_matrix <- stats::model.matrix(~ . - 1, data = xgb_predictors)
  xgb_label <- ifelse(labelled$diagnosis == "stroke", 1, 0)
  xgb_train <- xgboost::xgb.DMatrix(xgb_matrix[train_index, ], label = xgb_label[train_index])
  xgb_test <- xgboost::xgb.DMatrix(xgb_matrix[-train_index, ], label = xgb_label[-train_index])

  xgb_model <- xgboost::xgboost(
    data = xgb_train,
    nrounds = config$xgboost_rounds,
    objective = "binary:logistic",
    eval_metric = "auc",
    verbose = 0
  )

  probability_full <- stats::predict(logistic_full, newdata = test, type = "response")
  probability_small <- stats::predict(logistic_small, newdata = test, type = "response")
  probability_rf <- predict(random_forest, newdata = test, type = "prob")[, "stroke"]
  probability_xgb <- predict(xgb_model, xgb_test)

  roc_full <- pROC::roc(test$diagnosis, probability_full, quiet = TRUE)
  roc_small <- pROC::roc(test$diagnosis, probability_small, quiet = TRUE)
  roc_rf <- pROC::roc(test$diagnosis, probability_rf, quiet = TRUE)
  roc_xgb <- pROC::roc(xgb_label[-train_index], probability_xgb, quiet = TRUE)

  metrics <- tibble::tibble(
    model = c(
      "Full logistic regression",
      "Optimised logistic regression",
      "Random forest",
      "XGBoost"
    ),
    roc_auc = c(
      as.numeric(pROC::auc(roc_full)),
      as.numeric(pROC::auc(roc_small)),
      as.numeric(pROC::auc(roc_rf)),
      as.numeric(pROC::auc(roc_xgb))
    )
  ) |>
    dplyr::arrange(dplyr::desc(roc_auc))

  readr::write_csv(metrics, file.path(results_dir, "model_metrics_latest.csv"))
  saveRDS(logistic_full, file.path(models_dir, "logistic_full.rds"))
  saveRDS(logistic_small, file.path(models_dir, "logistic_optimised.rds"))
  saveRDS(random_forest, file.path(models_dir, "random_forest.rds"))
  xgboost::xgb.save(xgb_model, file.path(models_dir, "xgboost.model"))

  grDevices::png(file.path(figures_dir, "roc_comparison.png"), width = 1200, height = 900, res = 150)
  plot(roc_full, main = "ROC curve comparison")
  lines(roc_small)
  lines(roc_rf)
  lines(roc_xgb)
  legend(
    "bottomright",
    legend = c("Full logistic", "Optimised logistic", "Random forest", "XGBoost"),
    lwd = 2
  )
  grDevices::dev.off()

  list(
    metrics = metrics,
    selected_model = logistic_small,
    train = train,
    test = test
  )
}
