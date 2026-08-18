* 02_clean_data.do
* Purpose: Rename variables and standardize categories
clear all
set more off
version 17

global ROOT "D:\Stata Projects\Project 2\household-income-expenditure-analysis"

capture log close
log using "$ROOT/logs/02_clean_data.log", text replace

use "$ROOT/data/clean/01_imported_raw.dta", clear

* Rename variables because of long headers.

unab oldvars : _all

local newvars ///
    hh_income region food_exp income_source agri_hh ///
    bread_cereal_exp rice_exp meat_exp fish_marine_exp fruit_exp ///
    vegetable_exp restaurant_hotel_exp alcohol_exp tobacco_exp ///
    clothing_footwear_exp housing_water_exp imputed_rent medical_exp ///
    transport_exp communication_exp education_exp misc_exp ///
    special_occ_exp crop_garden_exp entrepreneurial_income ///
    head_sex head_age head_marital head_education head_job ///
    head_occupation head_worker_class hh_type hh_size ///
    members_u5 members_5_17 employed_members building_type ///
    roof_type wall_type floor_area house_age bedrooms tenure_status ///
    toilet_facility electricity water_source n_tv n_cd_dvd ///
    n_stereo n_refrigerator n_washing_machine n_aircon n_car ///
    n_landline n_cellphone n_computer n_stove_oven ///
    n_motorized_banca n_motorcycle_tricycle

forvalues i = 1/60 {
    local old : word `i' of `oldvars'
    local new : word `i' of `newvars'
    rename `old' `new'
}

* Project-generated row ID
* NOTE: This is NOT an original survey household identifier.

gen long hh_id = _n
order hh_id, first
label variable hh_id "Project-generated record ID"


* Clean string values

ds, has(type string)
foreach v of varlist `r(varlist)' {
    replace `v' = trim(itrim(`v')) if !missing(`v')
}

* Standardizing obvious spelling/capitalization inconsistencies
replace region = "IX - Zamboanga Peninsula" ///
    if region == "IX - Zasmboanga Peninsula"

replace income_source = "Entrepreneurial Activities" ///
    if income_source == "Enterpreneurial Activities"

replace head_education = "Engineering and Engineering Trades Programs" ///
    if head_education == "Engineering and Engineering trades Programs"

replace head_worker_class = "Self-employed without any employee" ///
    if head_worker_class == "Self-employed wihout any employee"

replace wall_type = "Not Applicable" ///
    if lower(wall_type) == "not applicable"

* Useful variable labeling
label variable hh_income "Total household income"
label variable food_exp "Total food expenditure"
label variable income_source "Main source of income"
label variable head_sex "Household head sex"
label variable head_age "Household head age"
label variable head_education "Household head education"
label variable head_job "Household head job/business status"
label variable hh_size "Household size"
label variable employed_members "Employed family members"
label variable electricity "Electricity indicator"
label variable toilet_facility "Toilet facility"

compress
save "$ROOT/data/clean/02_cleaned.dta", replace

display as result "Cleaning complete. No observations were dropped."

log close
