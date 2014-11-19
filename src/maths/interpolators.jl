###############################################################################
# Types
###############################################################################

# Source:
# Piecewise Polynomial Interpolation, Opengamma (v1, 2013)
# http://www.opengamma.com/blog/piecewise-polynomial-interpolation
abstract Interpolator
abstract Interpolator1D <: Interpolator
abstract SplineInterpolator <: Interpolator1D
immutable LinearSpline <: SplineInterpolator end
abstract CubicSpline <: SplineInterpolator
immutable ClampedCubicSpline <: CubicSpline
    α::Real
    β::Real
end
ClampedCubicSpline() = ClampedCubicSpline(0, 0)
immutable NaturalCubicSpline <: CubicSpline end
immutable NotAKnotCubicSpline <: CubicSpline end

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

###############################################################################
# Methods
###############################################################################

function interpolate(x_new::Real, x::Vector{Real}, y::Vector{Real}, i::Interpolator)
    interpolate(x_new, calibrate(x, y, i))
end

function interpolate(x_new::Real, i::SplineInterpolation)
    index = searchsortedlast(i.x, x_new)
    index < 1 && (index = 1)
    index > size(i.coefficients)[1] && (index = size(i.coefficients)[1])
    polyval(Poly(vec(i.coefficients[index, :])), (x_new - i.x[index]))
end

function calibrate(x::Vector{Real}, y::Vector{Real}, i::LinearSpline)
    SplineInterpolation(x, y, hcat(y[1:(end-1)], diff(y) ./ diff(x)))
end

function calibrate_cubic_spline(x::Vector{Real}, y::Vector{Real}, m::Vector{Real})
    h = diff(x)
    s = diff(y) ./ diff(x)
    mdiff = diff(m)
    mpop = m[1:(end-1)]
    a0 = y[1:(end-1)]
    a1 = s - h.*mpop / 2 - h.*mdiff / 6
    a2 = mpop / 2
    a3 = mdiff ./ h / 6
    SplineInterpolation(x, y, hcat(a0, a1, a2, a3))
end

function calibrate(x::Vector{Real}, y::Vector{Real}, i::ClampedCubicSpline)
    h = diff(x)
    s = diff(y) ./ h
    diag = [2h[1], [2(h[i] + h[i+1]) for i=1:(length(h)-1)], 2h[end]]
    A = spdiagm((h, diag, h), (-1, 0, 1))
    b = 6 * [s[1] - i.α, diff(s), i.β - s[end]]
    m = A \ b
    calibrate_cubic_spline(x, y, m)
end

function calibrate(x::Vector{Real}, y::Vector{Real}, i::NaturalCubicSpline)
    h = diff(x)
    s = diff(y) ./ h
    diag_left = [h[1:(end-1)], 0]
    diag = [1, [2(h[i] + h[i+1]) for i=1:(length(h)-1)], 1]
    diag_right = [0, h[2:end]]
    A = spdiagm((diag_left, diag, diag_right), (-1, 0, 1))
    b = 6 * [0, diff(s), 0]
    m = A \ b
    calibrate_cubic_spline(x, y, m)
end

function calibrate(x::Vector{Real}, y::Vector{Real}, i::NotAKnotCubicSpline)
    h = diff(x)
    s = diff(y) ./ h
    diag_l2 = [zeros(x[4:end]), -h[end]]
    diag_l1 = [h[1:(end-1)], h[end-1] + h[end]]
    diag = [-h[2], [2(h[i] + h[i+1]) for i=1:(length(h)-1)], -h[end-1]]
    diag_r1 = [h[1] + h[2], h[2:end]]
    diag_r2 = [-h[1], zeros(x[4:end])]
    A = spdiagm((diag_l2, diag_l1, diag, diag_r1, diag_r2), (-2, -1, 0, 1, 2))
    b = 6 * [0, diff(s), 0]
    m = A \ b
    calibrate_cubic_spline(x, y, m)
end
