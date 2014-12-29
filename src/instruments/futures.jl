####
# Types
####

abstract Future <: Instrument
type STIRFuture <: Future
    amount::Float64
    price::Float64
    tradedate::TimeType
    underlying::Deposit
end

####
# Methods
####

stirsettlementparameters(ccy::AUD) = ["nth" => 2, "day" => Fri, "off" => Day(0)]
stirsettlementparameters(ccy::EUR) = ["nth" => 3, "day" => Wed, "off" => Day(0)]
stirsettlementparameters(ccy::GBP) = ["nth" => 3, "day" => Wed, "off" => Day(0)]
stirsettlementparameters(ccy::JPY) = ["nth" => 3, "day" => Wed, "off" => Day(0)]
stirsettlementparameters(ccy::NZD) = ["nth" => 1, "day" => Wed, "off" => Day(8)]
stirsettlementparameters(ccy::USD) = ["nth" => 3, "day" => Wed, "off" => Day(0)]

function to_nth_dayofweek(dt::TimeType, n::Integer, dow::Integer)
    dt + Day(7 * (n - 1) + mod(dow - dayofweek(dt), 7))
end

function settlement(prompt::Integer, nth::Integer, dow::Integer, offset::Period,
    dt::TimeType = EVAL_DATE)
    # Assumes:
    # 1. settlement on IMM months only (Mar, Jun, Sep & Dec)
    # 2. prompt > 0
    msg = "prompt must be greater than zero."
    prompt > 0 || throw(ArgumentError(msg))
    p1start = firstdayofmonth(lastdayofquarter(dt)) + offset
    to_nth_dayofweek(p1start, nth, dow) <= dt && (p1start += Month(3))
    to_nth_dayofweek(p1start + Month(3(prompt - 1)), nth, dow)
end
function STIRFuture(ccy::Currency, prompt::Integer, price::Real,
    tradedate::TimeType = EVAL_DATE, amount::Real = 1)
    # Get STIR settlement details
    SP = stirsettlementparameters(ccy)
    # Build underlying depo
    is90d = ccy in [AUD(), NZD()]
    uterm = is90d ? Day(90) : Month(3)
    # JPY futures are TIBOR not LIBOR
    uindex = ccy == JPY() ? IBOR(ccy, uterm, false) : IBOR(ccy, uterm)
    ustartdate = settlement(prompt, SP["nth"], SP["day"], SP["off"], tradedate)
    utradedate = shift(ustartdate, -uindex.spotlag, uindex.bdc, uindex.calendar,
        uindex.eom)
    if is90d
        uenddate = adjust(ustartdate + Day(90), uindex.bdc, uindex.calendar)
    else
        uenddate = shift(ustartdate, Month(3), uindex.bdc, uindex.calendar,
            uindex.eom)
    end
    urate = 1 - price / 100
    underlying = Deposit(1e6, urate, utradedate, ustartdate, uenddate,
        uindex)
    # Build STIR future
    STIRFuture(amount, price, tradedate, underlying)
end

currency(stir::STIRFuture) = currency(stir.underlying.index)
rate(stir::STIRFuture) = rate(stir.underlying)
price(stir::STIRFuture) = price(stir.underlying) * stir.amount

function CashFlow(stir::STIRFuture)
    ccy = currency(stir)
    CashFlow([ccy, ccy], [stir.underlying.startdate, stir.underlying.enddate],
        stir.amount * [-price(stir), stir.underlying.amount])
end
