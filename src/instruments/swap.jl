###############################################################################
# Types
###############################################################################

abstract SwapLeg
type FixedSwapLeg <: SwapLeg
    amount::Float64
    currency::Currency
    schedule::SwapDateSchedule
    rate::Float64
end
type FloatingSwapLeg <: SwapLeg
    amount::Float64
    currency::Currency
    schedule::SwapDateSchedule
    ibor::IBOR
    ibor_margin::Float64
end

# N is number of legs
abstract Swap{N}
# TL1 and TL2 are the types of leg 1 and 2 respectively
type TwoLeggedSwap{T1<:FixedSwapLeg, T2<:FloatingSwapLeg} <: Swap{2}
    tradedate::TimeType
    leg1::T1
    leg2::T2
end
typealias FixedFloatingSwap TwoLeggedSwap{FixedSwapLeg, FloatingSwapLeg}

###############################################################################
# Methods
###############################################################################

function FixedFloatingSwap{TC<:Currency}(currency::Vector{TC}, term::Period,
    rate::Real, ibor::IBOR, trade_date::TimeType = EVAL_DATE,
    amount::Real = 1e6)

    ######
    # Input checking
    ######

    # Leg 1 is fixed, Leg 2 is float
    # `currency` must have length equivalent to number of legs.
    msg = "Currency must be a Currency vector of length two."
    length(currency) == 2 ||  throw(ArgumentError(msg))

    ######
    # Defaults
    ######

    # Assumes payment freqency of both legs is same as tenor of IBOR.
    tenor = ibor.tenor
    # Period end calendar. Join on all possible calendars' bad days. For eg
    # USD swap's period end dates are based on joint NYC (currency calendar) and
    # LON calendar (IBOR fixing calendar). Joining on ibor currency's calendar
    # just in case leg payments in one currency but based on ibor of another
    # currency (~ quanto style)
    calendar = join(currency[1].calendar, currency[2].calendar,
        ibor.currency.calendar, ibor.calendar)
    # All standard swaps trade Mod Following
    bdc = ModifiedFollowing()
    # Swaps typically have short front stubs (i.e. generate dates back
    # from termination date)
    stub = ShortFrontStub()
    # It seems as though most swaps do not trade EOM. However, OIS might and
    # potentially other GBP swaps. For time being assume this is false for all
    # swaps.
    eom = false

    ######
    # Constructing
    ######

    # Start and end dates are not adjusted.
    start_date = shift(trade_date, ibor.spotlag)
    end_date = shift(start_date, term)
    schedule = SwapDateSchedule(start_date, end_date, tenor, calendar,
        bdc, stub, eom)
    leg1 = FixedSwapLeg(amount, currency[1], schedule, rate)
    leg2 = FloatingSwapLeg(amount, currency[2], schedule, ibor, ibor_margin)
    FixedFloatingSwap(trade_date, leg1, leg2)
end

function FixedFloatingSwap(currency::Currency, term::Period,
    rate::Real, ibor::IBOR, trade_date::TimeType = EVAL_DATE,
    amount::Real = 1e6)
    FixedFloatingSwap([currency, currency], term, rate, ibor, trade_date, amount)
end

get_period_starts(fsl::SwapLeg) = get_period_starts(fsl.schedule)
get_period_ends(fsl::SwapLeg) = get_period_ends(fsl.schedule)
get_payment_dates(fsl::SwapLeg) = get_payment_dates(fsl.schedule)
function get_fixing_dates(fsl::FloatingSwapLeg)
    [shift(dt, -fsl.ibor.spotlag, fsl.ibor.bdc, fsl.ibor.calendar, fsl.ibor.eom)
        for dt in get_period_starts(fsl)]
end
get_forward_start_dates(fsl::FloatingSwapLeg) = get_period_starts(fsl)
function get_forward_end_dates(fsl::FloatingSwapLeg)
    [shift(dt, fsl.ibor.tenor, fsl.ibor.bdc, fsl.ibor.calendar, fsl.ibor.eom)
        for dt in get_forward_start_dates(fsl)]
end

get_period_starts(s::FixedFloatingSwap, first = true) = get_period_starts(
    first ? s.leg1 : s.leg2)
get_period_ends(s::FixedFloatingSwap, first = true) = get_period_starts(
    first ? s.leg1 : s.leg2)
get_fixing_dates(s::FixedFloatingSwap) = get_fixing_dates(s.leg2)
get_forward_start_dates(s::FixedFloatingSwap) = get_forward_start_dates(s.leg2)
get_forward_end_dates(s::FixedFloatingSwap) = get_forward_end_dates(s.leg2)
