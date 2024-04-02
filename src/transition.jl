# iteration choices
relax = 0.75
iter_max = 100
tol = 1e-4
dev_max = 1
iter = 1

# initial guess
# initial_guess

# true results
data_result = load("data_result.mat")
m_t = data_result["m_t"]
w_t = data_result["w_t"]
rho_t = data_result["rho_t"]

# start to iterate
while dev_max > tol && iter < iter_max
    
    # an indicator for the end of transition
    I_end = 0
    clear!(w_t_test)
    
    # existing entrepreneurs
    for ii in 2:age_max
        # computing existing entrepreneurs wealth given the guess of m_t and rho_t
        y = fun_saving_E_existing([ii, wealth_pre_E[ii]])
        
        # wealth time series for the existing entrepreneur with age ii
        for tt in 1:(age_max - ii + 1)
            wealth_E[tt, ii + tt - 1] = y[1, ii + tt - 1]
            consumption_E[tt, ii + tt - 1] = y[2, ii + tt - 1]
        end
        clear!(y)
    end
    
    # newly born entrepreneurs
    for tt in 1:time_max
        # computing entrepreneurs wealth given the guess of m_t and rho_t
        y = fun_saving_E_newly_born([tt, wealth_pre[ii]])
        
        # wealth time series for the existing entrepreneur with age ii
        for ii in 1:age_max
            wealth_E[tt + ii - 1, ii] = y[1, ii]
            consumption_E[tt + ii - 1, ii] = y[2, ii]
        end
        clear!(y)
    end

    # update new factor prices time series
    for t in 1:time_max
        # fixed size of managers
        E_t[t] = e_pre - ee_pre
        
        # assets in the E sector
        for i in 1:age_max
            ae[t, i] = wealth_E[t, i]  # entrepreneurial capital owned by an entrepreneur at time t with age i
            AE[t, i] = e_weight[i] * ae[t, i]  # total capital owned by all entrepreneurs at time with age i
        end
        
        # capital and labor in the E sector
        for i in age_T:age_max
            if rho_t[t] >= r / (1 - ice_t[t])  # borrowing is profitable
                loan_ratio[t] = eta * (1 + rho_t[t]) / (1 + r / (1 - ice_t[t]) - eta * (rho_t[t] - r / (1 - ice_t[t])))  # loan asset ratio
                loan[t, i] = wealth_E[t, i] * loan_ratio[t]
                ke[t, i] = wealth_E[t, i] + loan[t, i]  # entrepreneurial capital owned by an entrepreneur at time t with age i
            else  # borrowing is not profitable
                loan[t, i] = 0
                ke[t, i] = wealth_E[t, i]  # entrepreneurial capital owned by an entrepreneur at time t with age i
            end
            
            ne[t, i] = ke[t, i] * ((1 - alp) * (1 - psi) * ksi^(1 - alp) / w_t[t])^(1 / alp)  # labor employed by an entrepreneur at time with age i
            KE[t, i] = e_weight[i] * ke[t, i]  # total capital owned by all entrepreneurs at time with age i
            NE[t, i] = e_weight[i] * ne[t, i]  # total labor employed by all entrepreneurs at time with age i
            LE[t, i] = e_weight[i] * loan[t, i]  # total loan
        end

        # resource allocation
        AE_t[t] = sum(AE[t, :])  # aggregate capital in the E sector
        NE_t[t] = sum(NE[t, :])  # aggregate employment in the E sector
        KE_t[t] = sum(KE[t, :])  # when rho > r
        LE_t[t] = sum(LE[t, :])  # total loan
        N_t[t] = nw_pre  # the size of workers (no migration)

        # factor prices
        if NE_t[t] >= N_t[t] && I_end == 0
            I_end = 1
            I_t = t
        elseif I_end == 1
            I_end = 1
        end

        if I_end == 0
            w_t_new[t] = (1 - alp) * (alp / (r / (1 - ice_t[t]) + del))^(alp / (1 - alp))  # wage rate
        else
            NE_t[t] = N_t[t]
            w_t_new[t] = (1 - psi) * (1 - alp) * (KE_t[t] / N_t[t])^alp * ksi^(1 - alp)  # wage rate
        end
        rho_t_new[t] = max(r, (1 - psi)^(1 / alp) * ksi^((1 - alp) / alp) * ((1 - alp) / w_t_new[t])^((1 - alp) / alp) * alp - del)  # the internal rate of returns for entrepreneurs
        YE_t[t] = KE_t[t]^alp * (ksi * NE_t[t])^(1 - alp)  # aggregate output in the E sector
        M_t[t] = psi * YE_t[t]  # total managerial compensations
        m_t_new[t] = M_t[t] / E_t[t]  # compensations for young entrepreneurs
    end

    # imposing monotonicity
    # if I_end == 1
    #     NE_t[I_t:time_max] = N_t[t]
    #     w_t_new[I_t:time_max] = (1 - psi) * (1 - alp) * (KE_t[I_t:time_max] ./ N_t[I_t:time_max]).^alp * ksi^(1 - alp)  # wage rate
    #     KF_t[I_t:time_max] = 0
    # end

    # steady state assumption
    w_t_new[time_max + 1:time_max + age_max - 1] .= w_t_new[time_max]
    rho_t_new[time_max + 1:time_max + age_max - 1] .= rho_t_new[time_max]
    m_t_new[time_max + 1:time_max + age_max - 1] .= m_t_new[time_max]

    # deviation
    dev_w = abs.(w_t_new .- w_t)
    dev_rho = abs.(rho_t_new .- rho_t)
    dev_m = abs.(m_t_new .- m_t)
    dev_w_max = maximum(dev_w)
    dev_rho_max = maximum(dev_rho)
    dev_m_max = maximum(dev_m)
    dev_max = maximum([dev_w_max, dev_rho_max, dev_m_max])

    # renew
    w_t .= w_t .* relax .+ w_t_new .* (1 - relax)
    rho_t .= rho_t .* relax .+ rho_t_new .* (1 - relax)
    m_t .= m_t .* relax .+ m_t_new .* (1 - relax)
    iter += 1
end

# result
save("data_result.mat", Dict("m_t" => m_t, "w_t" => w_t, "rho_t" => rho_t))
