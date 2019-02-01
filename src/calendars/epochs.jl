###############################################################################
### Easter methods
###############################################################################

function easter(y::Integer)
    # Using Meeus/Jones/Butcher algorithm
    # https://en.wikipedia.org/wiki/Computus#Anonymous_Gregorian_algorithm
    a = mod(y, 19)
    b = div(y, 100)
    cc = mod(y, 100)
    d = div(b, 4)
    e = mod(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    hh = mod(19a + b - d - g + 15, 30)
    i = div(cc, 4)
    k = mod(cc, 4)
    ll = mod(32 + 2e + 2i - hh - k, 7)
    m = div(a + 11hh + 22ll, 451)
    n = div(hh + ll - 7m + 114, 31)
    p = mod(hh + ll - 7m + 114, 31)
    return Date(y, n, p + 1)
end
easter(dt::TimeType) = easter(year(dt))

function easter(y::Integer, day::Integer)
    msg = "The day must be either Fri, Sat, Sun or Mon."
    day in [Fri, Sat, Sun, Mon] || throw(ArgumentError(msg))
    day == Fri && return easter(y) - Day(2)
    day == Sat && return easter(y) - Day(1)
    day == Sun && return easter(y)
    day == Mon && return easter(y) + Day(1)
end
easter(dt::TimeType, day::Integer) = easter(year(dt), day)

iseaster(dt::TimeType) = (easter(dt) == Date(dt))
iseaster(dt::TimeType, day::Integer) = (easter(dt, day) == Date(dt))

###############################################################################
### Seasonal epochs, solstices & equinox
###############################################################################

function seasonstart(y::Integer, m::Integer)
    # From Jean Meeus' Astronomical Algorithms (1st Ed, 1991). See Chapter 26.
    # Assertions
    msg = "Algorithm only valid for years between 1000 and 3000 A.D."
    1000 <= y <= 3000 || throw(ArgumentError(msg))
    msg = "Season starts must be Mar, Jun, Sep or Dec."
    m in [Mar, Jun, Sep, Dec] || throw(ArgumentError(msg))
    # Calculate mean time
    y = (y - 2000) / 1000
    k = SEASON[m]
    jde0 = 0
    for i in 1:length(k)
        jde0 += (y ^ (i - 1) * k[i])[1]
    end
    # Calculate corrections
    tt = (jde0 - 2451545) / 36525
    w = 35999.373tt - 2.47
    δλ = 1 + 0.0334cosd(w) + 0.0007cosd(2w)
    ss = 0
    for i in 1:length(SEASON_A)
        ss += SEASON_A[i] * cosd(SEASON_B[i] + SEASON_C[i] * tt)
    end
    # Convert from Julian day to calendar date
    return julian2datetime(jde0 + 0.00001ss / δλ)
end

seasonstart(dt::DateTime, m::Integer) = seasonstart(year(dt), m)
seasonstart(dt::Date, m::Integer) = Date(seasonstart(year(dt), m))

isseasonstart(dt::DateTime, m::Integer) = (seasonstart(dt, m) == dt)
isseasonstart(dt::Date, m::Integer) = (dt == seasonstart(dt, m))
