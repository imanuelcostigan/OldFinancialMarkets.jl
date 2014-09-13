####
# Types
####

type CashFlow{CCY<:Currency, TT<:TimeType, RR<:Real}
    currency::Vector{CCY}
    date::Vector{TT}
    amount::Vector{RR}
    function CashFlow(currency, date, amount)
        n1 = length(currency)
        n2 = length(date)
        n3 = length(amount)
        msg = "The constructor's arguments must have the same length."
        n1 == n2 == n3 || throw(ArgumentError(msg))
        new(currency, date, amount)
    end
end

function CashFlow{CCY<:Currency, TT<:TimeType, RR<:Real}(currency::Vector{CCY},
    date::Vector{TT}, amount::Vector{RR})
    CashFlow{CCY, TT, RR}(currency, date, amount)
end

Base.show(io::IO, cf::CashFlow) = show(io, DataFrame(
    Currency = string(cf.currency), Date = cf.date, Amount = cf.amount))
