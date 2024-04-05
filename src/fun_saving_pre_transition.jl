module fun_saving_pre_trans

export fun_saving_pre_transition

function fun_saving_pre_transition(x::Vector, dict::Dict)
    age_max = dict[:age_max]
    age_T_w = dict[:age_T_w]
    g_t = dict[:g_t]
    r = dict[:r]
    bet = dict[:bet]
    sig = dict[:sig]

    # Other definitions
    age = Int(x[1])  # current age
    wage = x[2]  # current wage
    wealth = x[3]  # current wealth

    # Generating interest rate adjusted life-cycle earnings and others
    w = zeros(Float64, age_max)
    for i in age:age_max
        if i < age_T_w
            w[i] = wage * ((1 + g_t) / (1 + r))^(i - age)  # earnings
        else
            w[i] = 0
        end
    end

    # Computing life-time wealth
    A = sum(w) + wealth * (1 + r)

    # Computing current optimal consumption and savings
    ratio = zeros(Float64, age_max)
    for i in age:age_max
        # the interest rate adjusted ratio of optimal consumption to consumption of the current age
        if i == age
            ratio[i] = 1
        else
            ratio[i] = (bet * (1 + r) / (1 + g_t))^(1 / sig) * (1 + g_t) / (1 + r) * ratio[i - 1]
        end
    end

    # Optimal consumption and savings
    consumption = A / sum(ratio)
    savings = wealth * r + wage - consumption
    sr = savings / (wealth * r + wage)  # saving rate

    # Computing next-period wealth
    wealth_prime = (wealth * (1 + r) + wage - consumption) / (1 + g_t)

    # Definition of y
    y = [savings, wealth_prime, sr, consumption]
    return y
end

end #End of fun_saving_pre_transition module 