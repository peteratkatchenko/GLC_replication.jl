function y=fun_saving_E_existing(x)

% savings of enterpreneurs

global bet_E r sig alp ksi psi del age_max age_T time_max n_pre e_pre m_t rho_t g_t eta ice_t

% adjusting rate of return due to the endogenous borrowing constraint
rho_t_ad=max(rho_t,(rho_t.*(1+r./(1-ice_t))+eta*(rho_t-r./(1-ice_t)))./(1+r./(1-ice_t)-eta*(rho_t-r./(1-ice_t))));

% other definition
age=x(1); % age
wealth(age)=x(2); % wealth

% generating interest rate adjusted life-cycle earnings and others
for i=age:age_max
    if i < age_T
        w(i)=m_t(i-age+1)*((1+g_t)/(1+r))^(i-age); % earnings
    else
        w(i)=0;
    end
end

% computiing life-time wealth
if age < age_T
    A=sum(w)+(1+r)*wealth(age);
else
    A=sum(w)+(1+rho_t_ad(1))*wealth(age);
end

% cumputing current optimal consumption and savings
for i=age:age_max
    % the interest rate adjusted ratio of optimal consumption to consumption of the current age
    if i == age
        ratio(i)=1;
    elseif i < age_T % being manager
        ratio(i)=(bet_E*(1+r)/(1+g_t))^(1/sig)*(1+g_t)/(1+r)*ratio(i-1);
    else % become firm owner
        ratio(i)=(bet_E*(1+rho_t_ad(i-age+1))/(1+g_t))^(1/sig)*(1+g_t)/(1+rho_t_ad(i-age+1))*ratio(i-1);
    end
end

% optimal consumption and savings
for i=age:age_max
    if i == age
        consumption(i)=A/(sum(ratio));
        if i < age_T
            wealth(i+1)=(wealth(i)*(1+r)+m_t(i-age+1)-consumption(i))/(1+g_t);
        else
            wealth(i+1)=(wealth(i)*(1+rho_t_ad(i-age+1))-consumption(i))/(1+g_t);
        end
    elseif i < age_T % being manager
        consumption(i)=(bet_E*(1+r)/(1+g_t))^(1/sig)*consumption(i-1);
        wealth(i+1)=(wealth(i)*(1+r)+m_t(i-age+1)-consumption(i))/(1+g_t);
    else % become firm owner
        consumption(i)=(bet_E*(1+rho_t_ad(i-age+1))/(1+g_t))^(1/sig)*consumption(i-1);
        wealth(i+1)=(wealth(i)*(1+rho_t_ad(i-age+1))-consumption(i))/(1+g_t);
    end
end

% definition of y
y(1,:)=wealth;
y(2,1:age_max)=consumption;