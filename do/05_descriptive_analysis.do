
* 05_descriptive_analysis.do
* Purpose: Produce simple tables and figures

clear all
set more off
version 17

global ROOT "D:\Stata Projects\Project 2\household-income-expenditure-analysis"

capture log close
log using "$ROOT/logs/05_descriptive_analysis.log", text replace

use "$ROOT/data/clean/04_analysis_ready.dta", clear

* Overall descriptive statistics

summarize hh_income pc_income food_exp hh_size head_age ///
    employed_members food_income_ratio asset_count, detail

* Main categorical distributions
tabulate head_sex
tabulate income_source
tabulate region
tabulate head_job
tabulate income_quintile

* Table: household profile by income quintile

preserve

collapse ///
    (count) households=hh_id ///
    (median) median_hh_income=hh_income ///
             median_pc_income=pc_income ///
    (mean) mean_hh_size=hh_size ///
           mean_employed=employed_members ///
           mean_food_income_ratio=food_income_ratio ///
           electricity_rate=electricity_access ///
           mean_asset_count=asset_count, ///
    by(income_quintile)

export excel "$ROOT/output/tables/income_quintile_profile.xlsx", ///
    firstrow(variables) replace

export delimited "$ROOT/output/tables/income_quintile_profile.csv", replace

restore


* Figure 1: Distribution of log household income

histogram ln_income, percent normal ///
    title("Distribution of Log Household Income") ///
    xtitle("Log household income") ///
    ytitle("Percent")



* Figure 2: Median per-capita income by quintile

graph bar (median) pc_income, ///
    over(income_quintile) ///
    title("Per-Capita Income by Income Quintile") ///
    ytitle("Median per-capita income")




* Figure 3: Asset ownership by income quintile

graph bar (mean) own_refrigerator own_computer own_car own_cellphone, ///
    over(income_quintile) ///
    title("Selected Asset Ownership by Income Quintile") ///
    ytitle("Share of households") ///
    legend(order(1 "Refrigerator" 2 "Computer" 3 "Car" 4 "Cellphone"))


log close
