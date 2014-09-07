####
# Types
####

type Cash <: Instrument
    amount::Real
    rate::Real
    tradedate::TimeType
    startdate::TimeType
    enddate::TimeType
    index::CashIndex
end

####
# Methods
####

function Cash(currency::Currency, rate::Real, tradedate::TimeType = today(),
    amount::Real = 1e6)
    index = CashIndex(currency)
    startdate = tradedate
    enddate = adjust(tradedate + Day(1), index.bdc, index.calendar)
    Cash(amount, rate, tradedate, startdate, enddate, index)
end
