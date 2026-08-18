* 01_setup_and_audit.do
* Purpose: Project setup and raw-data audit
clear all
set more off
version 17

*project root
global ROOT "D:\Stata Projects\Project 2\household-income-expenditure-analysis"

* reproducible log
capture log close
log using "$ROOT/logs/01_setup_and_audit.log", text replace

* Importing the raw CSV file
import delimited "$ROOT/data/raw/Family Income and Expenditure.csv", ///
    clear varnames(1) case(preserve)

display as text "Rows: " _N
display as text "Columns: " c(k)

* Checking the dataset
assert _N == 41544
assert c(k) == 60

describe
summarize
codebook

* Checking Variable level missingness and duplicates
misstable summarize
misstable patterns

duplicates report

* Frequency checking for the categorical variables
unab rawvars : _all

* Saving the untouched imported copy
save "$ROOT/data/clean/01_imported_raw.dta", replace

log close
