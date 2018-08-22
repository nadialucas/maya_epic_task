
set more off
clear all

// This path is for running the code on Sacagawea
local DROPBOX "/Users/`c(username)'/Dropbox"

//Setting path shortcuts

local DROPBOX "/Users/`c(username)'/Dropbox"
local Data "`DROPBOX'/epic_task_nadia/maya/RawData"
local OUTPUT "`DROPBOX'/epic_task_nadia/maya/IntermediateData"

import delimited using "`Data'/demographics.txt", clear
tempfile working
save `working', replace

foreach file in "house_age2.txt" "house_age1.txt" "house_chars1.txt" "house_chars2.txt"{
	import delimited "`Data'/`file'", clear
	merge 1:1 fips using `working'
	codebook _merge
	drop _merge
	tempfile working
	save `working', replace
}

gen fips_mod = fips/(10^8)
gen state_string = string(fips_mod)
replace state_string = substr(state_string,1,2)
destring state_string, gen(state)
drop state_string


cd `OUTPUT'
save "super_fund.dta", replace
