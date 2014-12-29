###############################################################################
# Types
###############################################################################

# Source:
# Piecewise Polynomial Interpolation, Opengamma (v1, 2013)
# http://www.opengamma.com/blog/piecewise-polynomial-interpolation
abstract Interpolators
abstract Interpolators1D <: Interpolators
abstract SplineInterpolators <: Interpolators1D
immutable LinearSpline <: SplineInterpolators end
abstract CubicSpline <: SplineInterpolators
immutable ClampedCubicSpline <: CubicSpline
    α::Real
    β::Real
end
ClampedCubicSpline() = ClampedCubicSpline(0, 0)
immutable NaturalCubicSpline <: CubicSpline end
immutable NotAKnotCubicSpline <: CubicSpline end
abstract HermiteSplines <: SplineInterpolators
immutable AkimaSpline <: HermiteSplines end
immutable KrugerSpline <: HermiteSplines end
immutable FritschButlandSpline <: HermiteSplines end
immutable MonotoneConvexSpline <: SplineInterpolators end

abstract Extrapolators
immutable ConstantExtrapolator <: Extrapolators end
immutable  LinearExtrapolator <: Extrapolators end

abstract HymanFilters
immutable NonNegativeHymanFilter <: HymanFilters end
immutable MonotoneHymanFilter <: HymanFilters end

abstract Interpolation
abstract Interpolation1D <: Interpolation
immutable SplineInterpolation{T,S} <: Interpolation1D
    x::Vector{T}
    y::Vector{S}
    coefficients::Matrix{Real}
    function SplineInterpolation(x, y, coefficients)
        msg = "x and y must be the same length"
        length(x) != length(y) || ArgumentError(msg)
        msg = "x must be sorted"
        issorted(x) || ArgumentError(msg)
        new(x, y, coefficients)
    end
end
typealias RealSplineInterpolation SplineInterpolation{Real, Real}

###############################################################################
# Methods
###############################################################################

function interpolate(x_new::Real, i::RealSplineInterpolation)
    msg = string("x_new is not in the interpolator's domain. ",
        "You may wish to extrapolate.")
    is_e = is_extrapolated(i)
    # Fail if x_new is not in range of given x and no extrapolation is provided
    !is_e && !(i.x[1] <= x_new <= i.x[end]) && throw(ArgumentError(msg))
    # Find the largest x <= x_new
    index = searchsortedlast(i.x, x_new)
    if index == 0
        # x_new occurs before smallest x.
        polyval(Poly(vec(i.coefficients[1, :])), (x_new - i.x[1]))
    elseif index == length(i.x)
        # x_new occurs on or after largest x.
        polyval(Poly(vec(i.coefficients[end, :])), (x_new - i.x[end-1+is_e]))
    else
        # Need to shift coefficients index if i is extrpolated
        polyval(Poly(vec(i.coefficients[index+is_e, :])), (x_new - i.x[index]))
    end
end

function interpolate(x_new::TimeType, i::RealSplineInterpolation)
    interpolate(convert(Real, x_new), i)
end

function calibrate{T<:TimeType, S<:Real}(x::Vector{T}, y::Vector{S},
    i::SplineInterpolators)
    calibrate(Real[convert(Real, xi) for xi in x], y, i)
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S}, i::LinearSpline)
    RealSplineInterpolation(x, y, hcat(y[1:(end-1)], diff(y) ./ diff(x)))
end

