####
# Types
####

abstract Index
abstract InterestRateIndex <: Index
immutable IBOR <: InterestRateIndex
    currency::Currency
    spotlag::Period
    tenor::Period
    calendar::MultipleFinCalendar
    # Use currency's calendar to determine value date
    bdc::BusinessDayConvention
    eom::Bool
    compounding::Int
    daycount::DayCountFraction
    function IBOR(currency, spotlag, tenor, calendar, bdc, eom, compounding,
        daycount)
        haskey(COMPOUNDINGS, compounding) || error("Invalid compounding.")
        new(currency, spotlag, tenor, calendar, bdc, eom, compounding,
            daycount)
    end
end

function AUDBBSW(tenor::Period)
    # http://www.afma.com.au/standards/market-conventions/Bank%20Bill%20Swap%20(BBSW)%20Benchmark%20Rate%20Conventions.pdf
    # OpenGamma: Interest rate instruments & market conventions guide
    # NB: Spot lag is 1 day because assuming end-of-day instance of IBOR
    #     Spot lag of 0 day applies only to transactions prior to 10am
    IBOR(AUD(), Day(1), tenor, AUSYFCalendar(), Succeeding(), false, Simply,
        A365())
end

function EURLIBOR(tenor::Period)
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
    IBOR(GBP(), spotlag, tenor, (GBLOFCalendar(), EULIBORFCalendar()), bdc,
        true, Simply, A360())
end

function EURIBOR(tenor::Period)
    # http://www.emmi-benchmarks.eu/assets/files/Euribor_tech_features.pdf
    # OpenGamma: Interest rate instruments & market conventions guide
    IBOR(EUR(), Day(2), tenor, EUTAFCalendar(), ModifiedFollowing(), false, Simply, A360())
end

function GBPLIBOR(tenor::Period)
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
    IBOR(GBP(), spotlag, tenor, GBLOFCalendar(), bdc, true, Simply, A365())
end

function JPYLIBOR(tenor::Period)
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
    IBOR(JPY(), spotlag, tenor, GBLOFCalendar(), bdc, true, Simply, A360())
end

function JPYTIBOR(tenor::Period)
    # http://www.jbatibor.or.jp/english/public/pdf/JBA%20TIBOR%20Operational%20RulesE.pdf
    # OpenGamma: Interest rate instruments & market conventions guide
    if tenor < Month(1)
        # Assume this to be the case. O/W maturity won't make sense. Think for
        # example 1w TIBOR depo out of 23 Jun where 30 June is bad.
        spotlag = Day(0)
        bdc = Following()
    else
        spotlag = Day(2)
        bdc = ModifiedFollowing()
    end
    IBOR(JPY(), spotlag, tenor, JPTOFCalendar(), bdc, false, Simply, A365())
end

function NZDBKBM(tenor::Period)
    # http://www.nzfma.org/includes/download.aspx?ID=130053
    # OpenGamma: Interest rate instruments & market conventions guide
    tenor < Month(1) && error("The tenor must be no less than 1 month.")
    IBOR(NZD(), Day(0), tenor, (NZAUFCalendar(), NZWEFCalendar()), bdc, false,
        Simply, A365())
end

function USDLIBOR(tenor::Period)
    # https://www.theice.com/iba/libor
    # http://www.bbalibor.com/technical-aspects/fixing-value-and-maturity
    # OpenGamma: Interest rate instruments & market conventions guide
    if tenor < Month(1)
        spotlag = Day(0)
        bdc = Following()
        (tenor == Day(1) ? calendar = (GBLOFCalendar(), USLIBORFCalendar()) :
            calendar = GBLOFCalendar())
    else
        spotlag = Day(2)
        bdc = ModifiedFollowing()
        calendar = GBLOFCalendar()
    end
    IBOR(USD(), spotlag, tenor, calendar, bdc, true, Simply, A360())
end
