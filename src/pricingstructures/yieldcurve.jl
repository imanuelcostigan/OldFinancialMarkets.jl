###############################################################################
# Types
###############################################################################

abstract ZCInterpolators
immutable ZCLinearInterpolator <: ZCInterpolators end
immutable ZCLogLinearInterpolator <: ZCInterpolators end
immutable ZCCubicInterpolator <: ZCInterpolators end

type ZeroCurve <: PricingStructure
    reference_date::TimeType
    compounding::Int
    day_count::DayCountFraction
    discount_factors::Vector{DiscountFactor}
    interpolation::SplineInterpolation
    zc_interpolation::ZCInterpolators
    function ZeroCurve(rd, pd, zr, df, i, zci)
        # Enforce:
        # 0. DF start dates the same
        # 1. DF end dates in strictly ascending order
        # 2. homogenous zero rate compounding/day basis
        # 3. interpolation xs are same as year(rd, get_pillar_dates, get_day_count)
    end
end

# interpolation calibrated from zeros
# provide only one or other of zeros or dfs to improve consistency between them
ZeroCurve(reference_date, pillar_dates, zero_rates, zc_interpolation)
ZeroCurve(reference_date, pillar_dates, discount_factors, zc_interpolation)

###############################################################################
# Methods
###############################################################################

get_day_count(zc::ZeroCurve) = zc.zero_rates[1].daycount
get_pillar_dates(zc::ZeroCurve) = [df.enddate for df in zc.discount_factors]
get_zero_rates(zc::ZeroCurve) = [InterestRate(df, zc.compounding, zc.day_count)
    for df in zc.discount_factors]

## Should always return discount factor
function interpolate{T<:TimeType}(dt::T, zc::ZeroCurve)
    t = years(dt, get_pillar_dates(zc), get_day_count(zc))
    DiscountFactor(interpolate(t, zc.i),
end
