Our data files contain a total of five stata data files, two stata do files and a zip file for matlab codes.

This readme file explains all files in an order according to the structure of the paper.

(1) "aggregates.dta" contains time series aggregate data used for generating figure 1 to 4 (the last six variables will be used for calibration).
(2) "industry.dta" contains industry-level data used for generating figure 5.
(3) "gini.dta" contains provincial gini coefficients and private employment shares for figure 6. 
(4) "province_panel.dta" contains provincial data for regressions (1) to (4) in table 1, and "province_panel.do" is for running regressions (1) to (4) in table 1.
(5) "industry_panel.dta" contains industry data for regressions (5) and (6) in table 1, and "industry_panel.do" is for running regressions (5) and (6) in table 1.
(6) "matlab.zip" contains all matlab codes for calibration and simulation. 

******************
* aggregatge.dta
******************

"aggregates.dta" contains time series aggregate data used for generating figure 1 to 4 (the last six variables will be used for calibration). 

variables:
fr_gdp     : foreign reserves GDP ratio (%) 
dl_gdp     : difference between bank deposits and loans GDP ratio (%)
em_sh_1    : private employment share measured by DPE employment in industry / (DPE+SOE) employment in industry (%)
em_sh_2    : private employment share measured by (DPE+FE) employment in industry / total employment in industry (%)
em_sh_3    : private employment share measured by DPE employment / (DPE+SOE) employment (%)
em_sh_4    : private employment share measured by (DPE+FE) employment / total employment (%)
r_soe      : returns to capital measured by total profits over net value of fixed assets for SOE in industry (%)
r_dpe      : returns to capital measured by total profits over net value of fixed assets for DPE in industry (%)
r_fe       : returns to capital measured by total profits over net value of fixed assets for FE in industry (%)
inv_ef_soe : share of investment financed by bank loans and government budgets for SOE (%)
inv_ef_dpe : share of investment financed by bank loans and government budgets for DPE (%)
inv_ef_fe  : share of investment financed by bank loans and government budgets for FE (%)
sav_gdp    : aggregate saving rate = aggregate savings / GDP
inv_gdp    : aggregate investment rate = aggregate investment / GDP
ky_soe     : capital-output ratio for SOE in industry = net value of fixed assets for SOE in industry / value-added for SOE in industry
ky_dpe     : capital-output ratio for DPE in industry = net value of fixed assets for DPE in industry / value-added for DPE in industry
r          : one-year real deposit rate (nominal rate at the end of year - CPI growth rate) (%)
real_gdp_growth : real GDP growth rate (%)

data sources:
fr_gdp     : China Statistical Yearbook (CSY), various issues
dl_gdp     : as above
em_sh_1    : CSY, various issues
em_sh_2    : as above
em_sh_3    : China Labor Statistical Yearbook (CLSY), various issues
em_sh_4    : as above
r_soe      : CSY, various issues
r_dpe      : as above
r_fe       : as above
inv_ef_soe : CSY from 1998 to 2001 and China Economy and Trade Statistical Yearbook from 2002 to 2004
inv_ef_dpe : as above
inv_ef_fe  : as above
ky_soe     : as above
ky_dpe     : as above
r          : as above
real_gdp_growth : as above

******************
* industry.dta
******************

"industry.dta" contains industry-level data used for generating figure 5. 

variables:
EM_SH_2001 : SOE employment share in industry in 2001 (%)
EM_SH_2007 : SOE employment share in industry in 2007 (%)
KL_US      : capital labor ratio in US in 1996

data sources:
EM_SH_2001 : China Industrial and Economic Statistical Yearbook 2002
EM_SH_2007 : CSY 2008
KL_US      : NBER-CES manufacturing industry database

match industries to the SIC codes
EM_SH_2001 : China Industrial Economy Statistical Yearbook (CIESY) 2002
EM_SH_2007 : CSY 2008
KL_US      : NBER-CES manufacturing industry database

index	sic code	industry
		
