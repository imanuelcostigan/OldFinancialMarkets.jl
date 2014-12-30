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

# zctransforms returns tuple of two functions that:
# 1. Map time and zero rate values to values on which spline is calibrated
# 2. Map interpolated (calibrated) value back to zero rate
zctransforms(i::LinearRateCurveInterpolator) = ((t,r)->r, (t,y)->y)
zctransforms(i::LinearLogDFCurveInterpolator) =  ((t,r)->-t.*r, (t,y)->-y/t)
zctransforms(i::CubicRateCurveInterpolator) = ((t,r)->r, (t,y)->y)

function ZeroCurve{T<:TimeType, S<:Real}(dt0::TimeType, dts::Vector{T},
    dfs::Vector{S}, i::CurveInterpolators, cmp::Compounding,
    dcf::DayCountFraction)
    xs = [years(dt0, dt, dcf) for dt in dts]
    ys = [value(InterestRate(DiscountFactor(dfs[i], dt0, dts[i]), cmp, dcf))
        for i=1:length(dts)]
    to_cal, from_cal = zctransforms(i)
    ZeroCurve(dt0, calibrate(xs, to_cal(xs, ys), i.interpolator), from_cal,
        cmp, dcf)
end

function ZeroCurve(dt0::TimeType, dfs::Vector{DiscountFactor},
    i::CurveInterpolators, cmp::Compounding, dcf::DayCountFraction)
    dts = [df.enddate for df in dfs]
    dfs = [value(df) for df in dfs]
    ZeroCurve(dt0, dts, dfs, i, cmp, dcf)
end

###############################################################################
# Methods
###############################################################################

interpolate_helper{R<:Real}(t::R, zc::ZeroCurve) = zc.transformer(t,
    interpolate(t, zc.interpolation))

function interpolate{T<:TimeType}(dt::T, zc::ZeroCurve)
    # Should always return a DiscountFactor
    t = years(zc.reference_date, dt, zc.day_count)
    r = InterestRate(interpolate_helper(t, zc), zc.compounding, zc.day_count)
    DiscountFactor(r, zc.reference_date, dt)
end
