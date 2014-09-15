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
    tradedate::TimeType = EVAL_DATE, amount::Real = 1e6)
    index = IBOR(currency, term)
    startdate = shift(tradedate, index.spotlag, index.bdc, index.calendar, false)
    enddate = shift(startdate, term, index.bdc, index.calendar, index.eom)
    Deposit(amount, rate, tradedate, startdate, enddate, index)
end

currency(depo::Deposit) = currency(depo.index)
rate(depo::Deposit) = InterestRate(depo.rate, Simply, depo.index.daycount)

function price(depo::Deposit)
    depo.amount * value(convert(DiscountFactor, rate(depo),
        depo.startdate, depo.enddate))
end

function CashFlow(depo::Deposit)
    ccy = currency(depo)
    CashFlow([ccy, ccy], [depo.startdate, depo.enddate],
        depo.amount * [-price(depo), 1])
end
