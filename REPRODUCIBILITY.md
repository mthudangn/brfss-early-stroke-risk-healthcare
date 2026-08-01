# Reproducibility

## Environment

- R 4.3 or later is recommended.
- Package installation is handled by `requirements.R`.
- Random operations use seed `123` by default.

## Inputs

Place raw inputs in `data/raw/` using the filenames documented in `data/README.md`.

## Execution

Run from the repository root:

```r
source("run_pipeline.R")
```

## Outputs

- processed datasets: `data/processed/`;
- figures: `figures/`;
- model artefacts: `models/`;
- current evaluation metrics: `results/model_metrics_latest.csv`.

## Reference results

`results/model_metrics.csv` records the benchmark reported from the original complete run. A new run may differ because of package versions, source-data revisions or preprocessing changes.

## Validation status

The scripts were reorganised and syntax-reviewed as part of repository preparation. They were not runtime-tested in the packaging environment because R was unavailable there.
