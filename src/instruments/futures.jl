####
# Types
####

abstract Future <: Instrument
type STIRFuture <: Future
    amount::Real
    price::Real
    tradedate::TimeType
    underlying::Deposit
end

####
# Methods
####

stirsettlementparameters(ccy::AUD) = ["nth" => 2, "day" => Fri, "off" => Day(0),
    "delay" => Day(1)]
stirsettlementparameters(ccy::EUR) = ["nth" => 3, "day" => Wed, "off" => Day(0),
    "delay" => Day(2)]
stirsettlementparameters(ccy::GBP) = ["nth" => 3, "day" => Wed, "off" => Day(0),
    "delay" => Day(1)]
stirsettlementparameters(ccy::JPY) = ["nth" => 3, "day" => Wed, "off" => Day(0),
    "delay" => Day(2)]
stirsettlementparameters(ccy::NZD) = ["nth" => 1, "day" => Wed, "off" => Day(8),
    "delay" => Day(1)]
stirsettlementparameters(ccy::USD) = ["nth" => 3, "day" => Wed, "off" => Day(0),
    "delay" => Day(2)]

function to_nth_dayofweek(dt::TimeType, n::Integer, dow::Integer)
    dt + Day(7 * (n - 1) + mod(dow - dayofweek(dt), 7))
end

function settlement(prompt::Integer, nth::Integer, dow::Integer, offset::Period,
    dt::TimeType = EVAL_DATE)
    # Assumes:
    # 1. settlement on IMM months only (Mar, Jun, Sep & Dec)
    # 2. prompt > 0
    prompt > 0 || error("prompt must be greater than zero.")
    p1start = firstdayofmonth(lastdayofquarter(dt)) + offset
    to_nth_dayofweek(p1start, nth, dow) <= dt && (p1start += Month(3))
    to_nth_dayofweek(p1start + Month(3(prompt - 1)), nth, dow)
end

function STIRFuture(ccy::Currency, prompt::Integer, price::Real,
    tradedate::TimeType = EVAL_DATE, amount::Real = 1)
    # Get STIR settlement details
    SP = stirsettlementparameters(ccy)
    # Build underlying depo
    uterm = ccy in [AUD(), NZD()] ? Day(90) : Month(3)
    uindex = IBOR(ccy, term)
    ustartdate = settlement(prompt, SP["nth"], SP["day"], SP["off"], tradedate)
    utradedate = shift(ustartdate, -SP["delay"], uindex.bdc, uindex.calendar,
        uindex.eom)
    uenddate = shift(ustartdate, uindex.tenor, uindex.bdc, uindex.calendar,
        uindex.eom)
    urate = 1 - price / 100
    underlying = Deposit(1e6, urate, utradedate, ustartdate, uenddate,
        uindex)
    # Build STIR future
    STIRFuture(amount, price, tradedate, underlying)
end
