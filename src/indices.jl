####
# Types
####

abstract Index
abstract InterestRateIndex <: Index

##############################################################################
### Cash
##############################################################################

immutable CashIndex{CCY<:Currency} <: InterestRateIndex
    currency::CCY
    calendar::JointFCalendar
    bdc::BusinessDayConvention
    daycount::DayCountFraction
end

# OpenGamma: Interest rate instruments & market conventions guide
CashIndex(::AUD) = CashIndex{AUD}(AUD(), *(AUSYFCalendar(), AUMEFCalendar()),
    Following(), A365())
CashIndex(::EUR) = CashIndex{EUR}(EUR(), EUTAFCalendar(), Following(), A360())
CashIndex(::GBP) = CashIndex{GBP}(GBP(), GBLOFCalendar(), Following(), A365())
CashIndex(::JPY) = CashIndex{JPY}(JPY(), JPTOFCalendar(), Following(), A365())
CashIndex(::NZD) = CashIndex{NZD}(NZD(), +(NZAUFCalendar(), NZWEFCalendar()),
    Following(), A365())
CashIndex(::USD) = CashIndex{USD}(USD(), USNYFCalendar(), Following(), A360())

typealias AONIA CashIndex{AUD}
typealias EONIA CashIndex{EUR}
typealias SONIA CashIndex{GBP}
typealias TONAR CashIndex{JPY}
typealias NZIONA CashIndex{NZD}
typealias FedFund CashIndex{USD}

AONIA() = CashIndex(AUD())
EONIA() = CashIndex(EUR())
SONIA() = CashIndex(GBP())
TONAR() = CashIndex(JPY())
NZIONA() = CashIndex(NZD())
FedFund() = CashIndex(USD())

##############################################################################
### LIBOR
##############################################################################

immutable IBOR{CCY<:Currency} <: InterestRateIndex
    currency::CCY
    spotlag::Period
    tenor::Period
    # Use currency's calendar to determine value date
    calendar::JointFCalendar
    bdc::BusinessDayConvention
    eom::Bool
    daycount::DayCountFraction
end

function IBOR(::AUD, tenor::Period)
    # http://www.afma.com.au/standards/market-conventions/Bank%20Bill%20Swap%20(BBSW)%20Benchmark%20Rate%20Conventions.pdf
    # OpenGamma: Interest rate instruments & market conventions guide
    # NB: Spot lag is 1 day because assuming end-of-day instance of IBOR
    #     Spot lag of 0 day applies only to transactions prior to 10am
    IBOR{AUD}(AUD(), Day(1), tenor, AUSYFCalendar(), Succeeding(), false, A365())
end
function IBOR(::EUR, tenor::Period, libor = false)
    if libor
        # https://www.theice.com/iba/libor
        # http://www.bbalibor.com/technical-aspects/fixing-value-and-maturity
        # OpenGamma: Interest rate instruments & market conventions guide
        if tenor < Month(1)
            spotlag = Day(0)
            bdc = Following()
        else
            spotlag = Day(2)
            bdc = ModifiedFollowing()
        end
        return IBOR{EUR}(EUR(), spotlag, tenor,
            +(GBLOFCalendar(), EULIBORFCalendar()), bdc, true, A360())
    else
        # http://www.emmi-benchmarks.eu/assets/files/Euribor_tech_features.pdf
        # OpenGamma: Interest rate instruments & market conventions guide
        return IBOR{EUR}(EUR(), Day(2), tenor, EUTAFCalendar(),
            ModifiedFollowing(), true, A360())
    end
end
function IBOR(::GBP, tenor::Period)
    # https://www.theice.com/iba/libor
    # http://www.bbalibor.com/technical-aspects/fixing-value-and-maturity
    # OpenGamma: Interest rate instruments & market conventions guide
    if tenor < Month(1)
        spotlag = Day(0)
        bdc = Following()
    else
        spotlag = Day(2)
        bdc = ModifiedFollowing()
    end
    IBOR{GBP}(GBP(), spotlag, tenor, GBLOFCalendar(), bdc, true, A365())
end
function IBOR(::JPY, tenor::Period, libor = true)
    if tenor < Month(1)
        spotlag = Day(0)
        bdc = Following()
    else
        spotlag = Day(2)
        bdc = ModifiedFollowing()
    end
    if libor
        # https://www.theice.com/iba/libor
        # http://www.bbalibor.com/technical-aspects/fixing-value-and-maturity
        # OpenGamma: Interest rate instruments & market conventions guide
        cal = GBLOFCalendar()
        eom = true
    else
        # TIBOR
        # http://www.jbatibor.or.jp/english/public/pdf/JBA%20TIBOR%20Operational%20RulesE.pdf
        # OpenGamma: Interest rate instruments & market conventions guide
        cal = JPTOFCalendar()
        eom = false
    end
    IBOR{JPY}(JPY(), spotlag, tenor, cal, bdc, eom, A360())
end
function IBOR(::NZD, tenor::Period)
    # http://www.nzfma.org/includes/download.aspx?ID=130053
    # OpenGamma: Interest rate instruments & market conventions guide
    msg = "The tenor must be no less than 1 month."
    tenor < Month(1) && throw(ArgumentError(msg))
    IBOR{NZD}(NZD(), Day(0), tenor, +(NZAUFCalendar(), NZWEFCalendar()), bdc,
        false, A365())
end
function IBOR(::USD, tenor::Period)
    # https://www.theice.com/iba/libor
    # http://www.bbalibor.com/technical-aspects/fixing-value-and-maturity
    # OpenGamma: Interest rate instruments & market conventions guide
    if tenor < Month(1)
        spotlag = Day(0)
        bdc = Following()
        (tenor == Day(1) ?
            calendar = +(GBLOFCalendar(), USLIBORFCalendar()) :
            calendar = GBLOFCalendar())
    else
        spotlag = Day(2)
        bdc = ModifiedFollowing()
        calendar = GBLOFCalendar()
    end
    IBOR{USD}(USD(), spotlag, tenor, calendar, bdc, true, A360())
end

typealias AUDBBSW IBOR{AUD}
typealias EURIBOR IBOR{EUR}
typealias GBPLIBOR IBOR{GBP}
typealias JPYLIBOR IBOR{JPY}
typealias NZDBKBM IBOR{NZD}
typealias USDLIBOR IBOR{USD}

AUDBBSW(tenor) = IBOR(AUD(), tenor)
EURIBOR(tenor) = IBOR(EUR(), tenor)
EURLIBOR(tenor) = IBOR(EUR(), tenor, true)
GBPLIBOR(tenor) = IBOR(GBP(), tenor)
JPYLIBOR(tenor) = IBOR(JPY(), tenor)
JPYTIBOR(tenor) = IBOR(JPY(), tenor, false)
NZDBKBM(tenor) = IBOR(NZD(), tenor)
USDLIBOR(tenor) = IBOR(USD(), tenor)

#####
# Methods
#####

currency(index::Index) = index.currency
