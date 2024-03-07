function y=fun_saving_E_newly_born(x)

% savings of enterpreneurs

global bet r sig alp ksi psi del age_max age_T_w time_max n_pre e_pre w_t m_t rho_t g_t

% other definition
tt=x(1); % year of birth

% agents born without assets
wealth(1)=0;

% generating interest rate adjusted life-cycle earnings and others
for i=1:age_max
    if i < age_T_w
        w(i)=w_t(tt+i-1)*((1+g_t)/(1+r))^(i-1); % earnings
    else
        w(i)=0;
    end
end

% computiing life-time wealth
A=sum(w);

% cumputing current optimal consumption and savings
for i=1:age_max
    % the interest rate adjusted ratio of optimal consumption to consumption of the current age
    if i == 1
        ratio(i)=1;
    else
        ratio(i)=(bet*(1+r)/(1+g_t))^(1/sig)*(1+g_t)/(1+r)*ratio(i-1);
    end
end

% optimal consumption and savings
for i=1:age_max
    if i == 1
        consumption(i)=A/(sum(ratio));
        wealth(2)=(w_t(tt)-consumption(i))/(1+g_t);
    elseif i < age_T_w % being workers
        consumption(i)=(bet*(1+r)/(1+g_t))^(1/sig)*consumption(i-1);
        wealth(i+1)=(wealth(i)*(1+r)+w_t(tt+i-1)-consumption(i))/(1+g_t);
    else % become retirees
        consumption(i)=(bet*(1+r)/(1+g_t))^(1/sig)*consumption(i-1);
        wealth(i+1)=(wealth(i)*(1+r)-consumption(i))/(1+g_t);
    end
end

% definition of y
y(1,:)=wealth;
y(2,1:age_max)=consumption;