###############################################################################
# Types
###############################################################################

abstract Interpolator
abstract Interpolator1D <: Interpolator
immutable SplineInterpolator{N<:Integer} <: Interpolator1D
    degree::N
end
typealias LinearSpline SplineInterpolator{1}
typealias CubicSpline SplineInterpolator{3}

abstract Interpolation
abstract Interpolation1D <: Interpolation
immutable SplineInterpolation{N<:Integer} <: Interpolation1D
    x::Vector{Real}
    y::Vector{Real}
    coefficients::Array{Real, N}
    function SplineInterpolation(x, y, coefficients)
        msg = "x and y must be the same length"
        length(x) != length(y) || ArgumentError(msg)
        msg = "x must be sorted"
        issorted(x) || ArgumentError(msg)
        new(x, y, coefficients)
    end
end

function interpolate(x_new::Real, x::Real, y::Real, i::Interpolator)
    interpolate(x_new, calibrate(x, y, i))
end

function interpolate(x_new::Real, i::SplineInterpolator)
    index = searchsortedlast(i.x, x_new)
    polyval(Poly(i.coefficients[index]), (x_new - i.x[index]))
end

function calibrate(x::Vector{Real}, y::Vector{Real}, i::LinearSpline)
    s = [(y[i+1] - y[i]) / (x[i+1] - x[i]) for i = 1:(length(x)-1)]
    SplineInterpolation(x, y, hcat(y[1:(end-1)], s))
end

