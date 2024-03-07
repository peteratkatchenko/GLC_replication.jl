*%%%%%%%%%%%%%%%%%%
* data generation
*%%%%%%%%%%%%%%%%%%

gen soe_em_sh = soe_em/total_em
gen va_pw = total_va/total_em

tab year, gen(yeardum)

tsset id year

gen va_growth = (va_pw-L.va_pw)/L.va_pw*100

gen nonsoe_em_sh = 100 - soe_em_sh*100
gen nonsoe_em_sh_diff = nonsoe_em_sh - L.nonsoe_em_sh

*************
* regression
*************

reg va_growth nonsoe_em_sh_diff yeardum* if id >= 7 & id <= 34, cluster(id) robust
reg va_growth nonsoe_em_sh_diff L.va_pw yeardum* if id >= 7 & id <= 34, cluster(id) robust
