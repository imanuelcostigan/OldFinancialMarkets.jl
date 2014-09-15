####
# Types
####

type FRA <: Instrument
    amount::Real
    rate::Real
    tradedate::TimeType
    startdate::TimeType
    enddate::TimeType
    index::IBOR
end

####
# Methods
####

function FRA(currency::Currency, startterm::Period, endterm::Period,
    rate::Real, tradedate::TimeType = EVAL_DATE, amount::Real = 1e6)
    index = IBOR(currency, term)
    startdate = shift(tradedate, index.spotlag, index.bdc, index.calendar, false)
    enddate = shift(startdate, term, index.bdc, index.calendar, index.eom)
    Deposit(amount, rate, tradedate, startdate, enddate, index)
end
