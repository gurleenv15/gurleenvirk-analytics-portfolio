# Healthcare RCT Impact Study: Workplace Wellness Programs

## Problem
Employers frequently adopt workplace wellness programs based on claims of reduced healthcare spending.
However, many prior evaluations rely on observational comparisons that may suffer from selection bias.

## Data
- Illinois Workplace Wellness Study (UIUC)
- Sample: 4,834 employees
- Design: Randomized Controlled Trial
- Treatment: Eligibility for a two-year wellness program
- Outcomes: Healthcare spending (total, office, prescription, hospital)

## Methodology
- Randomization checks via pre-treatment balance tests
- Intent-to-Treat (ITT) estimation using linear regression
- Comparison of participants vs. non-participants to illustrate selection bias
- Models estimated with and without demographic controls

## Key Results
- No statistically significant reduction in healthcare spending from program eligibility in year one
- Large spending differences between participants and non-participants driven by selection bias
- Observational comparisons substantially overstate program effectiveness

## Business Insight
Randomized evaluation is essential when assessing wellness program ROI.
Participation-based analyses can be misleading and should not be used for investment decisions.

## Repo Guide
- `code/` – R scripts for reproducible causal analysis
- `results/` – Executive findings and conclusions
- `outputs/` – Tables generated from analysis
- `docs/` – Executive summary and case background
