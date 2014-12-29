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

###############################################################################
# Methods
###############################################################################

## Extraction methods
get_zero{R<:Real}(t::R, zc::ZeroCurve) = zc.transformer(
    interpolate(t, zc.interpolation))

## Other methods
function interpolate{T<:TimeType}(dt::T, zc::ZeroCurve)
    # Should always return a DiscountFactor
    t = years(zc.reference_date, dt, zc.day_count)
    zr = InterestRate(get_zero(t, zc), zc.compounding, zc.day_count)
    DiscountFactor(zr, zc.reference_date, dt)
end
