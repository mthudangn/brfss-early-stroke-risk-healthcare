# Model card

## Model purpose

Exploratory classification and portfolio demonstration of a public-health machine-learning workflow.

## Intended users

Data scientists, analysts and researchers studying reproducible health-data pipelines.

## Out-of-scope uses

- clinical diagnosis;
- emergency triage;
- treatment selection;
- insurance or employment decisions;
- automated decisions affecting an individual.

## Training population

Labelled records from the structured stroke dataset, restricted to adults aged 18–45.

## Inputs

The selected reference model uses:

- age;
- BMI;
- average glucose level.

The benchmark also evaluates models using a broader set of demographic, behavioural and clinical variables.

## Output

A probability-like model score and an optional thresholded research category.

## Reference performance

| Model | ROC-AUC |
|---|---:|
| Full logistic regression | 0.5253 |
| Optimised logistic regression | 0.5378 |
| Random forest | 0.5041 |
| XGBoost | 0.5148 |

## Interpretation

Performance is close to chance. The models should therefore be treated as methodological prototypes, not reliable clinical predictors.

## Risks

- dataset shift between the labelled source and BRFSS;
- proxy-variable error introduced during harmonisation;
- reporting and selection bias;
- subgroup performance differences;
- misleading certainty from probability-like outputs.

## Required safeguards

- clearly communicate uncertainty;
- retain human review;
- evaluate subgroup performance before any extension;
- validate on independent clinical data;
- never expose scores as diagnoses.