function calibrate_cubic_spline{T<:Real, S<:Real, U<:Real, V<:Real}(
    x::Vector{T}, y::Vector{S}, A::SparseMatrixCSC{U}, b::Vector{V})
    m = A \ b
    h = diff(x)
    s = diff(y) ./ diff(x)
    mdiff = diff(m)
    mpop = m[1:(end-1)]
    a0 = y[1:(end-1)]
    a1 = s - h.*mpop / 2 - h.*mdiff / 6
    a2 = mpop / 2
    a3 = mdiff ./ h / 6
    RealSplineInterpolation(x, y, hcat(a0, a1, a2, a3))
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S},
    i::ClampedCubicSpline)
    h = diff(x)
    s = diff(y) ./ h
    diag = [2h[1], [2(h[i] + h[i+1]) for i=1:(length(h)-1)], 2h[end]]
    A = spdiagm((h, diag, h), (-1, 0, 1))
    b = 6 * [s[1] - i.α, diff(s), i.β - s[end]]
    calibrate_cubic_spline(x, y, A, b)
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S},
    i::NaturalCubicSpline)
    h = diff(x)
    s = diff(y) ./ h
    diag_left = [h[1:(end-1)], 0.]
    println("Type of diag_left: ", typeof(diag_left))
    println("diag_left: ", diag_left)
    diag = [1., [2.(h[i] + h[i+1]) for i=1:(length(h)-1)], 1.]
    println("Type of diag: ", typeof(diag))
    println("diag: ", diag)
    diag_right = [0., h[2:end]]
    println("Type of diag_right: ", typeof(diag_right))
    println("diag_right: ", diag_right)
    A = spdiagm((diag_left, diag, diag_right), (-1., 0., 1.))
    println("Type of A: ", typeof(A))
    println("A: ", A)
    b = 6. * [0., diff(s), 0.]
    calibrate_cubic_spline(x, y, A, b)
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S},
    i::NotAKnotCubicSpline)
    h = diff(x)
    s = diff(y) ./ h
    diag_l2 = [zeros(x[4:end]), -h[end]]
    diag_l1 = [h[1:(end-1)], h[end-1] + h[end]]
    diag = [-h[2], [2(h[i] + h[i+1]) for i=1:(length(h)-1)], -h[end-1]]
    diag_r1 = [h[1] + h[2], h[2:end]]
    diag_r2 = [-h[1], zeros(x[4:end])]
    A = spdiagm((diag_l2, diag_l1, diag, diag_r1, diag_r2), (-2, -1, 0, 1, 2))
    b = 6 * [0, diff(s), 0]
    calibrate_cubic_spline(x, y, A, b)
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S}, i::AkimaSpline)
    # Also using:
    # http://www.iue.tuwien.ac.at/phd/rottinger/node60.html
    N = length(x)
    h = diff(x)
    s = diff(y) ./ h
    s0 = 2s[1] - s[2]
    sm1 = 2s0 - s[1]
    sk = 2s[end] - s[end-1]
    skp1 = 2sk - s[end]
    sext = [sm1, s0, s, sk, skp1]
    sd = abs(diff(sext))
    yd = zeros(x)
    for i = 1:N
        if sd[i+2] == 0 && sd[i] == 0
            yd[i] = (sext[i+1] + sext[i+2]) / 2
        else
            yd[i] = (sd[i+2] * sext[i+1] + sd[i] * sext[i+2]) / (sd[i+2] + sd[i])
        end
    end
    a0 = y[1:end-1]
    a1 = yd[1:end-1]
    a2 = [(3s[i] - yd[i+1] - 2yd[i]) / h[i] for i=1:length(s)]
    a3 = [-(2s[i] - yd[i+1] - yd[i]) / h[i]^2 for i=1:length(s)]
    RealSplineInterpolation(x, y, hcat(a0, a1, a2, a3))
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S}, i::KrugerSpline)
    # The constrained cubic interpolator
    N = length(x)
    h = diff(x)
    s = diff(y) ./ h
    yd = zeros(x)
    for i=2:N-1
        sign_changed = s[i-1]s[i] <= 0
        sign_changed || (yd[i] = 2 / (1 / s[i-1] + 1 / s[i]))
        sign_changed && (yd[i] = 0)
    end
    yd[1] = 1.5s[1] - 0.5yd[2]
    yd[end] = 1.5s[end] - 0.5yd[end-1]
    a0 = y[1:end-1]
    a1 = yd[1:end-1]
    a2 = [(3s[i] - yd[i+1] - 2yd[i]) / h[i] for i=1:length(s)]
    a3 = [-(2s[i] - yd[i+1] - yd[i]) / h[i]^2 for i=1:length(s)]
    RealSplineInterpolation(x, y, hcat(a0, a1, a2, a3))
end

