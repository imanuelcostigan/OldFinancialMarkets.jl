####
# Types
####
# Stub types
abstract Stub
abstract FrontStub <: Stub
abstract BackStub <: Stub
immutable ShortFrontStub <: FrontStub end
immutable LongFrontStub <: FrontStub end
immutable ShortBackStub <: BackStub end
immutable LongBackStub <: BackStub end

# Schedules
abstract DateSchedule
immutable SwapDateSchedule <: DateSchedule
    dates::Array{TimeType, 1}
    tenor::Period
    stub::Stub
    calendar::FinCalendar
    bdc::BusinessDayConvention
    eom::Bool
end

####
# Methods & constructors
####
function sign(stub::Stub)
    isa(stub, FrontStub) && (return -1)
    isa(stub, BackStub) && (return 1)
end

function SwapDateSchedule(dates::Array{TimeType, 1}, tenor::Period,
    stub = ShortFrontStub(), calendar = NoFCalendar(), bdc = Unadjusted(),
    eom = true)
    return SwapDateSchedule(dates, tenor, stub, calendar, bdc, eom)
end

function SwapDateSchedule(effectivedate::TimeType, terminationdate::TimeType,
    tenor::Period, stub = ShortFrontStub(), calendar = NoFCalendar(),
    bdc = Unadjusted(), eom = true)

    # Set up
    α = sign(stub)
    isa(stub, FrontStub) && (seeddate = terminationdate;
        exitdate = effectivedate)
    isa(stub, BackStub) && (seeddate = effectivedate;
        exitdate = terminationdate)
    i = 1; dates = [seed]

    # Unadjusted dates
    while dates[1] > exitdate
        insert!(dates, 1, [seed + α * i * tenor])
        i += 1
    end

    # Check if exit date is in dates and replace first element if not
    if !(exitdate in dates)
        isa(stub, FrontStub) && insert!(dates[2:end], 1, exitdate)
        isa(stub, BackStub) && push!(dates[1:(end - 1)], exitdate)
    end
    # EOM and other adjustments
    toeom = (month(adjust(seed+Day(1), Following(), calendar)) != month(seed) &&
        eom)
    toeom && (dates = [dates[1], lastdayofmonth(dates[2:(end - 1)]), dates[end]])
    dates = adjust(dates, bdc, calendar)

    # Return
    return SwapDateSchedule(dates, tenor, stub, calendar, bdc, eom)
end
