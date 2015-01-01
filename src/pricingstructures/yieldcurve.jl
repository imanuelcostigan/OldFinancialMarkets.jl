###############################################################################
# Curve interpolant types
###############################################################################

abstract ZeroCurveInterpolants
immutable ZeroRateInterpolant <: ZeroCurveInterpolants
    # Map time and zero rate values to values on which spline is calibrated
    f::Function
    # Map interpolated (calibrated) value back to zero rate
    invf::Function
    function ZeroRateInterpolant(f = (t,r)->r, invf = (t,y)->y)
        f == (t,r)->r || throw(ArgumentError("f must be (t,r)->r"))
        invf == (t,y)->y || throw(ArgumentError("invf must be (t,y)->y"))
        new(f, invf)
    end
end
immutable LogDFInterpolant <: ZeroCurveInterpolants
    f::Function
    invf::Function
    function LogDFInterpolant(f = (t,r)->-t.*r, invf = (t,y)->-y/t)
        f == (t,r)->-t.*r || throw(ArgumentError("f must be (t,r)->-t.*r"))
        invf == (t,y)->-y/t || throw(ArgumentError("invf must be (t,y)->-y/t"))
        new(f, invf)
    end
end

###############################################################################
# Curve interpolator types
###############################################################################

immutable ZeroCurveInterpolator{S<:SplineInterpolators, C<:ZeroCurveInterpolants}
    interpolator::S
    interpolant::C
end

typealias LinearZeroRateInterpolator ZeroCurveInterpolator{LinearSpline,
    ZeroRateInterpolant}
typealias LinearLogDFInterpolator ZeroCurveInterpolator{LinearSpline,
    LogDFInterpolant}
typealias CubicZeroRateInterpolator ZeroCurveInterpolator{CubicSpline,
    ZeroRateInterpolant}

LinearZeroRateInterpolator() = LinearZeroRateInterpolator(LinearSpline(),
    ZeroRateInterpolant())
LinearLogDFInterpolator() = LinearLogDFInterpolator(LinearSpline(),
    LogDFInterpolant())
CubicZeroRateInterpolator() = CubicZeroRateInterpolator(NaturalCubicSpline(),
    ZeroRateInterpolant())

mapper(i::ZeroCurveInterpolator) = i.interpolant.f
unmapper(i::ZeroCurveInterpolator) = i.interpolant.invf
interpolator(i::ZeroCurveInterpolator) = i.interpolator

###############################################################################
# Zero Curve type
###############################################################################

type ZeroCurve <: PricingStructure
    reference_date::TimeType
    interpolator::ZeroCurveInterpolator
    compounding::Compounding
    day_count::DayCountFraction
    interpolation::FloatSplineInterpolation
end

mapper(zc::ZeroCurve) = mapper(zc.interpolator)
unmapper(zc::ZeroCurve) = unmapper(zc.interpolator)
interpolator(zc::ZeroCurve) = interpolator(zc.interpolator)

function ZeroCurve{T<:TimeType, S<:Real}(dt0::TimeType, dts::Vector{T},
    dfs::Vector{S}, i::ZeroCurveInterpolator, cmp::Compounding,
    dcf::DayCountFraction)
    xs = [years(dt0, dt, dcf) for dt in dts]
    ys = [value(InterestRate(DiscountFactor(dfs[i], dt0, dts[i]), cmp, dcf))
        for i=1:length(dts)]
    interpolation = calibrate(xs, mapper(i)(xs, ys), interpolator(i))
    ZeroCurve(dt0, i, cmp, dcf, interpolation)
end

function ZeroCurve(dt0::TimeType, dfs::Vector{DiscountFactor},
    i::ZeroCurveInterpolator, cmp::Compounding, dcf::DayCountFraction)
    dts = [df.enddate for df in dfs]
    dfs = [value(df) for df in dfs]
    ZeroCurve(dt0, dts, dfs, i, cmp, dcf)
end

###############################################################################
# Methods
###############################################################################

function interpolate_helper{R<:Real}(t::R, zc::ZeroCurve)
    unmapper(zc)(t, interpolate(t, zc.interpolation))
end

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
