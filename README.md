# Early Stroke Risk Classification

An interpretable machine-learning pipeline in **R** for exploratory stroke-risk classification among adults aged **18–45** using harmonised public-health data.

The project combines demographic, behavioural and clinical indicators, performs structured preprocessing and exploratory analysis, and benchmarks multiple supervised classification models. It is designed as a transparent research prototype rather than a clinical diagnostic system.

## Project highlights

- Harmonises a structured stroke dataset with **BRFSS 2020** survey data.
- Removes direct identifiers before downstream processing.
- Decodes and aligns heterogeneous categorical variables.
- Engineers common health indicators across both data sources.
- Applies missing-value handling and BMI outlier filtering.
- Performs univariate, bivariate and multivariate exploratory analysis.
- Benchmarks logistic regression, random forest and XGBoost classifiers.
- Evaluates discrimination using ROC curves and AUC.
- Generates probability-based risk scores for records without diagnosis labels.

## Reference benchmark

| Model | ROC-AUC |
|---|---:|
| Full logistic regression | 0.5253 |
| Optimised logistic regression | **0.5378** |
| Random forest | 0.5041 |
| XGBoost | 0.5148 |

The reference results show that the available variables provide only limited out-of-sample discrimination. This is reported deliberately: the repository demonstrates a complete and reproducible modelling workflow without overstating clinical performance.

## Repository structure

```text
early-stroke-risk-ml/
├── R/
│   ├── data_preparation.R
│   ├── eda.R
│   ├── modeling.R
│   ├── scoring.R
│   └── utils.R
├── scripts/
│   ├── 01_prepare_data.R
│   ├── 02_run_eda.R
│   ├── 03_train_models.R
│   └── 04_score_brfss.R
├── config/config.R
├── data/
│   ├── README.md
│   └── sample/stroke_sample.csv
├── docs/
│   ├── DATA_CARD.md
│   ├── ETHICS.md
│   ├── METHODOLOGY.md
│   ├── MODEL_CARD.md
│   └── REPRODUCIBILITY.md
├── results/model_metrics.csv
├── requirements.R
├── run_pipeline.R
└── LICENSE
```

## Data

The full raw datasets are not committed to this repository.

Expected input files:

```text
data/raw/stroke_prediction_dataset.csv
data/raw/brfss2020.csv
```

The first dataset must contain the structured stroke variables used in the preprocessing pipeline. The BRFSS file must use the 2020 LLCP variable names documented in the official codebook.

A small de-identified sample is included only to show the processed schema. See [`data/README.md`](data/README.md) and [`docs/DATA_CARD.md`](docs/DATA_CARD.md).

## Quick start

### 1. Install R dependencies

```r
source("requirements.R")
```

### 2. Add the raw datasets

Place the required CSV files inside `data/raw/`.

### 3. Run the complete pipeline

```r
source("run_pipeline.R")
```

The pipeline writes processed data, figures, model artefacts and evaluation tables to their respective folders.

Individual stages can also be run separately:

```r
source("scripts/01_prepare_data.R")
source("scripts/02_run_eda.R")
source("scripts/03_train_models.R")
source("scripts/04_score_brfss.R")
```

## Method summary

1. Restrict analysis to adults aged 18–45.
2. Remove direct identifiers and standardise field names.
3. Decode BRFSS categorical values and derive aligned features.
4. Harmonise both sources into a common schema.
5. Impute missing predictors using training-data summaries.
6. Explore distributions and associations with stroke history.
7. Create a stratified 80/20 train–test split.
8. Compare logistic regression, random forest and XGBoost using ROC-AUC.
9. Use the selected model to generate probability-based research scores.

Full details are available in [`METHODOLOGY.md`](METHODOLOGY.md).

## Limitations

- The reported AUC values are close to random discrimination.
- Labels and feature definitions differ between the source datasets.
- Some harmonised variables are proxies rather than clinically measured equivalents.
- BRFSS responses are self-reported and may contain recall or reporting bias.
- External clinical validation has not been performed.
- Generated scores must not be interpreted as diagnoses or treatment recommendations.

## Responsible use

This repository is intended for data-science research, portfolio demonstration and methodological exploration only. It is **not a medical device** and must not be used for clinical decision-making.

## Author

**Minnie Dang**

## License

The source code is released under the [MIT License](LICENSE). Dataset licensing and access conditions remain with the original data providers and are not covered by this repository's software license.
