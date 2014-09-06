####
# Types
####

type Deposit <: Instrument
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

function Deposit(currency::Currency, term::Period, rate::Real,
    tradedate = today(), amount = 1e6)
    index = IBOR(currency, term)
    startdate = shift(tradedate, index.spotlag, index.bdc, index.calendar, false)
    enddate = shift(startdate, term, index.bdc, index.calendar, index.eom)
    Deposit(amount, rate, tradedate, startdate, enddate, index)
end
