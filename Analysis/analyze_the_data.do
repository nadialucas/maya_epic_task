
clear all
set more off

if c(os) == "Windows" {
	cd "C:/Users/`c(username)'/Dropbox"
}
else if c(os) == "MacOSX" {
	cd "/Users/`c(username)'/Dropbox"
}
local DROPBOX `c(pwd)'
local DROPBOX_ROOT "`DROPBOX'"

local DATA "`DROPBOX_ROOT'/epic_task_nadia/maya/IntermediateData"
local STER "`DROPBOX_ROOT'/epic_task_nadia/maya/ster"

ssc install reghdfe, replace

use "`DATA'/super_fund.dta", clear


/*
This do file does the following:
Regress lnmdvalhs0 onto npl2000, using a price control
Regress lnmdvalhs0 onto npl2000, using price and house controls
Regress lnmdvalhs0 onto npl2000, using price, house, and economic controls
Lastly, regress lnmdvalhs0 onto npl2000, using price, house, and economic controls. Use a statefips fixed effect.
*/

/*
Controls:
price: 1980 log mean house price (did you call it lnmeanhs8?)
house: firestoveheat80, noaircond80, nofullkitchen80, zerofullbath80, 
bedrms0_80occ, bedrms1_80occ, bedrms2_80occ, bedrms3_80occ, bedrms4_80occ, 
bedrms5_80occ, blt0_1yrs80occ, blt2_5yrs80occ, blt6_10yrs80occ, blt10_20yrs80occ, 
blt20_30yrs80occ, blt30_40yrs80occ, blt40_yrs80occ, detach80occ, and mobile80occ
economic: pop_den8, shrblk8, shrhsp8, child8, old8, shrfor8, ffh8, smhse8, 
hsdrop8, no_hs_diploma8, ba_or_better8, unemprt8, povrat8, welfare8, avhhin8, 
tothsun8, ownocc8, and occupied80
*/


local price_control lnmeanhs8

local house_control firestoveheat80 noaircond80 nofullkitchen80 zerofullbath80 /// 
bedrms0_80occ bedrms1_80occ bedrms2_80occ bedrms3_80occ bedrms4_80occ /// 
bedrms5_80occ blt0_1yrs80occ blt2_5yrs80occ blt6_10yrs80occ blt10_20yrs80occ /// 
blt20_30yrs80occ blt30_40yrs80occ blt40_yrs80occ detach80occ mobile80occ 

local economic_control pop_den8 shrblk8 shrhsp8 child8 old8 shrfor8 ffh8 smhse8 /// 
hsdrop8 no_hs_diploma8 ba_or_better8 unemprt8 povrat8 welfare8 avhhin8 ///
tothsun8 ownocc8 occupied80

eststo: reg lnmdvalhs0 npl2000 `price_control'
estimates save "`STER'/price_control.ster", replace

eststo: reg lnmdvalhs0 npl2000 `price_control' `house_control'
estimates save "`STER'/price_house_control.ster", replace

eststo: reg lnmdvalhs0 npl2000 `price_control' `house_control' `economic_control'
estimates save "`STER'/price_house_economic_control.ster", replace

eststo: reghdfe lnmdvalhs0 npl2000 `price_control' `house_control' `economic_control', absorb(state)
estimates save "`STER'/price_house_economic_control_fe.ster", replace

esttab using task_2_regression.tex, obslast
label nonumber title("Models of house prices")
mtitle("Model 1" "Model 2" "Model 3" "Model4") b(%9.5f) t(%9.4f)
replace longtable noconstant addnotes("Model 4 uses state fixed effects")

eststo clear
