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

function FRA(currency::Currency, startterm::Period, endterm::Period, rate::Real,
    tradedate::TimeType = EVAL_DATE, amount::Real = 1e6)
    index = IBOR(currency, endterm - startterm)
    startdate = shift(tradedate, index.spotlag, index.bdc, index.calendar, false)
    enddate = shift(startdate, endterm, index.bdc, index.calendar, index.eom)
    startdate = shift(startdate, startterm, index.bdc, index.calendar, index.eom)
    FRA(amount, rate, tradedate, startdate, enddate, index)
end

currency(fra::FRA) = currency(fra.index)
rate(fra::FRA) = InterestRate(fra.rate, Simply, fra.index.daycount)
