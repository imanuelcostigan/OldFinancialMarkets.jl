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
stirsettlementparameters(ccy::NZD) = ["nth" => 1, "day" => Wed, "off" => Day(9),
    "delay" => Day(1)]
stirsettlementparameters(ccy::USD) = ["nth" => 3, "day" => Wed, "off" => Day(0),
    "delay" => Day(2)]

function STIRFuture(ccy::Currency, prompt::Integer, price::Real,
    tradedate = today(), amount = 1)
    # Get STIR settlement details
    SP = stirsettlementparameters(ccy)
    # Build underlying depo
    uterm = ccy in [AUD(), NZD()] ? Day(90) : Month(3)
    uindex = IBOR(ccy, term)
    ustartdate = settlementdate(prompt, SP["nth"], SP["day"], SP["off"],
        tradedate)
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
