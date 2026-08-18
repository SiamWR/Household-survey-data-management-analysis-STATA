# Household-survey-data-management-analysis-STATA
A reproducible Stata data cleaning, processing, validation, and socioeconomic analysis project using household-level Family Income and Expenditure data.

## Project Overview
The project demonstrates a practical workflow for converting raw survey data into a clean, validated, and analysis-ready dataset while documenting important data-quality decisions. Household survey datasets often contain inconsistent categories, missing information, unusual values, and variables that require transformation before statistical analysis.
## Dataset

- File: `Family Income and Expenditure.csv`
- Observations: 41,544 households
- Raw variables: 60
- Unit of analysis: household
- Source: https://www.kaggle.com/datasets/grosvenpaul/family-income-and-expenditure

## What this project demonstrates

- Importing CSV data into Stata
- `describe`, `codebook`, `summarize`, and `misstable`
- Duplicate and missing-value checks
- Clear variable renaming
- String/category standardization
- Logical consistency checks
- Data-quality flags rather than automatic deletion
- Construction of per-capita income and household indicators
- Income quintiles with `xtile`
- Basic asset-ownership indicators
- Descriptive tables and figures
- Excel and CSV export
- OLS regression with robust standard errors
- Reproducible `.do` files and logs

## Folder structure

```text
household-income-expenditure-analysis/
│
├── README.md
│
├── data/
│   ├── raw/
│   │   └── Family Income and Expenditure.csv
│   └── clean/
│
├── do/
│   ├── 01_setup_and_audit.do
│   ├── 02_clean_data.do
│   ├── 03_validate_data.do
│   ├── 04_create_variables.do
│   ├── 05_descriptive_analysis.do
│   └── 06_regression_analysis.do
│
├── logs/
├── output/
   ├── tables/
   └── figures/

```

## Workflow

```text
Raw CSV
   ↓
Setup & audit
   ↓
Clean variables/categories
   ↓
Validate and flag problems
   ↓
Create analysis variables
   ↓
Descriptive analysis
   ↓
Regression analysis
```

## Important data-quality decisions

The project does not automatically delete unusual records.

It identifies:
- structural missing occupation/class-of-worker values for heads with no job/business;
- households where child counts exceed household size;
- households where employed-member counts exceed household size;
- very young household heads;
- missing toilet-facility information;
- obvious spelling/capitalization inconsistencies in categorical fields.

The principle is:

**Flag → inspect → document → decide**

## Regression interpretation

The final OLS model uses log household income and robust standard errors.

The available Kaggle extract does not contain identifiable survey weights, strata, or PSU variables. Therefore the regression should be described as **unweighted conditional associations in the available dataset**, not as causal effects or survey-weighted national estimates.


