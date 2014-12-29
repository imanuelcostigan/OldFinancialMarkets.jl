####
# Types
####

type CashFlow
    currency::Vector{Currency}
    date::Vector{TimeType}
    amount::Vector{Float64}
    function CashFlow(currency, date, amount)
        n1, n2, n3 = (length(currency), length(date), length(amount))
        msg = "The constructor's arguments must have the same length."
        n1 == n2 == n3 || throw(ArgumentError(msg))
        new(currency, date, amount)
    end
end

function CashFlow(currency::Currency, date::TimeType, amount::Real)
    CashFlow([currency], [date], [amount])
end

DataFrame(cf::CashFlow) = DataFrame(Currency = string(cf.currency),
    Date = cf.date, Amount = cf.amount)

Base.show(io::IO, cf::CashFlow) = show(io, DataFrame(cf))
