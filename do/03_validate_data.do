
* 03_validate_data.do
* Purpose: Check data quality and create audit flags
clear all
set more off
version 17

global ROOT "D:\Stata Projects\Project 2\household-income-expenditure-analysis"

capture log close
log using "$ROOT/logs/03_validate_data.log", text replace

use "$ROOT/data/clean/02_cleaned.dta", clear

* ---------------------------------------------------- *
* Basic checks
* ---------------------------------------------------- *
isid hh_id

assert hh_income > 0
assert hh_size >= 1
assert inlist(electricity, 0, 1)

* Missing values
misstable summarize

tabulate head_job, missing
tabulate head_occupation, missing
tabulate head_worker_class, missing
tabulate toilet_facility, missing

* Structural missingness
* In this dataset, occupation and class of worker are missing
* when the household head reports no job/business.

gen byte flag_occ_missing = missing(head_occupation)
gen byte flag_workerclass_missing = missing(head_worker_class)

tab head_job if flag_occ_missing == 1, missing
tab head_job if flag_workerclass_missing == 1, missing


* Logical consistency checks

gen byte flag_children_gt_hh = ///
    members_u5 + members_5_17 > hh_size

gen byte flag_employed_gt_hh = ///
    employed_members > hh_size

gen byte flag_young_head = ///
    head_age < 15

gen byte flag_toilet_missing = ///
    missing(toilet_facility)

tab flag_children_gt_hh
tab flag_employed_gt_hh
tab flag_young_head
tab flag_toilet_missing

* Inspect flagged records rather than deleting them

list hh_id hh_size members_u5 members_5_17 ///
    if flag_children_gt_hh == 1, noobs

list hh_id hh_size employed_members ///
    if flag_employed_gt_hh == 1, noobs

list hh_id head_age hh_size ///
    if flag_young_head == 1, noobs

* Keep all records; flags remain available for analysis decisions
save "$ROOT/data/clean/03_validated.dta", replace

display as result "Validation complete. Suspicious records were flagged, not deleted."

log close
