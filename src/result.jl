# workers savings and assets
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
NG_t = zeros(Float64, time_max)
xxx_t = zeros(Float64, time_max)
xx1_t = zeros(Float64, time_max)
xx2_t = zeros(Float64, time_max)
xx3_t = zeros(Float64, time_max)
RR_t = zeros(Float64, time_max)
labor_share_t = zeros(Float64, time_max)

wealth_F = zeros(Float64, (time_max+age_max-1), (age_max))
consumption_F = zeros(Float64, (time_max+age_max-1), (age_max))

#=consumption_E = dicttrans[:consumption_E]
NE_t = dicttrans[:NE_t]
YE_t = dicttrans[:YE_t]
KE_t = dictrans[:KE_t]
AE_t = dicttrans[:AE_t]
LE_t = dictrans[:LE_t]=#

for ii = 2:age_max

    # computing existing workers wealth given the guess of  m_t and rho_t
    result=fun_saving_F_existing([ii,wealth_pre[ii]], dictmain, dictopt)
    wealth = result[:wealth]
    consumption = result[:consumption]
            
    # wealth time series for the existing workers with age ii
    for tt = 1:age_max-ii+1
        wealth_F[tt,ii+tt-1]= wealth[ii+tt-1]
        consumption_F[tt,ii+tt-1]= consumption[ii+tt-1]
    end
end # existing workers

# newly born workers
for tt = 1:time_max
        
    # computing workers wealth given the guess of  m_t and rho_t
    result=fun_saving_F_newly_born([tt], dictmain, dictopt)
    wealth = result[:wealth]
    consumption = result[:consumption]

    # wealth time series for the existing enterpreneurs with age ii
    for ii = 1:age_max
        wealth_F[tt+ii-1,ii]= wealth[ii]
        consumption_F[tt+ii-1,ii]= consumption[ii]
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
        YF_t[t]=KF_t[t]^alp*(N_t[t]-NE_t[t])^(1-alp) # aggregate output in the F sector
        NF_t[t]=N_t[t]-NE_t[t] # aggregate workers in the F sector
    else
        KF_t[t]=0
        YF_t[t]=0
        NF_t[t]=0
    end
end

# aggregation
Y_t= YF_t+YE_t

K_t= KF_t+KE_t

C_t= CF_t+CE_t

for t = 1:time_max-1
    
    # private employment share
    NE_N_t[t]=NE_t[t]/N_t[t]
    
    # computing investment in the F sector
    IF_t[t]=(1+g_t)*(1+g_n)*KF_t[t+1]-(1-del)*KF_t[t]
    # -r*ice_t(t)/(1-ice_t(t))
    
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
        NG_t[t]=(NE_N_t[t]/NE_N_t[t-1]-1)
    end
    
    # test
    xxx_t[t]=C_t[t]+SF_t[t]+SE_t[t]+r*ice_t[t]/(1-ice_t[t])*KF_t[t]+r*ice_t[t]/(1-ice_t[t])*LE_t[t]-Y_t[t]-r*FA_Y_t[t]*Y_t[t]
    xx1_t[t]=CF_t[t]+AF_t[t+1]*(1+g_t)*(1+g_n)-(w_t[t]*nw_pre+(1+r)*AF_t[t])
    xx2_t[t]=CE_t[t]+AE_t[t+1]*(1+g_t)*(1+g_n)-(m_t[t]*(e_pre-ee_pre)+(1+r)*AE_t[t]+(rho_t[t]-r)*(KE_t[t]-LE_t[t])+(rho_t[t]-r/(1-ice_t[t]))*LE_t[t])
    xx3_t[t]=YE_t[t]-del*KE_t[t]-(m_t[t]*(e_pre-ee_pre)+rho_t[t]*KE_t[t]+w_t[t]*NE_t[t])
    
    # aggregate rate of return to capital
    RR_t[t]=KE_t[t]/K_t[t]*rho_t[t]+KF_t[t]/K_t[t]*r/(1-ice_t[t])+del
    
    # labor share
    labor_share_t[t]=(w_t[t]*nw_pre+0.6*m_t[t]*(e_pre-ee_pre))/Y_t[t]

end

Y_data=Y_t[1:21]
K_data=K_t[1:21]

save("YK_data.jld2", "Y_data", Y_data, "K_data", K_data)

