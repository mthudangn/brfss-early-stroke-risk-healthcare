prepare_stroke_source <- function(path) {
  stroke_source <- readr::read_csv(path, show_col_types = FALSE) |>
    janitor::clean_names()

  required_columns(
    stroke_source,
    c(
      "patient_id", "patient_name", "age", "gender", "hypertension",
      "heart_disease", "marital_status", "work_type", "residence_type",
      "average_glucose_level", "body_mass_index_bmi", "smoking_status",
      "alcohol_intake", "physical_activity", "stroke_history",
      "family_history_of_stroke", "dietary_habits", "stress_levels",
      "diagnosis"
    ),
    "stroke prediction dataset"
  )

  stroke_source |>
    dplyr::select(-patient_name) |>
    dplyr::rename(
      sex_birth = gender,
      bmi = body_mass_index_bmi,
      stress_level = stress_levels
    ) |>
    dplyr::mutate(
      dplyr::across(tidyselect::where(is.character), stringr::str_to_lower),
      marital_status = dplyr::if_else(
        marital_status == "divorced",
        "divorced/separated",
        marital_status
      ),
      diabetes = dplyr::case_when(
        average_glucose_level >= 126 ~ "yes",
        average_glucose_level >= 100 ~ "borderline",
        average_glucose_level < 100 ~ "no",
        TRUE ~ NA_character_
      ),
      year = 2023,
      sex_orient = NA_character_,
      education = dplyr::case_when(
        age <= 22 & work_type %in% c("children", "never worked") ~ "early childhood",
        age <= 30 & work_type == "never worked" ~ "high school",
        age >= 23 & age <= 45 & work_type %in% c("private", "self-employed") ~ "college (1–3 yrs)",
        age > 45 & work_type %in% c("private", "govt job") ~ "college grad (4+ yrs)",
        age >= 60 ~ "college grad (4+ yrs)",
        TRUE ~ "high school grad"
      ),
      general_health = dplyr::case_when(
        stress_level <= 4 ~ "excellent",
        stress_level <= 6 ~ "good",
        stress_level <= 8 ~ "fair",
        stress_level > 8 ~ "poor",
        TRUE ~ NA_character_
      )
    ) |>
    dplyr::filter(dplyr::between(age, 18, 45))
}

