module FinancialMarkets

if VERSION < v"0.4-"
    using Dates
else
    using Base.Dates
end
using Polynomials: Poly, polyval
import DataFrames.DataFrame

export
    # times.jl
    A365, A360, ActActISDA, Thirty360, ThirtyE360, ThirtyEP360, years,
    # calendars.jl
    JointCalendar, NoCalendar, isweekend, isgood,
    # calendars_au.jl
    AUSYCalendar, AUMECalendar,
    # calendars_us.jl
    USNYCalendar, USLIBORCalendar,
    # calendars_gb.jl
    GBLOCalendar,
    # calendars_eu.jl
    EUTACalendar, EULIBORCalendar,
    # calendars_jp.jl
    JPTOCalendar,
    # calendars_nz.jl
    NZAUCalendar, NZWECalendar,
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
