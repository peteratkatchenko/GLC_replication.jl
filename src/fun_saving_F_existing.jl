module fun_saving_F_exis 

function fun_saving_F_existing(x)
    # Savings of entrepreneurs
    
    # Global variables
    global bet::Float64
    global r::Float64
    global sig::Float64
    global alp::Float64
    global ksi::Float64
    global psi::Float64
    global del::Float64
    global age_max::Int64
    global age_T_w::Int64
    global time_max::Int64
    global n_pre::Int64
    global e_pre::Int64
    global w_t::Vector{Float64}
    global m_t::Vector{Float64}
    global rho_t::Vector{Float64}
    global g_t::Float64
    
    # Other definition
    age = x[1]   # age
    wealth = zeros(age_max)  # wealth array
    wealth[age] = x[2]   # wealth at given age
    
    # Generating interest rate adjusted life-cycle earnings and others
    w = zeros(age_max)
    for i in age:age_max
        if i < age_T_w
            w[i] = w_t[i - age + 1] * ((1 + g_t) / (1 + r))^(i - age)  # Earnings
        else
            w[i] = 0
        end
    end
    
    # Computing lifetime wealth
    A = sum(w) + (1 + r) * wealth[age]
    
    # Computing current optimal consumption and savings
    ratio = zeros(age_max)
    for i in age:age_max
        if i == age
            ratio[i] = 1
        else
            ratio[i] = (bet * (1 + r) / (1 + g_t))^(1 / sig) * (1 + g_t) / (1 + r) * ratio[i - 1]
        end
    end
    
    # Optimal consumption and savings
    consumption = zeros(age_max)
    for i in age:age_max
        if i == age
            consumption[i] = A / sum(ratio)
            if i < age_T_w
                wealth[i + 1] = (wealth[i] * (1 + r) + w_t[i - age + 1] - consumption[i]) / (1 + g_t)
            else
                wealth[i + 1] = (wealth[i] * (1 + r) - consumption[i]) / (1 + g_t)
            end
        elseif i < age_T_w  # Being workers
            consumption[i] = (bet * (1 + r) / (1 + g_t))^(1 / sig) * consumption[i - 1]
            wealth[i + 1] = (wealth[i] * (1 + r) + w_t[i - age + 1] - consumption[i]) / (1 + g_t)
        else  # Become retirees
            consumption[i] = (bet * (1 + r) / (1 + g_t))^(1 / sig) * consumption[i - 1]
            wealth[i + 1] = (wealth[i] * (1 + r) - consumption[i]) / (1 + g_t)
        end
    end
    
    # Definition of y
    y = [wealth'; consumption']
    
    return y
end

end #End of fun_saving_F_exis module 