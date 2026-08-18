
* 04_create_variables.do
* Purpose: Create simple analysis-ready variables

clear all
set more off
version 17

global ROOT "D:\Stata Projects\Project 2\household-income-expenditure-analysis"

capture log close
log using "$ROOT/logs/04_create_variables.log", text replace

use "$ROOT/data/clean/03_validated.dta", clear

* Income measures

gen double pc_income = hh_income / hh_size
label variable pc_income "Per-capita household income"

gen double ln_income = ln(hh_income)
label variable ln_income "Natural log of household income"

* Per-capita income quintiles
xtile income_quintile = pc_income, nq(5)

label define income_q ///
    1 "Q1 - Lowest" ///
    2 "Q2" ///
    3 "Q3" ///
    4 "Q4" ///
    5 "Q5 - Highest"

label values income_quintile income_q
label variable income_quintile "Per-capita income quintile"


* Household composition

gen children_0_17 = members_u5 + members_5_17
label variable children_0_17 "Household members aged 0-17"

gen child_share = children_0_17 / hh_size ///
    if flag_children_gt_hh == 0
label variable child_share "Share of household members aged 0-17"

gen employment_ratio = employed_members / hh_size ///
    if flag_employed_gt_hh == 0
label variable employment_ratio "Employed members / household size"


* Expenditure measure

gen food_income_ratio = food_exp / hh_income
label variable food_income_ratio "Food expenditure / household income"


* Binary indicators

gen byte female_head = head_sex == "Female"
label variable female_head "Female-headed household"

gen byte head_has_job = head_job == "With Job/Business"
label variable head_has_job "Household head has job/business"

gen byte electricity_access = electricity == 1
label variable electricity_access "Household has electricity"


* Asset ownership

gen own_tv = n_tv > 0
gen own_refrigerator = n_refrigerator > 0
gen own_washing_machine = n_washing_machine > 0
gen own_aircon = n_aircon > 0
gen own_car = n_car > 0
gen own_cellphone = n_cellphone > 0
gen own_computer = n_computer > 0
gen own_motorcycle = n_motorcycle_tricycle > 0

egen asset_count = rowtotal( ///
    own_tv own_refrigerator own_washing_machine own_aircon ///
    own_car own_cellphone own_computer own_motorcycle)

label variable asset_count ///
    "Count of selected asset categories owned"

* Encode categories 

encode region, gen(region_id)
encode income_source, gen(income_source_id)
encode head_sex, gen(head_sex_id)

compress
save "$ROOT/data/clean/04_analysis_ready.dta", replace

display as text "Final analysis-ready observations: " _N
summarize hh_income pc_income food_income_ratio asset_count
tab income_quintile

log close
