module FinancialMarkets

if VERSION < v"0.4-"
    using Dates
else
    using Base.Dates
end
using Polynomials: Poly, polyval
import DataFrames.DataFrame

export
    # constants.jl
    Simply, Annually, SemiAnnually, TriAnnually, Quarterly, BiMonthly,
    Monthly, Fortnightly, Weekly, Daily, Continuously,
    # times.jl
    A365, A360, ActActISDA, Thirty360, ThirtyE360, ThirtyEP360, years,
    # calendars.jl
    JointFCalendar, NoFCalendar, isweekend, isgood,
    # calendars_au.jl
    AUSYFCalendar, AUMEFCalendar,
    # calendars_us.jl
    USNYFCalendar, USLIBORFCalendar,
    # calendars_gb.jl
    GBLOFCalendar,
    # calendars_eu.jl
    EUTAFCalendar, EULIBORFCalendar,
    # calendars_jp.jl
    JPTOFCalendar,
    # calendars_nz.jl
    NZAUFCalendar, NZWEFCalendar,
    # business_day_conventions.jl
    Unadjusted, Preceding, ModifiedPreceding, Following, ModifiedFollowing,
    Succeeding, adjust,
    # shifters.jl
    shift,
    # currencies.jl
    AUD, EUR, GBP, JPY, NZD, USD,
    # cashflow.jl
    CashFlow,
    # interestrates.jl
    InterestRate, DiscountFactor,
    # indices.jl
    ONIA, AONIA, EONIA, SONIA, TONAR, NZIONA, FedFund,
    IBOR, AUDBBSW, EURLIBOR, EURIBOR, GBPLIBOR, JPYLIBOR, JPYTIBOR, NZDBKBM,
    USDLIBOR,
    # instruments.jl
    Cash, Deposit, Future, STIRFuture,
    price,
    # schedule.jl
    FrontStub, BackStub, ShortFrontStub, LongFrontStub, ShortBackStub,
    LongBackStub,SwapDateSchedule,
    # interpolators.jl
    LinearSpline, ClampedCubicSpline, NaturalCubicSpline, NotAKnotCubicSpline,
    AkimaSpline, KrugerSpline, FritschButlandSpline, SplineInterpolation,
    interpolate, calibrate

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
include("maths.jl")
end
