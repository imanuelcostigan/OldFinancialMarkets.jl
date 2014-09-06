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

function Cash(currency::Currency, rate::Real, startdate = today(), amount = 1e6)
    index = CashIndex(currency)
    enddate = adjust(startdate + Day(1), index.bdc, index.calendar)
    Cash(amount, rate, startdate, enddate, index)
end
