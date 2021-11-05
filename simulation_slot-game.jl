# 0: free spin icon
# reward is symbols*2.5

symbols = collect(0:10)
symbols1 = collect(1:5)
symbols2 = collect(6:10)
run1 = 30
run2 = 60
row = 3
col = 3
lines = 5
multiple = 2

using StatsBase

function sampling(symbols, row, col)
    a = reshape([([sample(symbols, col, replace = false) for i in 1:col]...)...], row, col)
    b = [a; [a[1, 1] a[2, 2] a[3, 3]]; [a[1, 3] a[2, 2] a[3, 1]]]
    return b
end

function compute(lines, sampling_results)
    unit = [ifelse(sampling_results[i, :] == fill(sampling_results[i, 1], row), sampling_results[i, 1]*multiple, 0) for i in 1:lines]
    price = sum(unit)
    return price
end

function final()
    sampling_results = sampling(symbols, row, col)
    money = compute(lines, sampling_results)
    free = fill(0, 3)
    if sampling_results[1, :] == free || sampling_results[2, :] == free || sampling_results[3, :] == free
        cum_money = fill(0, (1, run1))
        for i in 1:run1
            cum_money[i] = compute(lines, sampling(symbols1, row, col))
        end
    elseif sampling_results[4, :] == free ||sampling_results[5, :] == free
        cum_money = fill(0, (1, run2))
        for i in 1:run2
            cum_money[i] = compute(lines, sampling(symbols2, row, col))
        end
    else
        cum_money = 0
    end
    total = money + sum(cum_money)
    return total
end

total_run = 10000000
processing = [final() for i in 1:total_run]
obtain = sum(processing)/total_run
println("you can get money: " * string(sum(processing)))