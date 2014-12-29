###############################################################################
# Types
###############################################################################

abstract CurveInterpolators
immutable LinearRateCurveInterpolator <: CurveInterpolators
    interpolator::LinearSpline
end
LinearRateCurveInterpolator() = LinearRateCurveInterpolator(LinearSpline())
immutable LinearLogDFCurveInterpolator <: CurveInterpolators
    interpolator::LinearSpline
end
LinearLogDFCurveInterpolator() = LinearLogDFCurveInterpolator(LinearSpline())
immutable CubicRateCurveInterpolator <: CurveInterpolators
    interpolator::CubicSpline
end
CubicRateCurveInterpolator() = CubicRateCurveInterpolator(NaturalCubicSpline())

type ZeroCurve <: PricingStructure
    reference_date::TimeType
    interpolation::FloatSplineInterpolation
    transformer::Function
    compounding::Compounding
    day_count::DayCountFraction
end

function ZeroCurve(dt0::TimeType, dfs::Vector{DiscountFactor},
    i::CurveInterpolators, cmp::Compounding, dcf::DayCountFraction)
    dts = [df.enddate for df in dfs]
    dfs = [value(df) for df in dfs]
    ZeroCurve(dt0, dts, dfs, i, cmp, dcf)
end

function ZeroCurve{T<:TimeType, S<:Real}(dt0::TimeType, dts::Vector{T},
    dfs::Vector{S}, i::LinearRateCurveInterpolator, cmp::Compounding,
    dcf::DayCountFraction)
    xs = [years(dt0, dt, dcf) for dt in dts]
    ys = [value(InterestRate(DiscountFactor(dfs[i], dt0, dts[i]), cmp, dcf))
        for i=1:length(dts)]
    ZeroCurve(dt0, calibrate(xs, ys, i.interpolator), x->x, cmp, dcf)
end

function ZeroCurve{T<:TimeType, S<:Real}(dt0::TimeType, dts::Vector{T},
    dfs::Vector{S}, i::LinearLogDFCurveInterpolator, cmp::Compounding,
    dcf::DayCountFraction)
    xs = [years(dt0, dt, dcf) for dt in dts]
    ys = [value(InterestRate(DiscountFactor(dfs[i], dt0, dts[i]), cmp, dcf))
        for i=1:length(dts)]
    ZeroCurve(dt0, calibrate(xs, -xs .* ys, i.interpolator),
        (x,xy)->-xy/x, cmp, dcf)
end

function ZeroCurve{T<:TimeType, S<:Real}(dt0::TimeType, dts::Vector{T},
    dfs::Vector{S}, i::CubicRateCurveInterpolator, cmp::Compounding,
    dcf::DayCountFraction)
    xs = [years(dt0, dt, dcf) for dt in dts]
    ys = [value(InterestRate(DiscountFactor(dfs[i], dt0, dts[i]), cmp, dcf))
        for i=1:length(dts)]
    ZeroCurve(dt0, calibrate(xs, ys, i.interpolator), x->x, cmp, dcf)
end

# interpolation calibrated from zeros
# provide only one or other of zeros or dfs to improve consistency between them
# ZeroCurve(refdate, pillar_dates, zero_rates, zc_interpolation)
# ZeroCurve(refdate, pillar_dates, discount_factors, zc_interpolation)

###############################################################################
# Methods
###############################################################################

## Extraction methods
pillars(zc::ZeroCurve) = [df.enddate for df in zc.discount_factors]
zeros(zc::ZeroCurve) = [InterestRate(df, zcw.compounding, zc.day_count)
    for df in zc.discount_factors]

## Other methods
function interpolate{T<:TimeType}(dt::T, zc::ZeroCurve)
    # Should always return a DiscountFactor
    t = years(zc.refdate, dt, zc.day_count)
    DiscountFactor(zc.transformer(t, interpolate(t, zc.i)),
        zc.refdate, dt)
end
