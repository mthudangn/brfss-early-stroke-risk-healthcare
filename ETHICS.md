# Ethics and responsible use

Health-related machine-learning projects require stronger safeguards than ordinary predictive analytics.

## Privacy

Direct names are removed at the beginning of the preprocessing pipeline. Raw datasets containing direct identifiers must not be committed to version control.

## Fairness

Variables such as sex, sexual orientation, residence and socioeconomic proxies can reflect structural inequities. Their inclusion can improve descriptive completeness while also creating discrimination risk. Subgroup analysis is required before any operational use.

## Label limitations

Self-reported stroke history and dataset-specific diagnosis labels do not necessarily measure the same concept. Harmonisation does not eliminate this difference.

## Communication

Outputs must be described as model scores, not medical diagnoses. Low benchmark AUC values must remain visible in documentation.

## Clinical safety

This project has no external clinical validation and is not suitable for patient-level decision-making. Any future clinical extension would require domain review, prospective validation, calibration analysis and regulatory assessment.
