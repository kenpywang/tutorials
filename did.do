* Difference-in-Differences Analysis

** Description
/*

*/

** Simulate data

cls
clear

*** Parameters
local mean 10
local sd 8
set seed 1

set obs 10
generate id = _n
expand 7
bysort id: generate time = -3 + _n - 1
xtset id time

local mean_n = ln(`mean'^2 / sqrt(`sd'^2 + `mean'^2))
local sd_n = sqrt(ln((`sd'^2 / `mean'^2) + 1))
generate norm_var = rnormal(`mean_n', `sd_n')
generate condition = exp(norm_var)
drop norm_var

** Construct indicators

*** Treatment indicator

generate is_treat = 1 if time==0 & condition>=10 & !missing(condition)
replace is_treat = 0 if time==0 & condition<10 & !missing(condition)
tabulate is_treat
bysort id: fillmissing is_treat // You need ssc install fillmissing to run this line. 

*** Post indicator

generate is_post = time >= 0
tabulate is_post

** List the data

list, sepby(id)