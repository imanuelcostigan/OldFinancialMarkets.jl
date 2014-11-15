###############################################################################
# Types
###############################################################################

abstract Interpolator
abstract Interpolator1D <: Interpolator
abstract SplineInterpolator <: Interpolator1D
immutable LinearSpline <: SplineInterpolator end
immutable CubicSpline <: SplineInterpolator end

abstract Interpolation
abstract Interpolation1D <: Interpolation
immutable SplineInterpolation <: Interpolation1D
    x::Vector{Real}
    y::Vector{Real}
    coefficients::Matrix{Real}
    function SplineInterpolation(x, y, coefficients)
        msg = "x and y must be the same length"
        length(x) != length(y) || ArgumentError(msg)
        msg = "x must be sorted"
        issorted(x) || ArgumentError(msg)
        new(x, y, coefficients)
    end
end

function interpolate{T<:Real}(x_new::T, x::Vector{T}, y::Vector{T}, i::Interpolator)
    interpolate(x_new, calibrate(x, y, i))
end

function interpolate(x_new::Real, i::SplineInterpolation)
    index = searchsortedlast(i.x, x_new)
    polyval(Poly(i.coefficients[index]), (x_new - i.x[index]))
end

function calibrate{T<:Real}(x::Vector{T}, y::Vector{T}, i::LinearSpline)
    s = [(y[i+1] - y[i]) / (x[i+1] - x[i]) for i = 1:(length(x)-1)]
    SplineInterpolation(x, y, hcat(y[1:(end-1)], s))
end

