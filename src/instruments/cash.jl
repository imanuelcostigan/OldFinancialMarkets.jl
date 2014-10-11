####
# Types
####

type Cash <: Instrument
    amount::Real
    rate::Real
    tradedate::TimeType
    startdate::TimeType
    enddate::TimeType
    index::ONIA
end

####
# Methods
####

function Cash(currency::Currency, rate::Real, tradedate::TimeType = EVAL_DATE,
    amount::Real = 1e6)
    index = ONIA(currency)
    startdate = tradedate
    enddate = adjust(tradedate + Day(1), index.bdc, index.calendar)
    Cash(amount, rate, tradedate, startdate, enddate, index)
end

currency(cash::Cash) = currency(cash.index)
rate(cash::Cash) = InterestRate(cash.rate, Simply, cash.index.daycount)
price(cash::Cash) = cash.amount

function CashFlow(cash::Cash)
    ccy = currency(cash)
    dt1 = cash.startdate; dt2 = cash.enddate
    cap = 1 / value(convert(DiscountFactor, rate(cash), dt1, dt2))
    CashFlow([ccy, ccy], [dt1, dt2], cash.amount * [-1, cap])
end
