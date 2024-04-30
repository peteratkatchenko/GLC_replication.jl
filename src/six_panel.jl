# workers savings and assets
wealth_F = zeros(Float64, (time_max+age_max-1), (age_max))
consumption_F = zeros(Float64, (time_max+age_max-1), (age_max))

AF = zeros(Float64, time_max, age_max)
CF = zeros(Float64, time_max, age_max)
CE = zeros(Float64, time_max, age_max)

N_t = zeros(Float64, time_max)
AF_t = zeros(Float64, time_max)
CF_t = zeros(Float64, time_max)
CE_t = zeros(Float64, time_max)
KF_t = zeros(Float64, time_max)
YF_t = zeros(Float64, time_max)
NF_t = zeros(Float64, time_max)
NE_N_t = zeros(Float64, time_max)
IF_t = zeros(Float64, time_max)
IE_t = zeros(Float64, time_max)
IF_Y_t = zeros(Float64, time_max)
I_Y_t = zeros(Float64, time_max)
Y_N_t = zeros(Float64, time_max)
SE_YE_t = zeros(Float64, time_max)
SE_t = zeros(Float64, time_max)
SF_YF_t = zeros(Float64, time_max)
IE_Y_t = zeros(Float64, time_max)
SF_t = zeros(Float64, time_max)
FA_Y_t = zeros(Float64, time_max)
BoP_Y_t = zeros(Float64, time_max)
TFP_t = zeros(Float64, time_max)
YG_t = zeros(Float64, time_max)
K_Y_t = zeros(Float64, time_max)
S_Y_t = zeros(Float64, time_max)

for ii = 2:age_max
    
    # computing existing workers wealth given the guess of  m_t and rho_t
    result=fun_saving_F_existing([ii,wealth_pre[ii]], dictmain, dictopt)
    wealth = result[:wealth]
    consumption = result[:consumption]    

    # wealth time series for the existing workers with age ii
    for tt = 1:age_max-ii+1
        wealth_F[tt,ii+tt-1]=wealth[ii+tt-1]
        consumption_F[tt,ii+tt-1]=consumption[ii+tt-1]
    end    
end # existing workers

# newly born workers
for tt = 1:time_max
        
    # computing workers wealth given the guess of  m_t and rho_t
    result=fun_saving_F_newly_born([tt], dictmain, dictopt)
    wealth = result[:wealth]
    consumption = result[:consumption]

    # wealth time series for the existing enterpreneur with age ii
    for ii = 1:age_max
        wealth_F[tt+ii-1,ii]=wealth[ii]
        consumption_F[tt+ii-1,ii]=consumption[ii]
    end
end # newly born workers

# demographic structure and others
for t = 1:time_max
    
    # no migration
    N_t[t]=nw_pre
    
    # total assets of workers and total consumptions
    for i = 1:age_max
        AF[t,i]=n_weight[i]*wealth_F[t,i] 
        CF[t,i]=n_weight[i]*consumption_F[t,i]
        CE[t,i]=e_weight[i]*consumption_E[t,i]
    end
    AF_t[t]=sum(AF[t,:]) # aggregate capital in the E sector
    CF_t[t]=sum(CF[t,:]) # aggregate consumption in the F sector
    CE_t[t]=sum(CE[t,:]) # aggregate consumption in the E sector
    
    # the F sector
    if NE_t[t] < N_t[t]
        KF_t[t]=(alp/(r/(1-ice_t[t])+del))^(1/(1-alp))*(N_t[t]-NE_t[t]) # aggregate capital in the F sector
        YF_t[t]=KF_t[t]^alp*(N_t[t]-NE_t[t])^(1-alp); # aggregate output in the F sector
        NF_t[t]=N_t[t]-NE_t[t] # aggregate workers in the F sector
    else
        KF_t[t]=0 
        YF_t[t]=0 
        NF_t[t]=0
    end

end

# aggregation
Y_t=YF_t+YE_t

K_t=KF_t+KE_t

C_t=CF_t+CE_t

for t = 1:time_max-1
    
    # private employment share
    NE_N_t[t]=NE_t[t]/N_t[t]
    
    # computing investment in the F sector
    IF_t[t]=(1+g_t)*(1+g_n)*KF_t[t+1]-(1-del)*KF_t[t]
    
    # computing investment in the E sector
    IE_t[t]=(1+g_t)*(1+g_n)*KE_t[t+1]-(1-del)*KE_t[t]
    
    # investment rates in the two sector
    if YF_t[t]>0
        IF_Y_t[t]=IF_t[t]/YF_t[t]
    else
        IF_Y_t[t]=0
    end
    IE_Y_t[t]=IE_t[t]/YE_t[t]
    
    # computing workers savings
    SF_t[t]=(1+g_t)*(1+g_n)*AF_t[t+1]-AF_t[t]+del*KF_t[t]
    if YF_t[t] > 0
        SF_YF_t[t]=SF_t[t]/YF_t[t]
    end

    # computing enterpreneurs savings
    SE_t[t]=(1+g_t)*(1+g_n)*AE_t[t+1]-AE_t[t]+del*KE_t[t]
    SE_YE_t[t]=SE_t[t]/YE_t[t]
    
    # aggregate output per capita
    Y_N_t[t]=Y_t[t]/N_t[t]
    
    # aggregate investment rate
    I_Y_t[t]=(IF_t[t]+IE_t[t])/Y_t[t]
    
    # aggregate saving rate
    S_Y_t[t]=(SF_t[t]+SE_t[t])/Y_t[t]

    # capital output ratio
    K_Y_t[t]=K_t[t]/Y_t[t]
    
    # capital outflows
    FA_Y_t[t]=(AE_t[t]+AF_t[t]-K_t[t])/Y_t[t] # stock
    BoP_Y_t[t]=S_Y_t[t]-I_Y_t[t] # flow
    
    if t > 1
        TFP_t[t]=Y_t[t]/Y_t[t-1]-alp*K_t[t]/K_t[t-1]-(1-alp)*N_t[t]/N_t[t-1]
        YG_t[t]=(Y_t[t]/Y_t[t-1]-1)+g_n+g_t
    end
    
