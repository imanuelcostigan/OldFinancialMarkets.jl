####
# Types
####

type Cash <: Instrument
    amount::Real
    rate::Real
    startdate::TimeType
    enddate::TimeType
    index::CashIndex
end

####
# Methods
####

function Cash(currency::Currency, startdate::TimeType, enddate::TimeType,
    rate::Real, amount = 1e6)
    Cash(amount, rate, startdate, enddate, CashIndex(currency))
end
