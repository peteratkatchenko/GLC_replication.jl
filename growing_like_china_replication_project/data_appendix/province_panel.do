tsset id year

gen em_dpe_sh = em_dpe/(em_dpe+em_soe)*100

gen gdp_pc_growth = (gdp_pc_real - L.gdp_pc_real)/L.gdp_pc_real*100

gen surplus = netexport/gdpexp*100

tab year, gen(yeardum)

gen em_dpe_sh_diff = em_dpe_sh - L.em_dpe_sh

gen gdp_pc_real_10thousand = gdp_pc_real/10000

*************
* regression
*************

tsset id year

reg surplus em_dpe_sh_diff yeardum*, cluster(id) robust
reg surplus em_dpe_sh_diff L.gdp_pc_real_10thousand yeardum*, cluster(id) robust

reg gdp_pc_growth em_dpe_sh_diff yeardum*, cluster(id) robust
reg gdp_pc_growth em_dpe_sh_diff L.gdp_pc_real_10thousand yeardum*, cluster(id) robust
