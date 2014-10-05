####
# Types
####

type CashFlow
    currency::Vector{Currency}
    date::Vector{TimeType}
    amount::Vector{Real}
    function CashFlow(currency, date, amount)
        n1 = length(currency); n2 = length(date); n3 = length(amount)
        msg = "The constructor's arguments must have the same length."
        n1 == n2 == n3 || throw(ArgumentError(msg))
        typeof(currency) <: Vector{Currency} || (currency =
            Currency[ccy for ccy in currency])
        typeof(date) <: Vector{TimeType} || (date =
            TimeType[dt for dt in date])
        typeof(amount) <: Vector{Real} || (amount =
            Real[amt for amt in amount])
        new(currency, date, amount)
    end
end

DataFrame(cf::CashFlow) = DataFrame(Currency = string(cf.currency),
    Date = cf.date, Amount = cf.amount)
Base.show(io::IO, cf::CashFlow) = show(io, DataFrame(cf))
