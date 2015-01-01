module FinancialMarkets

if VERSION < v"0.4-"
    using Dates
else
    using Base.Dates
end
using Polynomials: Poly, polyval
import DataFrames.DataFrame
# This needs to be imported so that tests pass using
# This shouldn't be necessary as Base is imported automatically.
# Julia Version 0.3.3
# Commit b24213b* (2014-11-23 20:19 UTC)
import Base.zeros

export
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
    Simply, Annually, SemiAnnually, TriAnnually, Quarterly, BiMonthly,
    Monthly, Fortnightly, Weekly, Daily, Continuously,
    InterestRate, DiscountFactor,
    # indices.jl
    ONIA, AONIA, EONIA, SONIA, TONAR, NZIONA, FedFund,
    IBOR, AUDBBSW, EURLIBOR, EURIBOR, GBPLIBOR, JPYLIBOR, JPYTIBOR, NZDBKBM,
    USDLIBOR,
    # interpolators.jl
    LinearSpline, ClampedCubicSpline, NaturalCubicSpline, NotAKnotCubicSpline,
    AkimaSpline, KrugerSpline, FritschButlandSpline, FloatSplineInterpolation,
    interpolate, calibrate,
    ConstantExtrapolator, LinearExtrapolator, extrapolate,
    # yieldcurve.jl
    LinearZeroRateInterpolator, LinearLogDFInterpolator,
    CubicZeroRateInterpolator, ZeroCurve,
    # schedule.jl
    FrontStub, BackStub, ShortFrontStub, LongFrontStub, ShortBackStub,
    LongBackStub,SwapDateSchedule,
    # instruments.jl
    Cash, Deposit, Future, STIRFuture,
    price

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
include("pricingstructures.jl")
end
