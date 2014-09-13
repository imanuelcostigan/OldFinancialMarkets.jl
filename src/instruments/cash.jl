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

function Cash(currency::Currency, rate::Real, tradedate::TimeType = EVAL_DATE,
    amount::Real = 1e6)
    index = CashIndex(currency)
    startdate = tradedate
    enddate = adjust(tradedate + Day(1), index.bdc, index.calendar)
    Cash(amount, rate, tradedate, startdate, enddate, index)
end

currency(instr::Cash) = currency(instr.index)

function price(instr::Cash, date::TimeType)
    date == tradedate || error("Trade and pricing dates are not the same.")
    return instr.amount
end

function CashFlow(instr::Cash)
    ccy = currency(instr)
    tau = years(instr.startdate, instr.enddate, instr.index.daycount)
    CashFlow([ccy, ccy], [instr.startdate, instr.enddate],
        instr.amount * [-1, 1 + tau * instr.rate])
end