prepare_brfss_source <- function(path, common_columns) {
  brfss <- readr::read_csv(path, show_col_types = FALSE, name_repair = "minimal") |>
    janitor::clean_names() |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), stringr::str_to_lower))

  required_columns(
    brfss,
    c(
      "iyear", "age80", "hlthpln1", "medcost", "income2", "cvdstrk3",
      "bmi5", "alcday5", "educa", "diabete4", "smoker3", "sex",
      "diffwalk", "physhlth", "marital", "menthlth", "employ1",
      "urbstat", "exerany2", "cvdcrhd4", "genhlth"
    ),
    "BRFSS dataset"
  )

  if (!"somale" %in% names(brfss)) brfss$somale <- NA_real_
  if (!"sofemale" %in% names(brfss)) brfss$sofemale <- NA_real_

  brfss <- brfss |>
    dplyr::rename(
      year = iyear,
      age = age80,
      healthcare_coverage = hlthpln1,
      medcost_nodoc = medcost,
      income = income2
    ) |>
    dplyr::mutate(
      stroke_history = dplyr::case_when(
        cvdstrk3 == 1 ~ 1,
        cvdstrk3 == 2 ~ 0,
        TRUE ~ NA_real_
      ),
      bmi = bmi5 / 100,
      alcohol_days = dplyr::case_when(
        dplyr::between(alcday5, 201, 230) ~ alcday5 - 200,
        dplyr::between(alcday5, 101, 107) ~ (alcday5 - 100) * 4.345,
        alcday5 == 888 ~ 0,
        TRUE ~ NA_real_
      ),
      alcohol_intake = dplyr::case_when(
        alcohol_days == 0 ~ "never",
        dplyr::between(alcohol_days, 1, 4) ~ "rarely",
        dplyr::between(alcohol_days, 5, 15) ~ "social drinker",
        alcohol_days >= 16 ~ "frequent drinker",
        TRUE ~ NA_character_
      ),
      education = dplyr::case_when(
        educa == 1 ~ "early childhood",
        educa == 2 ~ "elementary",
        educa == 3 ~ "high school",
        educa == 4 ~ "high school grad",
        educa == 5 ~ "college (1–3 yrs)",
        educa == 6 ~ "college grad (4+ yrs)",
        TRUE ~ NA_character_
      ),
      diabetes = dplyr::case_when(
        diabete4 %in% c(1, 2) ~ "yes",
        diabete4 == 3 ~ "no",
        diabete4 == 4 ~ "borderline",
        TRUE ~ NA_character_
      ),
      smoking_status = dplyr::case_when(
        smoker3 %in% c(1, 2) ~ "currently smokes",
        smoker3 == 3 ~ "formerly smoked",
        smoker3 == 4 ~ "non-smoker",
        TRUE ~ NA_character_
      ),
      sex_orient_code = dplyr::coalesce(somale, sofemale),
      sex_orient = dplyr::case_when(
        sex_orient_code == 1 ~ "gay/lesbian",
        sex_orient_code == 2 ~ "straight",
        sex_orient_code == 3 ~ "bisexual",
        sex_orient_code == 4 ~ "other",
        TRUE ~ NA_character_
      ),
      sex_birth = dplyr::case_when(
        sex == 1 ~ "male",
        sex == 2 ~ "female",
        TRUE ~ NA_character_
      ),
      symptoms = dplyr::case_when(
        diffwalk == 1 ~ "difficulty walking or climbing",
        dplyr::between(physhlth, 7, 30) ~ "bad physical health",
        TRUE ~ NA_character_
      ),
      marital_status = dplyr::case_when(
        marital == 1 ~ "married",
        marital %in% c(2, 4) ~ "divorced/separated",
        marital == 3 ~ "widowed",
        marital %in% c(5, 6) ~ "single",
        TRUE ~ NA_character_
      ),
      stress_level = dplyr::if_else(
        is.na(menthlth),
        NA_real_,
        round((menthlth / 30) * 10, 2)
      ),
      work_type = dplyr::case_when(
        employ1 == 1 ~ "private",
        employ1 == 2 ~ "self-employed",
        employ1 %in% c(3, 4, 5, 6, 7, 8) ~ "never worked",
        TRUE ~ NA_character_
      ),
      residence_type = dplyr::case_when(
        urbstat == 1 ~ "urban",
        urbstat == 2 ~ "rural",
        TRUE ~ NA_character_
      ),
      physical_activity = dplyr::case_when(
        exerany2 == 1 & bmi < 23 & age < 40 ~ "high",
        exerany2 == 1 ~ "moderate",
        TRUE ~ "low"
      ),
      heart_disease = dplyr::case_when(
        cvdcrhd4 == 1 ~ 1,
        cvdcrhd4 == 2 ~ 0,
        TRUE ~ NA_real_
      ),
      general_health = dplyr::case_when(
        genhlth %in% c(1, 2) ~ "excellent",
        genhlth == 3 ~ "good",
        genhlth == 4 ~ "fair",
        genhlth == 5 ~ "poor",
        TRUE ~ NA_character_
      )
    )

  bmi_quartiles <- stats::quantile(brfss$bmi, c(0.25, 0.75), na.rm = TRUE)
  bmi_iqr <- diff(bmi_quartiles)
  lower_bound <- bmi_quartiles[[1]] - 1.5 * bmi_iqr
  upper_bound <- bmi_quartiles[[2]] + 1.5 * bmi_iqr + 10

  brfss |>
    dplyr::select(dplyr::any_of(common_columns)) |>
    dplyr::filter(dplyr::between(age, 18, 45)) |>
    dplyr::filter(bmi >= lower_bound, bmi <= upper_bound) |>
    dplyr::mutate(patient_id = dplyr::row_number() + 99999)
}

build_harmonised_dataset <- function(stroke_path, brfss_path, output_path) {
  stroke_source <- prepare_stroke_source(stroke_path)
  common_columns <- names(stroke_source)
  brfss_source <- prepare_brfss_source(brfss_path, common_columns)

  combined <- dplyr::bind_rows(
    stroke_source |> dplyr::mutate(source = "kaggle"),
    brfss_source |> dplyr::mutate(source = "brfss")
  ) |>
    dplyr::mutate(
      average_glucose_level = dplyr::if_else(
        is.na(average_glucose_level) & source == "brfss",
        mean(stroke_source$average_glucose_level, na.rm = TRUE),
        average_glucose_level
      ),
      dplyr::across(
        dplyr::any_of(c("stroke_history", "hypertension", "heart_disease")),
        as.factor
      )
    ) |>
    impute_with_training_summaries(exclude = "diagnosis")

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(combined, output_path)
  combined
}
