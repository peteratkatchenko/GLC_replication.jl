k_pre=(alp/(r/(1-ice)+del))^(1/(1-alp))*(nw_pre); % total capital during pre-transition period (all in the F sector)
w_pre=(1-alp)*(alp/(r/(1-ice)+del))^(alp/(1-alp)); % wage rate during pre-transition period

%%%%%%%%%
% for workers
%%%%%%%%%

% life-cycle patterns
for i=1:age_max
    x(1)=i; % age
    if i < age_T_w
        x(2)=w_pre; % wage
    else
        x(2)=0; % wage after retirement
    end
    if i == 1 % born without assets
        wealth_pre(i)=0; % wealth
    end
    x(3)=wealth_pre(i); % wealth
    y=feval('fun_saving_pre_transition',x);
    sr_pre(i)=y(3,1); % saving rate
    consumption_pre(i)=y(4,1); % consumption
    if i < age_max
        wealth_pre(i+1)=y(2,1);
    end
end

% initial condition
wealth_pre=initial_ratio*wealth_pre;

save data_pre wealth_pre

%%%%%%%%%%%
% for entrepreneurs
%%%%%%%%%%%

% life-cycle patterns
for i=1:age_max
    x(1)=i; % age
    if i < age_T_w
        x(2)=w_pre; % wage
    else
        x(2)=0; % wage after retirement
    end
    if i == 1 % born without assets
        wealth_pre_E(i)=0; % wealth
    end
    x(3)=wealth_pre_E(i); % wealth
    y=feval('fun_saving_pre_transition_E',x);
    sr_pre_E(i)=y(3,1); % saving rate
    consumption_pre_E(i)=y(4,1); % consumption
    if i < age_max
        wealth_pre_E(i+1)=y(2,1);
    end
end

% initial condition
wealth_pre_E=initial_ratio_E*wealth_pre_E;

save data_pre_E wealth_pre_E