# TFP growth from 1998 through 2005
TFP_growth=Y_t[14]/Y_t[7]-alp*K_t[14]/K_t[7]-(1-alp)*N_t[14]/N_t[7]
output_growth=Y_t[14]/Y_t[7]-1
K_growth=K_t[14]/K_t[7]-1
w_growth=w_t[14]/w_t[7]-1
annual_TFP_growth=(1+TFP_growth)^(1/7)-1+(1-alp)*g_t
annual_output_growth=(1+output_growth)^(1/7)-1+g_n+g_t
annual_wage_growth=(1+w_growth)^(1/7)-1+g_t
annual_K_growth=(1+K_growth)^(1/7)-1+g_t+g_n

TFP_growth_93_04=Y_t[13]/Y_t[2]-alp*K_t[13]/K_t[2]-(1-alp)*N_t[13]/N_t[2]
annual_TFP_growth_93_04=(1+TFP_growth_93_04)^(1/11)-1+(1-alp)*g_t

# aggregate rate of return in 1998
rate_of_return_1998=KF_t[7]/K_t[7]*(r/(1-ice_t[7])+del)+KE_t[7]/K_t[7]*(rho_t[7]+del)

# average saving rate from 1998 to 2005
ave_S_Y=mean(S_Y_t[7:14])

#########
# Figures
#########

#Figure 1

time_begin=1
time_end=100
tt=[time_begin:time_end]

f1p1 = plot(tt, Y_N_t[time_begin:time_end], title="panel a: aggregate output per capita", linewidth=2, color=:red)

# subplot(4,2,2)
# plot(tt,NE_t(time_begin:time_end),'r','linewidth',2)
# # gtext('employment in the E sector')
# hold on
# plot(tt,N_t(time_begin:time_end),'k','linewidth',2)
# # gtext('total employment')
# title('panel b: employment')
# 
# hold off

f1p2 = plot(tt, NE_N_t[time_begin:time_end], title="panel b: private employment share", linewidth=2, color=:red)

f1p3 = plot(tt, w_t[time_begin:time_end], title="panel c: wage rate", linewidth=2, color=:red)

# plot(tt,m_t(time_begin:time_end),'r','linewidth',2)
# # gtext('managerial compensations')
# hold on
# gtext('wage rate')
# title('panel c: income inequality')

f1p4 = plot(tt, rho_t[time_begin:time_end], title="panel d: rate of return to capital", linewidth=2, color=:red)

# gtext('the rate of returns for entrepreneurs')
#r_t(time_begin:time_end)=r
#plot(tt,r_t(time_begin:time_end)./(1-ice_t(time_begin:time_end)),'k','linewidth',2)
# gtext('the international interest rate')

subplot = plot(tt, I_Y_t[time_begin:time_end], label="I/Y", color=:red, linewidth=2)
plot!(subplot, tt, S_Y_t[time_begin:time_end], label="S/Y", color=:black, linewidth=2)
f1p5 = plot!(subplot, title="panel e: the aggregate investment and saving rates")

f1p6 = plot(tt, K_Y_t[time_begin:time_end], title="panel f: the aggregate capital output ratio", linewidth=2, color=:red)

f1p7 = plot(tt, FA_Y_t[time_begin:time_end], title="panel h: foreign reserves output ratio", linewidth=2, color=:red)

f1p8 = plot(tt, TFP_t[time_begin:time_end], title="panel h: TFP growth rate", linewidth=2, color=:red)

f1 = plot(f1p1, f1p2, f1p3, f1p4, f1p5, f1p6, f1p7, f1p8, layout=(4,2))

savefig(f1, "figure_1.png")

data_sav=[0.375905127,
0.407118937,
0.417687893,
0.418696583,
0.40780248,
0.410464312,
0.403822419,
0.38944417,
0.377046856,
0.386282215,
0.404312245,
0.432183421,
0.45699599,
0.48157501,
0.501039245,
0.51206739
]

data_inv=[0.365907013,
0.425514577,
0.405060796,
0.402900174,
0.38812706,
0.366991801,
0.361881671,
0.361607682,
0.352842054,
0.36494929,
0.378603128,
0.410289533,
0.431546215,
0.427396271,
0.425903209,
0.423250045
]

data_res=[0.038897003,
0.033068468,
0.088594251,
0.09722219,
0.117766451,
0.1420134,
0.138692692,
0.140515342,
0.138805234,
0.161149952,
0.196974228,
0.244702191,
0.314965846,
0.355479964,
0.383515959,
0.441448679
]

#Figure 2

