# Methodology

## Objective

Build a transparent binary-classification workflow for exploratory stroke-risk modelling using accessible demographic, behavioural and physiological indicators.

## 1. Data preparation

- Standardise column names and categorical labels.
- Remove direct patient names.
- Restrict records to ages 18–45.
- Decode selected BRFSS 2020 variables using the LLCP codebook.
- Convert BMI to a common scale.
- Derive aligned smoking, alcohol, education, stress and general-health variables.
- Remove extreme BMI values using IQR-based bounds.
- Harmonise the two sources into a shared 27-column schema.
- Retain the diagnosis field as missing for records without a supervised label.

## 2. Exploratory analysis

The workflow examines:

- age distribution;
- work-type and smoking composition by stroke history;
- BMI and stress distributions by stroke history;
- glucose distributions stratified by sex;
- pairwise relationships between numeric predictors.

## 3. Statistical testing

A Welch two-sample t-test compares age across stroke-history groups. Statistical significance is interpreted together with effect magnitude because large samples can make small differences appear significant.

## 4. Predictive modelling

The labelled source is split into stratified training and test sets using an 80/20 ratio.

Models:

1. Full logistic regression using demographic, behavioural and clinical features.
2. Optimised logistic regression using age, BMI and average glucose level.
3. Random forest with 500 trees.
4. XGBoost with a binary logistic objective.

## 5. Evaluation

ROC-AUC is used as the primary comparison metric because the output is a continuous probability score. Confusion matrices and variable importance are supplementary diagnostics.

## 6. Scoring

The selected logistic model produces a continuous research score for unlabelled BRFSS records. The exported category is intentionally named `higher model score` or `lower model score`, rather than a medical diagnosis.