end

# figures
time_begin=1
time_end=100 
time_max-1
tt=[time_begin:time_end]

data_sav=[0.375905127
0.407118937
0.417687893
0.418696583
0.40780248
0.410464312
0.403822419
0.38944417
0.377046856
0.386282215
0.404312245
0.432183421
0.45699599
0.48157501
0.501039245
0.51206739
];

data_inv=[0.365907013
0.425514577
0.405060796
0.402900174
0.38812706
0.366991801
0.361881671
0.361607682
0.352842054
0.36494929
0.378603128
0.410289533
0.431546215
0.427396271
0.425903209
0.423250045
];

data_res=[0.038897003
0.033068468
0.088594251
0.09722219
0.117766451
0.1420134
0.138692692
0.140515342
0.138805234
0.161149952
0.196974228
0.244702191
0.314965846
0.355479964
0.383515959
0.441448679
];

data_em_sh=[0.041140261
0.063212681
0.10366673
0.168350106
0.232185343
0.322086332
0.434391151
0.474376982
0.522120471
0.563805401
];

data_SI_Y=[0.009998114
-0.01839564
0.012627097
0.015796409
0.01967542
0.043472511
0.041940748
0.027836488
0.024204802
0.021332925
0.025709117
0.021893888
0.025449774
0.054178739
0.075136036
0.088817345
];

# end of year
end_year=2012

r_F=r./(1 .-ice_t)

p1 = plot([1992:2012], r_F[1:21], xlims=(1992, end_year), ylims=(0.0, 0.12), 
xlabel="year", title="Panel 1: rate of return in F firms", titlefontsize=8,
color=:blue, linewidth=2)


p2 = plot([1992:end_year], NE_N_t[1:end_year-1992+1],
title="Panel 2: E firm employment share",  titlefontsize=8,
label="model",
xlabel="year",
xlims=(1992, end_year),
ylims=(0.0, 0.801),
color=:blue, linewidth=2)
plot!(p2, [1998:2007], data_em_sh, color=:red, linewidth=2, label="firm data")
plot!(p2, [1992:2007], data_em_sh_agg, color=:black, label="aggregate data")


p3 = plot([1992:end_year], S_Y_t[1:end_year-1992+1], 
label="model",
xlabel="year",
xlims=(1992, end_year),
ylims=(0.35, 0.601),
title="Panel 3: aggregate saving rate", titlefontsize=8,
color=:blue, linewidth=2)
plot!(p3, [1992:2007], data_sav, color=:red, label="data")


p4 = plot([1992:end_year], I_Y_t[1:end_year-1992+1], 
xlabel="year",
title="Panel 4: aggregate investment rate", titlefontsize=8,
xlims=(1992, end_year),
ylims=(0.30, 0.45),
color=:blue, linewidth=2)
plot!(p4, [1992:2007], data_inv, color=:red, linewidth=2, label="data")


# subplot(3,2,5)
# plot([1992:end_year],BoP_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
# hold on
# plot([1992:2007],data_SI_Y,'-.','color','r','linewidth',2)
# hold off
# xlabel('year')
# # legend('model','data')
# axis([1992 end_year -0.05 0.201])
# title('net export GDP ratio')
# hold off


p5 = plot([1992:end_year], FA_Y_t[1:end_year-1992+1], 
label="model", 
xlabel="year",
title="Panel 5: foreign reserve / GDP", titlefontsize=8,
xlims=(1992, end_year),
ylims=(0.0, 0.75),
color=:blue, linewidth=2)
plot!(p5, [1992:2007], data_res, label="data", color=:red, linewidth=2)


p6 = plot([1992:end_year], TFP_t[1:end_year-1992+1] .+(1-alp)*g_t, 
xlabel="year",
label="model",
title="Panel 6: TFP growth rate", titlefontsize=8,
xlims=(1992, end_year),
ylims=(0.0, 0.1),
color=:blue, linewidth=2)

f = plot(p1, p2, p3, p4, p5, p6, layout=(3,2))
savefig(f, "six_panel.png")