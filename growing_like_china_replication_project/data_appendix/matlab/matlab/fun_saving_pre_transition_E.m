function y=fun_saving_pre_transition_E(x)

global bet_E r sig alp ksi psi del age_max age_T_w time_max n_pre e_pre g_t

% other definition
age=x(1); % current age
wage=x(2); % current wage
wealth=x(3); % current wealth

% generating interest rate adjusted life-cycle earnings and others
for i=age:age_max
    if i < age_T_w
        w(i)=wage*((1+g_t)/(1+r))^(i-age); % earnings
    else
        w(i)=0;
    end
end

% computiing life-time wealth
A=sum(w)+wealth*(1+r);

% cumputing current optimal consumption and savings
for i=age:age_max
    % the interest rate adjusted ratio of optimal consumption to consumption of the current age
    if i == age
        ratio(i)=1;
    else
        ratio(i)=(bet_E*(1+r)/(1+g_t))^(1/sig)*(1+g_t)/(1+r)*ratio(i-1);
    end
end
% optimal consumption and savings
consumption=A/(sum(ratio));
savings=wealth*r+wage-consumption;
sr=savings/(wealth*r+wage); % saving rate

% computing next-period wealth
wealth_prime=(wealth*(1+r)+wage-consumption)/(1+g_t);

% definition of y
y(1,1)=savings;
y(2,1)=wealth_prime;
y(3,1)=sr;
y(4,1)=consumption;