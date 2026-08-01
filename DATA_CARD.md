# Data card

## Scope

The project harmonises two public-health data sources for exploratory stroke-risk modelling among adults aged 18–45.

## Sources

### Structured stroke dataset

Contains demographic, behavioural and physiological variables together with a binary diagnosis label. Direct patient names are removed during preprocessing.

### BRFSS 2020

A large self-reported public-health survey. Encoded survey variables are decoded and mapped to the common project schema using the accompanying LLCP 2020 codebook.

## Processed schema

The current processed artefact contains 27 fields, including:

- age and birth sex;
- hypertension and heart-disease history;
- BMI and average glucose level;
- smoking and alcohol categories;
- physical activity and stress level;
- stroke history and diagnosis;
- education, general health and source identifier.

## Harmonisation

Variable names, categorical labels and units are aligned before row-binding. Fields unavailable in one source may be imputed or represented through explicitly documented proxy rules.

## Known limitations

- Source populations and label definitions are not equivalent.
- BRFSS relies on self-reported responses.
- Some categories are simplified during harmonisation.
- Several cross-source variables are proxies, not clinical equivalents.
- Missing-value imputation reduces missingness but can attenuate variance.
- A small de-identified sample is included only to demonstrate schema.