function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S},
    i::FritschButlandSpline)
    # Monotonicity preserving interpolator
    N = length(x)
    h = diff(x)
    s = diff(y) ./ h
    yd = zeros(x)
    for i=2:N-1
        if s[i-1]s[i] <= 0
            yd[i] = 0
        else
            invyd1 = (h[i-1] + 2h[i]) / (3(h[i] + h[i-1])) / s[i-1]
            invyd2 = (2h[i-1] + h[i]) / (3(h[i] + h[i-1])) / s[i]
            yd[i] = 1 / (invyd1 + invyd2)
        end
    end
    g0 = ((2h[1] + h[2])s[1] - h[1]s[2]) / (h[1] + h[2])
    gN = ((2h[end] + h[end-1])s[end] - h[end]s[end-1]) / (h[end] + h[end-1])
    if g0 * s[1] <= 0
        yd[1] = 0
    elseif s[1]s[2] <= 0 && abs(g0) > 3 * abs(s[end])
        yd[1] = 3s[1]
    else
        yd[1] = g0
    end
    if gN * s[end] <= 0
        yd[end] = 0
    elseif s[end]s[end-1] <= 0 && abs(gN) > 3 * abs(s[end])
        yd[end] = 3s[end]
    else
        yd[end] = gN
    end
    a0 = y[1:end-1]
    a1 = yd[1:end-1]
    a2 = [(3s[i] - yd[i+1] - 2yd[i]) / h[i] for i=1:length(s)]
    a3 = [-(2s[i] - yd[i+1] - yd[i]) / h[i]^2 for i=1:length(s)]
    RealSplineInterpolation(x, y, hcat(a0, a1, a2, a3))
end

# function calibrate{T<:Real, S<:Real}(x::Vector{T}, y::Vector{S},
#     i::MonotoneConvexSpline)
#     N = length(x)
#     xd = diff(x)
#     xyd = diff(x .* y)
#     Fd = xyd ./ xd
#     F = [(xd[i]Fd[i+1] + xd[i+1]Fd[i]) / (x[i+1] - x[i-1]) for i=1:N-1]
#     F = [Fd[1] - 0.5(F[1] - Fd[1]), F, Fd[end] - 0.5(F[end] - Fd[end])]

# end

# function non_negative_hyman_filter!(si::RealSplineInterpolation)
#     msg = "Hyman filter only implemented for cubic interpolators"
#     size(si.coefficients)[2] == 4 || throw(ArgumentError(msg))
#     h = diff(si.x)
#     σ = sign(si.coefficients[2:end, 1])
#     lo = -3σ .* si.coefficients[2:end, 1] ./ h[2:end]
#     hi =  3σ .* si.coefficients[2:end, 1] ./ h[1:end-1]
#     fd = σ .* si.coefficients[2:end, 2]
#     si.coefficients[2:end, 2] = (σ .*
#         [clamp(fd[i], lo[i], hi[i]) for i=1:length(fd)])
# end

# function monotonicity_hyman_filter!(si::RealSplineInterpolation)
#     # Using the Hyman published method, not the OpenGamma refinement.
#     msg = "Hyman filter only implemented for cubic interpolators"
#     N = size(si.coefficients)[2]
#     N == 4 || throw(ArgumentError(msg))
#     s = diff(si.y) ./ diff(si.x)
#     fd = si.coefficients
#     for i=1:N-1
#         σ = (s[i+1]s[i] > 0) ? sign(s[i+1]) : 0
#         if σ > 0
#             fd[i+1, 2] = min(max(0, fd[i+1, 2]),  3 * min(abs(s[i+1]), abs(s[i])))
#         elseif σ < 0
#             fd[i+1, 2] = max(min(0, fd[i+1, 2]), -3 * min(abs(s[i+1]), abs(s[i])))
#         else
#             fd[i+1, 2] = 0
#         end
#     end
# end

is_extrapolated(i::RealSplineInterpolation) = (length(i.x) + 1 ==
    size(i.coefficients, 1))

function extrapolate(i::RealSplineInterpolation, e::ConstantExtrapolator)
    msg = "The RealSplineInterpolation is already extrapolated"
    is_extrapolated(i) && throw(ArgumentError(msg))
    pre = zeros(i.coefficients[1, :])
    post = zeros(i.coefficients[1, :])
    pre[1] = i.y[1]
    post[1] = i.y[end]
    RealSplineInterpolation(i.x, i.y, vcat(pre, i.coefficients, post))
end

function extrapolate(i::RealSplineInterpolation, e::LinearExtrapolator)
    msg = "The RealSplineInterpolation is already extrapolated"
    is_extrapolated(i) && throw(ArgumentError(msg))
    pre = zeros(i.coefficients[1, :])
    post = zeros(i.coefficients[1, :])
    pre[1:2] = [i.y[1], i.coefficients[1, 2]]
    post[1:2] = [i.y[end], i.coefficients[end, 2]]
    RealSplineInterpolation(i.x, i.y, vcat(pre, i.coefficients, post))
end
