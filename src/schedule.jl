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

# Sources:
# 1. Opengamma: Interest rate instruments and market conventions guide
# 2. Quantlib.org

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
function Base.show(io::IO, schedule::SwapDateSchedule)
    show(io, schedule.dates)
end

function Base.sign(stub::Stub)
    isa(stub, FrontStub) && (return -1)
    isa(stub, BackStub) && (return 1)
end

function SwapDateSchedule(dates::Array{TimeType, 1}, tenor::Period,
    stub = ShortFrontStub(), calendar = NoFCalendar(), bdc = Unadjusted(),
    eom = false)
    return SwapDateSchedule(dates, tenor, stub, calendar, bdc, eom)
end

function SwapDateSchedule(effectivedate::TimeType, terminationdate::TimeType,
    tenor::Period, stub = ShortFrontStub(), calendar = NoFCalendar(),
    bdc = Unadjusted(), eom = false)

    # Set up
    α = sign(stub)
    isbackward = isa(stub, FrontStub)
    isbackward && (seeddate = terminationdate; exitdate = effectivedate)
    !isbackward && (seeddate = effectivedate; exitdate = terminationdate)
    i = 1; dates = [seeddate]

    # Unadjusted dates
    while isbackward $ (dates[1] < exitdate)
        newdate = seeddate + α * i * tenor
        dates = isbackward ? [newdate, dates] : [dates, newdate]
        i += 1
    end

    # Check if exit date is in dates and replace first/last element if not
    if !(exitdate in dates)
        dates = (isbackward ? [exitdate, dates[2:end]] :
            [dates[1:(end - 1)], exitdate])
    end
    # EOM and other adjustments
    toeom = (month(adjust(seeddate + Day(1), Following(), calendar)) !=
        month(seeddate) && eom)
    toeom && (dates = [dates[1], lastdayofmonth(dates[2:(end - 1)]),
        dates[end]])
    dates = [adjust(date, bdc, calendar) for date in dates]

    # Return
    return SwapDateSchedule(dates, tenor, stub, calendar, bdc, eom)
end
