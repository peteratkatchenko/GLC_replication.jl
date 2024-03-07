% workers savings and assets
clear wealth_F
for ii = 2:age_max
    
    % computing existing workers wealth given the guess of  m_t and rho_t
    y=feval('fun_saving_F_existing',[ii,wealth_pre(ii)]);
            
    % wealth time series for the existing workers with age ii
    for tt = 1:age_max-ii+1
        wealth_F(tt,ii+tt-1)=y(1,ii+tt-1);
        consumption_F(tt,ii+tt-1)=y(2,ii+tt-1);
    end
    clear y
        
end % existing workers

% newly born workers
for tt = 1:time_max
        
    % computing workers wealth given the guess of  m_t and rho_t
    y=feval('fun_saving_F_newly_born',[tt]);

    % wealth time series for the existing enterpreneurs with age ii
    for ii = 1:age_max
        wealth_F(tt+ii-1,ii)=y(1,ii);
        consumption_F(tt+ii-1,ii)=y(2,ii);
    end
    clear y
    
end % newly born workers

% demographic structure and others
for t = 1:time_max
    
    % no migration
    N_t(t)=nw_pre;
    
    % total assets of workers and total consumptions
    for i = 1:age_max
        AF(t,i)=n_weight(i)*wealth_F(t,i); 
        CF(t,i)=n_weight(i)*consumption_F(t,i);
        CE(t,i)=e_weight(i)*consumption_E(t,i);
    end
    AF_t(t)=sum(AF(t,:)); % aggregate capital in the E sector
    CF_t(t)=sum(CF(t,:)); % aggregate consumption in the F sector
    CE_t(t)=sum(CE(t,:)); % aggregate consumption in the E sector
    
    % the F sector
    if NE_t(t) < N_t(t)
        KF_t(t)=(alp/(r/(1-ice_t(t))+del))^(1/(1-alp))*(N_t(t)-NE_t(t)); % aggregate capital in the F sector
        YF_t(t)=KF_t(t)^alp*(N_t(t)-NE_t(t))^(1-alp); % aggregate output in the F sector
        NF_t(t)=N_t(t)-NE_t(t); % aggregate workers in the F sector
    else
        KF_t(t)=0; YF_t(t)=0; NF_t(t)=0;
    end

end

% aggregation
Y_t=YF_t+YE_t;
K_t=KF_t+KE_t;
C_t=CF_t+CE_t;
for t = 1:time_max-1
    
    % private employment share
    NE_N_t(t)=NE_t(t)/N_t(t);
    
    % computing investment in the F sector
    IF_t(t)=(1+g_t)*(1+g_n)*KF_t(t+1)-(1-del)*KF_t(t);
    % -r*ice_t(t)/(1-ice_t(t))
    
    % computing investment in the E sector
    IE_t(t)=(1+g_t)*(1+g_n)*KE_t(t+1)-(1-del)*KE_t(t);
    
    % investment rates in the two sector
    if YF_t(t)>0
        IF_Y_t(t)=IF_t(t)/YF_t(t);
    else
        IF_Y_t(t)=0;
    end
    IE_Y_t(t)=IE_t(t)/YE_t(t);
    
    % computing workers savings
    SF_t(t)=(1+g_t)*(1+g_n)*AF_t(t+1)-AF_t(t)+del*KF_t(t);
    if YF_t(t) > 0
        SF_YF_t(t)=SF_t(t)/YF_t(t);
    end

    % computing enterpreneurs savings
    SE_t(t)=(1+g_t)*(1+g_n)*AE_t(t+1)-AE_t(t)+del*KE_t(t);
    SE_YE_t(t)=SE_t(t)/YE_t(t);
    
    % aggregate output per capita
    Y_N_t(t)=Y_t(t)/N_t(t);
    
    % aggregate investment rate
    I_Y_t(t)=(IF_t(t)+IE_t(t))/Y_t(t);
    
    % aggregate saving rate
    S_Y_t(t)=(SF_t(t)+SE_t(t))/Y_t(t);

    % capital output ratio
    K_Y_t(t)=K_t(t)/Y_t(t);
    
    % capital outflows
    FA_Y_t(t)=(AE_t(t)+AF_t(t)-K_t(t))/Y_t(t); % stock
    BoP_Y_t(t)=S_Y_t(t)-I_Y_t(t); % flow
    
    if t > 1
        TFP_t(t)=Y_t(t)/Y_t(t-1)-alp*K_t(t)/K_t(t-1)-(1-alp)*N_t(t)/N_t(t-1);
        YG_t(t)=(Y_t(t)/Y_t(t-1)-1)+g_n+g_t;
        NG_t(t)=(NE_N_t(t)/NE_N_t(t-1)-1);
    end
    
    % test
    xxx_t(t)=C_t(t)+SF_t(t)+SE_t(t)+r*ice_t(t)/(1-ice_t(t))*KF_t(t)+r*ice_t(t)/(1-ice_t(t))*LE_t(t)-Y_t(t)-r*FA_Y_t(t)*Y_t(t);
    xx1_t(t)=CF_t(t)+AF_t(t+1)*(1+g_t)*(1+g_n)-(w_t(t)*nw_pre+(1+r)*AF_t(t));
    xx2_t(t)=CE_t(t)+AE_t(t+1)*(1+g_t)*(1+g_n)-(m_t(t)*(e_pre-ee_pre)+(1+r)*AE_t(t)+(rho_t(t)-r)*(KE_t(t)-LE_t(t))+(rho_t(t)-r/(1-ice_t(t)))*LE_t(t));
    xx3_t(t)=YE_t(t)-del*KE_t(t)-(m_t(t)*(e_pre-ee_pre)+rho_t(t)*KE_t(t)+w_t(t)*NE_t(t));
    
    % aggregate rate of return to capital
    RR_t(t)=KE_t(t)/K_t(t)*rho_t(t)+KF_t(t)/K_t(t)*r/(1-ice_t(t))+del;
    
    % labor share
    labor_share_t(t)=(w_t(t)*nw_pre+0.6*m_t(t)*(e_pre-ee_pre))/Y_t(t);

