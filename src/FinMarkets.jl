module FinMarkets

if VERSION < v"0.4-"
    using Dates
else
    using Base.Dates
end
import DataFrames.DataFrame

export
    # constants.jl
    Simply, Annually, SemiAnnually, TriAnnually, Quarterly, BiMonthly,
    Monthly, Fortnightly, Weekly, Daily, Continuously,
    # times.jl
    DayCountFraction, A365, A360, ActActISDA, Thirty360, ThirtyE360,
    ThirtyEP360, years,
    # calendars.jl
    FinCalendar, SingleFCalendar, JointFCalendar, NoFCalendar,
    isweekend, isgood,
    # calendars_au.jl
    AUFCalendar, AUSYFCalendar, AUMEFCalendar,
    # calendars_us.jl
    USFCalendar, USNYFCalendar, USLIBORFCalendar,
    # calendars_gb.jl
    GBFCalendar, GBLOFCalendar,
    # calendars_eu.jl
    EUFCalendar, EUTAFCalendar, EULIBORFCalendar,
    # calendars_jp.jl
    JPFCalendar, JPTOFCalendar,
    # calendars_nz.jl
    NZFCalendar, NZAUFCalendar, NZWEFCalendar,
    # business_day_conventions.jl
    BusinessDayConvention, Unadjusted, Preceding, ModifiedPreceding,
    Following, ModifiedFollowing, Succeeding, adjust,
    # shifters.jl
    shift,
    # currencies.jl
    Currency, AUD, EUR, GBP, JPY, NZD, USD,
    # cashflow.jl
    CashFlow,
    # interestrates.jl
    InterestRate, DiscountFactor, equivalent
    # indices.jl
    Index, InterestRateIndex, IBOR, AUDBBSW, EURLIBOR, EURIBOR, GBPLIBOR,
    JPYLIBOR, JPYTIBOR, NZDBKBM, USDLIBOR,
    CashIndex, AONIA, EONIA, SONIA, TONAR, NZIONA, FedFund,
    # instruments.jl
    Instrument, Cash, Deposit, Future, STIRFuture,
    price,
    # schedule.jl
    Stub, FrontStub, BackStub, ShortFrontStub, LongFrontStub, ShortBackStub,
    LongBackStub, DateSchedule, SwapDateSchedule

include("constants.jl")
include("calendars.jl")
include("times.jl")
include("interestrates.jl")
include("businessdayconventions.jl")
include("shifters.jl")
include("schedule.jl")
include("currencies.jl")
include("cashflow.jl")
include("indices.jl")
include("instruments.jl")
end
