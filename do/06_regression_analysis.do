
* 06_regression_analysis.do
* Purpose: Estimate a simple household-income model

clear all
set more off
version 17

global ROOT "D:\Stata Projects\Project 2\household-income-expenditure-analysis"

capture log close
log using "$ROOT/logs/06_regression_analysis.log", text replace

use "$ROOT/data/clean/04_analysis_ready.dta", clear


* Main model
* Outcome: log household income

* The Kaggle extract does not provide identifiable survey
* weights, strata, or PSU variables, so this is an unweighted
* model with heteroskedasticity-robust standard errors.

reg ln_income ///
    i.head_sex_id ///
    c.head_age##c.head_age ///
    c.hh_size ///
    c.employed_members ///
    i.income_source_id ///
    i.region_id ///
    if flag_employed_gt_hh == 0, ///
    vce(robust)

* Basic model checks
estat vif

predict residual if e(sample), residuals
predict fitted if e(sample), xb

rvfplot, yline(0) ///
    title("Residuals versus Fitted Values")

graph export "$ROOT/output/figures/04_residual_fitted.png", ///
    replace width(1800)

* Save the estimation results
estimates save "$ROOT/output/tables/income_model.ster", replace

display as result "Regression completed."
display as result "Interpret results as associations, not causal effects."

log close