# end of year
end_year=2012

subplot1 = plot([1992:end_year], S_Y_t[1:end_year-1992+1], label="model", color=:blue, linewidth=2)

plot!(subplot1, [1992:2007], data_sav, label="data", color=:red, linewidth=2)

f2p1 = plot(subplot1, title="Aggregate Saving Rate", xlabel="year")


subplot2 = plot([1992:end_year], I_Y_t[1:end_year-1992+1], label="model", color=:blue, linewidth=2)

plot!(subplot2, [1992:2007], data_inv, label="data", color=:red, linewidth=2)

f2p2 = plot(subplot2, title="Aggregate Investment Rate", xlabel="year")

f2 = plot(f2p1, f2p2, layout=(2,1))

savefig(f2, "figure_2.png")

data_em_sh=[0.041140261,
0.063212681,
0.10366673,
0.168350106,
0.232185343,         
0.322086332,
0.434391151,
0.474376982,
0.522120471,
0.563805401
]

data_em_sh_agg=1/100*[7.12,
9.21,
12.41,
15.58,
17.36,
19.24,
25.79,
28.14,
28.86,
31.51,
36.28,
40.63,
43.94,
47.7,
50.69,
53.84
];

data_SI_Y=[0.009998114,
-0.01839564,
0.012627097,
0.015796409,
0.01967542,
0.043472511,
0.041940748,
0.027836488,
0.024204802,
0.021332925,
0.025709117,
0.021893888,
0.025449774,
0.054178739,
0.075136036,
0.088817345
];

#Figure 3

subplot3 = plot([1992:end_year], NE_N_t[1:end_year-1992+1], label="model", color=:blue, linewidth=2)

plot!(subplot3, [1998:2007], data_em_sh, label="firm data", color=:red, linewidth=2)

plot!(subplot3, [1992:2007], data_em_sh_agg, label="aggregate data", color=:black, linewidth=2)

f3 = plot(subplot3, title="Private Employment Share", xlabel="year")

savefig(f3, "figure_3.png")


#Figure 4

subplot4 = plot([1992:end_year], BoP_Y_t[1:end_year-1992+1], label="model", color=:blue, linewidth=2)

plot!(subplot4, [1992:2007], data_SI_Y, label="data", color=:red, linewidth=2)

f4p1 = plot(subplot4, title="Net Export GDP Ratio", xlabel="year")


subplot5 = plot([1992:end_year], FA_Y_t[1:end_year-1992+1], label="model", color=:blue, linewidth=2)

plot!(subplot5, [1992:2007], data_res, label="data", color=:red, linewidth=2)

f4p2 = plot(subplot5, title="Foreign Reserve GDP Ratio", xlabel="year")

f4 = plot(f4p1, f4p2, layout=(2,1))

savefig(f4, "figure_4.png")

#Figure 5 

subplot6 = plot([1993:end_year], TFP_t[2:end_year-1992+1], color=:blue, linewidth=2)
f5 = plot(subplot6, title="TFP Growth Rate", xlabel="year")

savefig(f5, "figure_5.png")

# subplot(1,1,1)
# plot([1993:end_year],YG_t(2:end_year-1992+1),'-','color','b','linewidth',2)
# xlabel('year')
# title('GDP growth rate')
# print -f1 -r600 -depsc 'TFP'

#Figure 6

subplot7 = plot([1992:2012], ice_t[1:21], color=:blue, linewidth=2)
f6 = plot(subplot7, title="Iceburg Costs", xlabel="year")

savefig(f6, "figure_6.png")


#Figure 7

subplot8 = plot([1992:2012], RR_t[1:21], color=:blue, linewidth=2) 
f7p1 = plot(subplot8, title="Aggregate Rate of Return to Capital", xlabel="year")

subplot9 = plot([1992:2012], labor_share_t[1:21], color=:blue, linewidth=2)
f7p2 = plot(subplot9, title="Labor Share", xlabel="year")

f7 = plot(f7p1, f7p2, layout=(2,1))

savefig(f7, "figure_7.png")

#Figure 8

f8p1 = scatter(NE_N_t[1:time_max-1], Y_t[1:time_max-1], xlabel="private employment share", ylabel="GDP")

f8p2 = scatter(NG_t, YG_t, xlabel="private employment share growth rate", ylabel="GDP growth rate")

f8 = plot(f8p1, f8p2, layout=(2,1))

savefig(f8, "figure_8.png")