1	20	   Manufacture of Foods
2	208	   Manufacture of Beverages
3	21	   Manufacture of Tobacco
4	22	   Manufacture of Textile
5	23	   Manufacture of Textile Wearing Apparel, Footware and Caps
6	31	   Manufacture of Leather, Fur, Feather and Related Products
7	24	   Processing of Timber, Manufacture of Wood, Bamboo, Rattan, Palm and Straw Products
8	25	   Manufacture of Furniture
9	26	   Manufacture of Paper and Paper Products
10	27	   Printing, Reproduction of Recording Media
11	394+395	   Manufacture of Articles For Culture, Education and Sport Activities
12	29	   Processing of Petroleum, Coking, Processing of Nuclear Fuel
13	28	   Manufacture of Raw Chemical Materials and Chemical Products
14	283	   Manufacture of Medicines
15	No	   Manufacture of Chemical Fibers
16	30	   Manufacture of Rubber
17	30	   Manufacture of Plastics
18	32	   Manufacture of Non-metallic Mineral Products
19	331+332	   Smelting and Pressing of Ferrous Metals
20	333+334+335+336	   Smelting and Pressing of Non-ferrous Metals
21	34	   Manufacture of Metal Products
22	356	   Manufacture of General Purpose Machinery
23	355	   Manufacture of Special Purpose Machinery
24	37	   Manufacture of Transport Equipment
25	367	   Manufacture of Electrical Machinery and Equipment
26	36	   Manufacture of Communication Equipment, Computers and Other Electronic Equipment
27	357	   Manufacture of Measuring Instruments and Machinery for Cultural Activity and Office Work

******************
* gini.dta
******************

"gini.dta" contains provincial gini coefficients and private employment shares for figure 6. 

variables:
province   : province name
gini       : gini coefficient within province in 2006
em_sh      : private employment share measured by DPE employment in industry / (DPE+SOE) employment in industry in 2006

data sources:
gini       : report to the 17th national congress of the communist party of China
em_sh      : CIESY 2007

***********************
* province_panel.dta
***********************

"province_panel.dta" contains provincial data for regressions (1) to (4) in table 1. 
"province_panel.do" is for running regressions (1) to (4) in table 1.

variables:
gdp_pc                 : provincial GDP per capita
deflator_index         : provincial GDP deflator
gdp_pc_real            : gdp_pc / deflator_index
netexport              : provincial net export
gdpexp                 : provincial GDP
surplus                : net export / provincial gdp (%)
em_dpe                 : private employment in industry
em_soe                 : SOE employment in industry
em_dpe_sh              : private employment share in industry = em_dpe / (em_dpe + em_soe) (%)
em_dpe_sh_diff         : difference of em_dpe_sh over two years 
gdp_pc_real_10thousand : real provincial gdp per capita in 10 thousand RMB
gdp_pc_growth          : growth rate of provincial gdp per capita

data sources:
All data are from CYS, various issues, except that em_dpe from 2001 to 2003 is from CIESY 2002 to 2004.

***********************
* industry_panel.dta
***********************

"industry_panel.dta" contains industry data for regressions (5) and (6) in table 1. 
"industry_panel.do" is for running regressions (5) and (6) in table 1.

variables:
soe_em                 : SOE employment
total_em               : total employment
total_va               : total value-added
id                     : industry code (manufacturing: from 7 to 34)
soe_em_sh              : SOE employment share = soe_em / total_em
va_pw                  : value-added per worker = total_va / total_em
va_pw_growh            : growth rate of va_pw (%)
nonsoe_em_sh           : non SOE employment share = (1-soe_em_sh)*100 (%)
nonsoe_em_sh_diff      : difference of nonsoe_em_sh over two years

data sources:
CYS and CIESY, various issues

***************
* matlab.zip
***************

"matlab.zip" is a zip file containing all matlab codes for calibration and simulation.

RUN "parameter.m" for parameterization.
RUN "transition.m" for computing transitional dynamics.
RUN "result.m" for plotting the dynamics.
RUN "six_panel.m" for plotting the graph with six panels in the paper.

*******************
* firm-level data
*******************

We use firm-level data from the survey conducted by NBS to compute private employment shares when DPE is classified as firms with a private ownership share above 50 percent. The numbers are reported in footnote 4.

The firm-level data was purchased from ACMR (http://www.acmr.com.cn/en/index.html) and now managed by Fudan University. The results can be replicated at Fudan University.
