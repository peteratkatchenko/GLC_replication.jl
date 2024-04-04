module main_parameter

using Statistics 
using PyPlot
using MAT

include("fun_saving_pre_transition.jl") 

include("fun_saving_pre_transition_E.jl")

include("fun_saving_E_existing.jl")

include("fun_saving_E_newly_born.jl")

include("fun_saving_F_existing.jl")

include("fun_saving_F_newly_born.jl")

import fun_saving_pre_transition 

import fun_saving_pre_transition_E

import fun_saving_E_existing

import fun_saving_E_newly_born

import fun_saving_F_existing 

import fun_saving_F_newly_born

#parameter without calibration
bet=0.998; #discount factor of workers
bet_E=bet; #discount factor of enterpreneurs
r=0.0175; #world interest rate
sig=0.5; #the inverse of intertemporal substitution
alp=0.5; #capital output elasticity
del=0.10; #depreciation rate
g_n=0.03; #exogenous population growth
r_soe_ini=0.093; #initial lending rate for SOEs
ice=1-r/(r_soe_ini); #iceburg cost

#TFP growth
g_t=0.038; #exogenous TFP growth
bet=bet*(1+g_t)^(1-sig); #TFP growth adjusted discount factor
bet_E=bet_E*(1+g_t)^(1-sig); #TFP growth adjusted discount factor

#calibration targets
KY_F_E=2.65; # the ratio of K/Y in the F sector to K/Y in the E sector
rho_r=(r_soe_ini+0.09)/(r/(1-ice)); # the ratio of the rate of return in the E sector to that in the F sector
psi=1-(rho_r*r/(1-ice)+del)/(r/(1-ice)+del)/KY_F_E # share of managerial compensation
ksi=(KY_F_E)^(alp/(1-alp))/(1-psi) # productivity ratio of E over F

# bank loan in the E sector
loan_asset=1; # loan asset ratio
eta=loan_asset*(1+r/(1-ice))/(1+rho_r*r/(1-ice)+(rho_r*r/(1-ice)-r/(1-ice))*loan_asset) # measure of financial frictions

# initial asset
initial_ratio=0.80;
initial_ratio_E=0.33;

# demographic structure
age_max=50; # maximum age
age_T=26; # the age when enterpreneurs become firm owners
age_T_w=31; # the age when workers retire
time_max=400; # the end of the economy
n_pre=100; # the initial size of workers
e_pre=5; # the initial size of enterpreneurs
# computing demographic structure
if g_n > 0 || g_n < 0
    sum_demo=(1-(1+g_n)^age_max)/(1-(1+g_n)); # sum of total population
    for i in 1:age_max
        n_weight(i)=(1+g_n)^(age_max-i)/sum_demo*n_pre; # weight
        e_weight(i)=(1+g_n)^(age_max-i)/sum_demo*e_pre; # weight
    end
else
    for i in 1:age_max
        n_weight(i)=1/age_max*n_pre;
        e_weight(i)=1/age_max*e_pre;
    end
end
# the initial size of workers before retirement
nw_pre=sum(n_weight(1:age_T_w-1));
# the initial size of enterpreneurs after being firm owner
ee_pre=sum(e_weight(age_T:age_max));

# capital deepening (reform in the financial sector)
time_ab=9; # beginning of reform
time_cd=27; # end of reform
ice_t(1:time_ab)=ice; # iceburg costs before reform
ice_t(time_cd)=0; # iceburg costs after reform
speed=2.38; # speed of reform
ice_t(time_cd+1:time_max+age_max-1)=ice_t(time_cd);
for t=time_ab:time_cd
    ice_t(t)=ice+(t-time_ab)^speed*(ice_t(time_cd)-ice)/(time_cd-time_ab)^speed;
end

include("pre_transition.jl")

include("transition.jl")

include("result.jl")

include("six_panel.jl")

end #End of main_parameter module
