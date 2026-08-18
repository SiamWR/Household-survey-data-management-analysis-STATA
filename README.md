# Household-survey-data-management-analysis-STATA
# Stata Household Income & Expenditure Project

A simple, recruiter-friendly Stata project that demonstrates practical **data cleaning, data processing, validation, descriptive analysis, and regression** using a household Family Income and Expenditure dataset.

## Dataset

- File: `Family Income and Expenditure.csv`
- Observations: 41,544 households
- Raw variables: 60
- Unit of analysis: household

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
stata-fies-simple-portfolio/
│
├── README.md
├── .gitignore
│
├── data/
│   ├── raw/
│   │   └── Family Income and Expenditure.csv
│   └── clean/
│
├── do/
│   ├── 00_master.do
│   ├── 01_setup_and_audit.do
│   ├── 02_clean_data.do
│   ├── 03_validate_data.do
│   ├── 04_create_variables.do
│   ├── 05_descriptive_analysis.do
│   └── 06_regression_analysis.do
│
├── logs/
├── output/
│   ├── tables/
│   └── figures/
│
└── documentation/
    ├── data_dictionary.md
    └── data_quality_notes.md
```

## How to run

1. Extract the project.
2. Open Stata.
3. Set Stata's working directory to the project folder:

```stata
cd "C:\path\to\stata-fies-simple-portfolio"
```

4. Run:

```stata
do "do/00_master.do"
```

All do-files use only one project global:

```stata
global ROOT "."
```

If you want to use a fixed absolute path, change that line to your project folder.

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

It identifies and documents:
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

## GitHub note

The `.gitignore` excludes the raw CSV and generated `.dta` files by default. Verify the dataset licence before publishing the microdata. You can still publish all Stata code, documentation, figures, and non-sensitive summary outputs.
