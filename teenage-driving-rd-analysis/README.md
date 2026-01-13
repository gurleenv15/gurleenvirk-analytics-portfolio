# Teenage Driving and Mortality: Regression Discontinuity Analysis

## Problem
Motor vehicle accidents are the leading cause of death among adolescents.
This project estimates the causal effect of driving eligibility on teen mortality.

## Data
- National Vital Statistics mortality records (1983–2014)
- Unit of analysis: age-in-month bins relative to minimum legal driving age
- Outcome: deaths per 100,000 person-years

## Methodology
- Regression Discontinuity (RD) design at the minimum legal driving age cutoff
- Donut RD excluding partially treated month
- Non-parametric RD (difference in means)
- Parametric RD with linear age trends
- Multiple bandwidths (48, 24, 12, 6 months)

## Key Results
- Mortality increases sharply at driving eligibility
- Motor vehicle accidents explain the majority of the effect
- Results are robust across model specifications

## Business & Policy Insight
Causal evidence suggests that early driving eligibility significantly increases mortality risk.
Targeted safety policies during the first months of licensure could prevent meaningful loss of life.

## Repo Guide
- `code/` – Reproducible R scripts
- `results/` – Executive findings
- `outputs/` – Tables and figures
- `docs/` – Case description and summary