end

Y_data=Y_t(1:21)'; K_data=K_t(1:21)';
save YK_data Y_data K_data

% TFP growth from 1998 through 2005
TFP_growth=Y_t(14)/Y_t(7)-alp*K_t(14)/K_t(7)-(1-alp)*N_t(14)/N_t(7);
output_growth=Y_t(14)/Y_t(7)-1;
K_growth=K_t(14)/K_t(7)-1;
w_growth=w_t(14)/w_t(7)-1;
annual_TFP_growth=(1+TFP_growth)^(1/7)-1+(1-alp)*g_t
annual_output_growth=(1+output_growth)^(1/7)-1+g_n+g_t
annual_wage_growth=(1+w_growth)^(1/7)-1+g_t
annual_K_growth=(1+K_growth)^(1/7)-1+g_t+g_n

TFP_growth_93_04=Y_t(13)/Y_t(2)-alp*K_t(13)/K_t(2)-(1-alp)*N_t(13)/N_t(2);
annual_TFP_growth_93_04=(1+TFP_growth_93_04)^(1/11)-1+(1-alp)*g_t

% aggregate rate of return in 1998
rate_of_return_1998=KF_t(7)/K_t(7)*(r/(1-ice_t(7))+del)+KE_t(7)/K_t(7)*(rho_t(7)+del)

% average saving rate from 1998 to 2005
ave_S_Y=mean(S_Y_t(7:14))

% figures
close all
figure(1)
time_begin=1;
time_end=100; time_max-1;
tt=[time_begin:time_end];
subplot(4,2,1)
plot(tt,Y_N_t(time_begin:time_end),'r','linewidth',2)
title('panel a: aggregate output per capita')
box off

% subplot(4,2,2)
% plot(tt,NE_t(time_begin:time_end),'r','linewidth',2)
% % gtext('employment in the E sector')
% hold on
% plot(tt,N_t(time_begin:time_end),'k','linewidth',2)
% % gtext('total employment')
% title('panel b: employment')
% box off
% hold off

subplot(4,2,2)
plot(tt,NE_N_t(time_begin:time_end),'r','linewidth',2)
title('panel b: private employment share')
box off
hold off

subplot(4,2,3)
% plot(tt,m_t(time_begin:time_end),'r','linewidth',2)
% % gtext('managerial compensations')
% hold on
plot(tt,w_t(time_begin:time_end),'r','linewidth',2)
% gtext('wage rate')
% title('panel c: income inequality')
title('panel c: wage rate')
box off
hold off

