####
# Types
####

abstract Index
abstract InterestRateIndex <: Index

##############################################################################
### Cash
##############################################################################

immutable ONIA{CCY<:Currency} <: InterestRateIndex
    currency::CCY
    calendar::JointCalendar
    bdc::BusinessDayConvention
    daycount::DayCountFraction
end

# OpenGamma: Interest rate instruments & market conventions guide
ONIA(::AUD) = ONIA{AUD}(AUD(),
    join(AUSYCalendar(), AUMECalendar(), AnyDaysGood()), Following(), A365())
ONIA(::EUR) = ONIA{EUR}(EUR(), EUTACalendar(), Following(), A360())
ONIA(::GBP) = ONIA{GBP}(GBP(), GBLOCalendar(), Following(), A365())
ONIA(::JPY) = ONIA{JPY}(JPY(), JPTOCalendar(), Following(), A365())
ONIA(::NZD) = ONIA{NZD}(NZD(), join(NZAUCalendar(), NZWECalendar()),
    Following(), A365())
ONIA(::USD) = ONIA{USD}(USD(), USNYCalendar(), Following(), A360())

typealias AONIA ONIA{AUD}
typealias EONIA ONIA{EUR}
typealias SONIA ONIA{GBP}
typealias TONAR ONIA{JPY}
typealias NZIONA ONIA{NZD}
typealias FedFund ONIA{USD}

AONIA() = ONIA(AUD())
EONIA() = ONIA(EUR())
SONIA() = ONIA(GBP())
TONAR() = ONIA(JPY())
NZIONA() = ONIA(NZD())
FedFund() = ONIA(USD())

##############################################################################
### LIBOR
##############################################################################

immutable IBOR{CCY<:Currency} <: InterestRateIndex
    currency::CCY
    spotlag::Period
    tenor::Period
    # Use currency's calendar to determine value date
    calendar::JointCalendar
    bdc::BusinessDayConvention
    eom::Bool
    daycount::DayCountFraction
end

function IBOR(::AUD, tenor::Period)
    # http://www.afma.com.au/standards/market-conventions/Bank%20Bill%20Swap%20(BBSW)%20Benchmark%20Rate%20Conventions.pdf
    # OpenGamma: Interest rate instruments & market conventions guide
    # NB: Spot lag is 1 day because assuming end-of-day instance of IBOR
    #     Spot lag of 0 day applies only to transactions prior to 10am
    IBOR{AUD}(AUD(), Day(1), tenor, AUSYCalendar(), Succeeding(), false,
        A365())
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
            join(GBLOCalendar(), EULIBORCalendar()), bdc, true, A360())
    else
        # http://www.emmi-benchmarks.eu/assets/files/Euribor_tech_features.pdf
        # OpenGamma: Interest rate instruments & market conventions guide
        return IBOR{EUR}(EUR(), Day(2), tenor, EUTACalendar(),
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
    IBOR{GBP}(GBP(), spotlag, tenor, GBLOCalendar(), bdc, true, A365())
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
        cal = GBLOCalendar()
        eom = true
    else
        # TIBOR
        # http://www.jbatibor.or.jp/english/public/pdf/JBA%20TIBOR%20Operational%20RulesE.pdf
        # OpenGamma: Interest rate instruments & market conventions guide
        cal = JPTOCalendar()
        eom = false
    end
    IBOR{JPY}(JPY(), spotlag, tenor, cal, bdc, eom, A360())
end
function IBOR(::NZD, tenor::Period)
    # http://www.nzfma.org/includes/download.aspx?ID=130053
    # OpenGamma: Interest rate instruments & market conventions guide
    msg = "The tenor must be no less than 1 month."
    tenor < Month(1) && throw(ArgumentError(msg))
    IBOR{NZD}(NZD(), Day(0), tenor, join(NZAUCalendar(), NZWECalendar()), bdc,
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
            calendar = join(GBLOCalendar(), USLIBORCalendar()) :
            calendar = GBLOCalendar())
    else
        spotlag = Day(2)
        bdc = ModifiedFollowing()
        calendar = GBLOCalendar()
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
benchmark(index::AUDBBSW) = "BBSW"
benchmark(index::EURIBOR) = "(L)IBOR"
benchmark(index::GBPLIBOR) = "LIBOR"
benchmark(index::JPYLIBOR) = "(L|T)IBOR"
benchmark(index::NZDBKBM) = "BKBM"
benchmark(index::USDLIBOR) = "LIBOR"
benchmark(index::AONIA) = "AONIA"
benchmark(index::EONIA) = "EONIA"
benchmark(index::SONIA) = "SONIA"
benchmark(index::TONAR) = "TONAR"
benchmark(index::NZIONA) = "NZIONA"
benchmark(index::FedFund) = "FedFund"

Base.string(index::ONIA) = benchmark(index)
Base.string(index::IBOR) = (replace(string(index.tenor), r"s$", "") * " " *
    benchmark(index))
Base.show(io::IO, index::InterestRateIndex) = print(io, string(index))
