####
# Types
####

struct CashFlow
    currency::Vector{Currency}
    date::Vector{TimeType}
    amount::Vector{Real}
    function CashFlow(currency::Vector{Currency}, date::Vector{TimeType},
        amount::Vector{Real})
        n1 = length(currency); n2 = length(date); n3 = length(amount)
        msg = "The constructor's arguments must have the same length."
        n1 == n2 == n3 || throw(ArgumentError(msg))
        new(currency, date, amount)
    end
end

CashFlow(currency::Currency, date::TimeType, amount::Real) = (
    CashFlow([currency], [date], [amount]))
function CashFlow(currency::Vector{C}, date::Vector{T}, amount::Vector{R}) where {C<:Currency, T<:TimeType, R<:Real}
    currency = Currency[ccy for ccy in currency]
    date = TimeType[dt for dt in date]
    amount = Real[amt for amt in amount]
    CashFlow(currency, date, amount)
end
DataFrame(cf::CashFlow) = DataFrame(Currency = string(cf.currency),
    Date = cf.date, Amount = cf.amount)
Base.show(io::IO, cf::CashFlow) = show(io, DataFrame(cf))