subplot(4,2,4)
plot(tt,rho_t(time_begin:time_end),'r','linewidth',2)
% gtext('the rate of returns for entrepreneurs')
hold on
r_t(time_begin:time_end)=r;
plot(tt,r_t(time_begin:time_end)./(1-ice_t(time_begin:time_end)),'k','linewidth',2)
% gtext('the international interest rate')
title('panel d: rate of return to capital')
box off
hold off

subplot(4,2,5)
plot(tt,I_Y_t(time_begin:time_end),'r','linewidth',2)
hold on
plot(tt,S_Y_t(time_begin:time_end),'k','linewidth',2)
hold off
legend('I/Y','S/Y')
title('panel e: the aggregate investment and saving rates')
box off

subplot(4,2,6)
plot(tt,K_Y_t(time_begin:time_end),'r','linewidth',2)
title('panel f: the aggregate capital output ratio')
box off

subplot(4,2,7)
plot(tt,FA_Y_t(time_begin:time_end),'r','linewidth',2)
title('panel h: foreign reserves output ratio')
box off

subplot(4,2,8)
plot(tt,TFP_t(time_begin:time_end),'r','linewidth',2)
title('panel h: TFP growth rate')
box off

% test
% subplot(1,1,1)
% plot([1:age_max],wealth_E(1,:),':')
% hold on
% plot([1:age_max],wealth_E(2,:),'-')
% hold on
% plot([1:age_max],wealth_E(100,:),'.')
% hold on

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

% end of year
end_year=2012;

figure (2)
subplot(2,1,1)
plot([1992:end_year],S_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_sav,'-.','color','r','linewidth',2)
hold off
xlabel('year')
legend('model','data')
title('aggregate saving rate')
hold off
subplot(2,1,2)
plot([1992:end_year],I_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_inv,'-.','color','r','linewidth',2)
hold off
xlabel('year')
legend('model','data')
title('aggregate investment rate')
hold off

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

data_em_sh_agg=1/100*[7.12
9.21
12.41
15.58
17.36
19.24
25.79
28.14
28.86
31.51
36.28
40.63
43.94
47.7
50.69
53.84
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

figure (3)
subplot(1,1,1)
plot([1992:end_year],NE_N_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1998:2007],data_em_sh,'-.','color','r','linewidth',2)
hold on
plot([1992:2007],data_em_sh_agg,':','color','k','linewidth',2)
hold off
xlabel('year')
legend('model','firm data','aggregate data')
title('private employment share')
hold off
% print -f1 -r600 -depsc 'employment share'

figure (4)
subplot(2,1,1)
plot([1992:end_year],BoP_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_SI_Y,'-.','color','r','linewidth',2)
hold off
xlabel('year')
legend('model','data')
title('net export GDP ratio')
hold off
subplot(2,1,2)
plot([1992:end_year],FA_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_res,'-.','color','r','linewidth',2)
hold off
xlabel('year')
legend('model','data')
title('foreign reserve GDP ratio')
hold off
% print -f1 -r600 -depsc 'SI_Y'

figure (5)
subplot(1,1,1)
plot([1993:end_year],TFP_t(2:end_year-1992+1),'-','color','b','linewidth',2)
xlabel('year')
title('TFP growth rate')
% subplot(1,1,1)
% plot([1993:end_year],YG_t(2:end_year-1992+1),'-','color','b','linewidth',2)
% xlabel('year')
% title('GDP growth rate')
% print -f1 -r600 -depsc 'TFP'

figure (6)
subplot(1,1,1)
plot([1992:2012],ice_t(1:21),'-','color','b','linewidth',2)
xlabel('year')
title('iceberg costs')
hold off

figure (7)
subplot(2,1,1)
plot([1992:2012],RR_t(1:21),'-','color','b','linewidth',2)
xlabel('year')
title('aggregate rate of returnt to capital')
hold off
subplot(2,1,2)
plot([1992:2012],labor_share_t(1:21),'-','color','b','linewidth',2)
xlabel('year')
title('labor share')
hold off

figure (8)
subplot(2,1,1)
scatter(NE_N_t(1:time_max-1),Y_t(1:time_max-1))
ylabel('GDP')
xlabel('private employment share')
box off
subplot(2,1,2)
scatter(NG_t,YG_t)
ylabel('GDP growth rate')
xlabel('private employment share growth rate')
box off

% save demo_0 NE_N_t BoP_Y_t TFP_t