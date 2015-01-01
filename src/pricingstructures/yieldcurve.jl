###############################################################################
# Types
###############################################################################

abstract CurveInterpolators
immutable LinearRateCurveInterpolator <: CurveInterpolators
    interpolator::LinearSpline
    # Map time and zero rate values to values on which spline is calibrated
    f::Function
    # Map interpolated (calibrated) value back to zero rate
    invf::Function
    function LinearRateCurveInterpolator(i::LinearSpline = LinearSpline(),
        f::Function = (t,r)->r, invf::Function = (t,y)->y)
        f == (t,r)->r || throw(ArgumentError("f must be (t,r)->r"))
        invf == (t,y)->y || throw(ArgumentError("invf must be (t,y)->y"))
        new(i, f, invf)
    end
end
immutable LinearLogDFCurveInterpolator <: CurveInterpolators
    interpolator::LinearSpline
    # Map time and zero rate values to values on which spline is calibrated
    f::Function
    # Map interpolated (calibrated) value back to zero rate
    invf::Function
    function LinearLogDFCurveInterpolator(i::LinearSpline = LinearSpline(),
        f::Function = (t,r)->-t.*r, invf::Function = (t,y)->-y/t)
        f == (t,r)->-t.*r || throw(ArgumentError("f must be (t,r)->-t.*r"))
        invf == (t,y)->-y/t || throw(ArgumentError("invf must be (t,y)->-y/t"))
        new(i, f, invf)
    end
end
immutable CubicRateCurveInterpolator <: CurveInterpolators
    interpolator::CubicSpline
    # Map time and zero rate values to values on which spline is calibrated
    f::Function
    # Map interpolated (calibrated) value back to zero rate
    invf::Function
    function CubicRateCurveInterpolator(i::CubicSpline = NaturalCubicSpline(),
        f::Function = (t,r)->r, invf::Function = (t,y)->y)
        f == (t,r)->r || throw(ArgumentError("f must be (t,r)->r"))
        invf == (t,y)->y || throw(ArgumentError("invf must be (t,y)->y"))
        new(i, f, invf)
    end
end

type ZeroCurve <: PricingStructure
    reference_date::TimeType
    interpolation::FloatSplineInterpolation
    transformer::Function
    compounding::Compounding
    day_count::DayCountFraction
end

function ZeroCurve{T<:TimeType, S<:Real}(dt0::TimeType, dts::Vector{T},
    dfs::Vector{S}, i::CurveInterpolators, cmp::Compounding,
    dcf::DayCountFraction)
    xs = [years(dt0, dt, dcf) for dt in dts]
    ys = [value(InterestRate(DiscountFactor(dfs[i], dt0, dts[i]), cmp, dcf))
        for i=1:length(dts)]
    interpolation = calibrate(xs, i.f(xs, ys), i.interpolator)
    ZeroCurve(dt0, interpolation, i.invf, cmp, dcf)
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
    # Should throw error if dt is < reference date
    msg = "The date is before the curve's reference date."
    dt < zc.reference_date && throw(ArgumentError(msg))
    # Should always return a DiscountFactor
    t = years(zc.reference_date, dt, zc.day_count)
    # DF at time 0 should always be 1.0
    if t == 0
        return DiscountFactor(1.0, zc.reference_date, dt)
    else
        # Note given error capture about, else means > 0
        r = InterestRate(interpolate_helper(t, zc),
            zc.compounding, zc.day_count)
        return DiscountFactor(r, zc.reference_date, dt)
    end
end
